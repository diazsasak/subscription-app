import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:subscription_app/app/data/providers/feed_api_provider.dart';
import 'package:subscription_app/app/data/repositories/feed_repository.dart';
import 'package:subscription_app/app/modules/dashboard/dashboard_controller.dart';
import 'package:subscription_app/app/settings/server_address.dart';

import 'mock_client.dart';

void main() {
  MockClient client;
  DashboardCtrl ctrl;
  setUp(() {
    client = MockClient();
    ctrl = DashboardCtrl(
        feedRepository:
            FeedRepository(apiClient: FeedApiProvider(httpClient: client)));
  });

  group('Dashboard Controller Test', () {
    test('search should be hidden at the first time', () {
      expect(ctrl.isSearchEnabled, isFalse);
    });

    test('search should be visible when toggled', () {
      ctrl.setSearch();
      expect(ctrl.isSearchEnabled, isTrue);
    });

    test('feedPaginate should be null at the first time', () {
      expect(ctrl.feedPaginate, isNull);
    });

    test('feedPaginate should not be null after get feed list', () async {
      final mapJson = [
        {'id': 1, 'feedName': 'Feed 1'}
      ];
      when(client
              .get('$SERVER_ADDRESS/api/v1/feeds?_page=1&_limit=10&_sort=id'))
          .thenAnswer((_) async => http.Response(json.encode(mapJson), 200,
              headers: {'x-total-count': '21'}));
      expect(ctrl.feedPaginate, isNull);
      await ctrl.getFeedList(initial: true);
      await Future.delayed(Duration(milliseconds: 500));
      expect(ctrl.feedPaginate, isNotNull);
      expect(ctrl.feedPaginate.total, isNotNull);
      expect(ctrl.feedPaginate.feeds, isNotNull);
    });

    test(
        'numberOfSubscribedFeed should be increased and subscriptionId should not be null when subscribe a feed',
        () async {
      final feedsResponse = [
        {'id': 1, 'feedName': 'Feed 1'}
      ];
      when(client
              .get('$SERVER_ADDRESS/api/v1/feeds?_page=1&_limit=10&_sort=id'))
          .thenAnswer((_) async => http.Response(
              json.encode(feedsResponse), 200,
              headers: {'x-total-count': '21'}));
      await ctrl.getFeedList(initial: true);
      await Future.delayed(Duration(milliseconds: 500));
      expect(ctrl.numberOfSubscribedFeed, 0);
      final subscribeResponse = {'id': 'subsId1', 'feedId': 1};
      when(client.get('$SERVER_ADDRESS/api/v1/feed/1/subscribe')).thenAnswer(
          (_) async => http.Response(json.encode(subscribeResponse), 200));
      ctrl.toggleSubscribe(feed: ctrl.feedPaginate.feeds[0]);
      await Future.delayed(Duration(milliseconds: 500));
      expect(ctrl.numberOfSubscribedFeed, 1);
      expect(ctrl.feedPaginate.feeds[0], isNotNull);
      expect(ctrl.feedPaginate.feeds[0].subscriptionId, isNotNull);
      expect(ctrl.feedPaginate.feeds[0].id, isNotNull);
      expect(ctrl.feedPaginate.feeds[0].feedName, isNotNull);
    });

    test(
        'numberOfSubscribedFeed should be decreased and subscriptionId should be null when unsubscribe a feed',
        () async {
      final feedsResponse = [
        {'id': 1, 'feedName': 'Feed 1'}
      ];
      when(client
              .get('$SERVER_ADDRESS/api/v1/feeds?_page=1&_limit=10&_sort=id'))
          .thenAnswer((_) async => http.Response(
              json.encode(feedsResponse), 200,
              headers: {'x-total-count': '21'}));
      await ctrl.getFeedList(initial: true);
      expect(ctrl.numberOfSubscribedFeed, 0);
      final subscribeResponse = {'id': 'subsId1', 'feedId': 1};
      when(client.get('$SERVER_ADDRESS/api/v1/feed/1/subscribe')).thenAnswer(
          (_) async => http.Response(json.encode(subscribeResponse), 200));
      ctrl.toggleSubscribe(feed: ctrl.feedPaginate.feeds[0]);
      await Future.delayed(Duration(milliseconds: 500));
      expect(ctrl.numberOfSubscribedFeed, 1);
      ctrl.toggleSubscribe(feed: ctrl.feedPaginate.feeds[0]);
      expect(ctrl.numberOfSubscribedFeed, 0);
      expect(ctrl.feedPaginate.feeds[0], isNotNull);
      expect(ctrl.feedPaginate.feeds[0].subscriptionId, isNull);
      expect(ctrl.feedPaginate.feeds[0].id, isNotNull);
      expect(ctrl.feedPaginate.feeds[0].feedName, isNotNull);
    });
  });
}
