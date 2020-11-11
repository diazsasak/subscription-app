import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:subscription_app/app/data/providers/feed_api_provider.dart';
import 'package:subscription_app/app/data/repositories/feed_repository.dart';
import 'package:subscription_app/app/modules/dashboard/dashboard_controller.dart';
import 'package:subscription_app/app/settings/server_address.dart';
import 'package:http/http.dart' as http;

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
  group('Filter Test', () {
    test('Subscription state should be synced after feed list is updated',
        () async {
      final feedsResponse = [
        {'id': 1, 'feedName': 'Feed 1'},
        {'id': 2, 'feedName': 'Feed 2'},
        {'id': 11, 'feedName': 'Feed 11'},
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
      var oldState = ctrl.feedPaginate.feeds.firstWhere((f) => f.id == 1);
      expect(
          ctrl
              .feedPaginate
              .feeds[ctrl.feedPaginate.feeds
                  .indexWhere((f) => f.id == oldState.id)]
              .subscriptionId,
          isNotNull);
      ctrl.filterByFeedName(feedName: 'Feed 1');
      var newState = ctrl.feedPaginate.feeds.firstWhere((f) => f.id == 1);
      expect(
          ctrl
              .feedPaginate
              .feeds[ctrl.feedPaginate.feeds
                  .indexWhere((f) => f.id == newState.id)]
              .subscriptionId,
          isNotNull);
      expect(ctrl.numberOfSubscribedFeed, 1);
    });
  });
}
