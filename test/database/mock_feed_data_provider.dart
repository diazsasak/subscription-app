import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:subscription_app/app/data/models/feed.dart';
import 'package:subscription_app/app/data/models/feed_paginate.dart';
import 'package:subscription_app/app/data/models/provider_response.dart';
import 'package:subscription_app/app/data/models/subscribe_response.dart';
import 'package:subscription_app/app/domain/providers/ifeed_provider.dart';

const baseUrl = 'http://gerador-nomes.herokuapp.com/nomes/10';

class MockFeedProvider implements IFeedProvider {
  @override
  Future<ProviderResponse> getFeedList(
      {int page, int limit, String keyword}) async {
    var feeds = [
      Feed(id: 1, feedName: 'Feed 1'),
      Feed(id: 2, feedName: 'Feed 2'),
      Feed(id: 3, feedName: 'Feed 3'),
      Feed(id: 4, feedName: 'Feed 4'),
      Feed(id: 5, feedName: 'Feed 5'),
      Feed(id: 6, feedName: 'Feed 6'),
      Feed(id: 7, feedName: 'Feed 7'),
      Feed(id: 8, feedName: 'Feed 8'),
      Feed(id: 9, feedName: 'Feed 9'),
      Feed(id: 10, feedName: 'Feed 10'),
      Feed(id: 11, feedName: 'Feed 11'),
      Feed(id: 12, feedName: 'Feed 12'),
      Feed(id: 13, feedName: 'Feed 13'),
      Feed(id: 14, feedName: 'Feed 14'),
      Feed(id: 15, feedName: 'Feed 15'),
      Feed(id: 16, feedName: 'Feed 16'),
      Feed(id: 17, feedName: 'Feed 17'),
      Feed(id: 18, feedName: 'Feed 18'),
      Feed(id: 19, feedName: 'Feed 19'),
      Feed(id: 20, feedName: 'Feed 20'),
      Feed(id: 21, feedName: 'Feed 21'),
    ];
    return ProviderResponse(
        status: true, data: FeedPaginate(total: feeds.length, feeds: feeds));
  }

  @override
  Future<ProviderResponse> subscribeFeed({int feedId}) async {
    return ProviderResponse(
        status: true, data: SubscribeResponse(id: 'subsId1', feedId: 1));
  }
}
