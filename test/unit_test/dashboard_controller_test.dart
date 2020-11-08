import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mockito/mockito.dart';
import 'package:subscription_app/app/data/models/feed.dart';
import 'package:subscription_app/app/data/providers/feed_api_provider.dart';
import 'package:subscription_app/app/data/repositories/feed_repository.dart';
import 'package:subscription_app/app/modules/dashboard/dashboard_controller.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  MockClient client;
  DashboardCtrl ctrl;
  setUp(() {
    client = MockClient();
    ctrl = DashboardCtrl(
        feedRepository:
            FeedRepository(apiClient: FeedApiProvider(httpClient: client)));
  });

  group('DashboardCtrl', () {
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
      when(client.get(
              'http://192.168.43.105:3000/api/v1/feeds?_page=1&_limit=10&_sort=id'))
          .thenAnswer((_) async => http.Response(json.encode(mapJson), 200,
              headers: {'x-total-count': '21'}));
      expect(ctrl.feedPaginate, isNull);
      ctrl.getFeedList(initial: true);
      await Future.delayed(Duration(milliseconds: 500));
      expect(ctrl.feedPaginate, isNotNull);
    });

    test(
        'numberOfSubscribedFeed should be increased and subscriptionId should not be null when subscribe a feed',
        () async {
      final feedsResponse = [
        {'id': 1, 'feedName': 'Feed 1'}
      ];
      when(client.get(
              'http://192.168.43.105:3000/api/v1/feeds?_page=1&_limit=10&_sort=id'))
          .thenAnswer((_) async => http.Response(
              json.encode(feedsResponse), 200,
              headers: {'x-total-count': '21'}));
      ctrl.getFeedList(initial: true);
      await Future.delayed(Duration(milliseconds: 500));
      expect(ctrl.numberOfSubscribedFeed, 0);
      final subscribeResponse = {"id": "subsId1", "feedId": 1};
      when(client.get('http://192.168.43.105:3000/api/v1/feed/1/subscribe'))
          .thenAnswer(
              (_) async => http.Response(json.encode(subscribeResponse), 200));
      ctrl.toggleSubscribe(feed: ctrl.feedPaginate.feeds[0]);
      await Future.delayed(Duration(milliseconds: 500));
      expect(ctrl.numberOfSubscribedFeed, 1);
      expect(ctrl.feedPaginate.feeds[0].subscriptionId, isNotNull);
    });
  });

  test(
      'numberOfSubscribedFeed should be decreased and subscriptionId should be null when unsubscribe a feed',
      () async {
    final feedsResponse = [
      {'id': 1, 'feedName': 'Feed 1'}
    ];
    when(client.get(
            'http://192.168.43.105:3000/api/v1/feeds?_page=1&_limit=10&_sort=id'))
        .thenAnswer((_) async => http.Response(json.encode(feedsResponse), 200,
            headers: {'x-total-count': '21'}));
    ctrl.getFeedList(initial: true);
    await Future.delayed(Duration(milliseconds: 500));
    expect(ctrl.numberOfSubscribedFeed, 0);
    final subscribeResponse = {"id": "subsId1", "feedId": 1};
    when(client.get('http://192.168.43.105:3000/api/v1/feed/1/subscribe'))
        .thenAnswer(
            (_) async => http.Response(json.encode(subscribeResponse), 200));
    ctrl.toggleSubscribe(feed: ctrl.feedPaginate.feeds[0]);
    await Future.delayed(Duration(milliseconds: 500));
    expect(ctrl.numberOfSubscribedFeed, 1);
    ctrl.toggleSubscribe(feed: ctrl.feedPaginate.feeds[0]);
    expect(ctrl.numberOfSubscribedFeed, 0);
    expect(ctrl.feedPaginate.feeds[0].subscriptionId, isNull);
  });

  test('Subscription state should be synced after feed list is updated',
      () async {
    final feedsResponse = [
      {'id': 1, 'feedName': 'Feed 1'},
      {'id': 2, 'feedName': 'Feed 2'},
      {'id': 11, 'feedName': 'Feed 11'},
    ];
    when(client.get(
            'http://192.168.43.105:3000/api/v1/feeds?_page=1&_limit=10&_sort=id'))
        .thenAnswer((_) async => http.Response(json.encode(feedsResponse), 200,
            headers: {'x-total-count': '21'}));
    ctrl.getFeedList(initial: true);
    await Future.delayed(Duration(milliseconds: 500));
    expect(ctrl.numberOfSubscribedFeed, 0);
    final subscribeResponse = {"id": "subsId1", "feedId": 1};
    when(client.get('http://192.168.43.105:3000/api/v1/feed/1/subscribe'))
        .thenAnswer(
            (_) async => http.Response(json.encode(subscribeResponse), 200));
    ctrl.toggleSubscribe(feed: ctrl.feedPaginate.feeds[0]);
    await Future.delayed(Duration(milliseconds: 500));
    expect(ctrl.numberOfSubscribedFeed, 1);
    Feed oldState = ctrl.feedPaginate.feeds.firstWhere((f) => f.id == 1);
    expect(
        ctrl
            .feedPaginate
            .feeds[
                ctrl.feedPaginate.feeds.indexWhere((f) => f.id == oldState.id)]
            .subscriptionId,
        isNotNull);
    ctrl.filterByFeedName(feedName: 'Feed 1');
    Feed newState = ctrl.feedPaginate.feeds.firstWhere((f) => f.id == 1);
    expect(
        ctrl
            .feedPaginate
            .feeds[
                ctrl.feedPaginate.feeds.indexWhere((f) => f.id == newState.id)]
            .subscriptionId,
        isNotNull);
    expect(ctrl.numberOfSubscribedFeed, 1);
  });
}
