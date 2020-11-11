import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:subscription_app/app/data/models/feed_paginate.dart';
import 'package:subscription_app/app/data/models/provider_response.dart';
import 'package:subscription_app/app/data/providers/feed_api_provider.dart';

void main() {
  group('fetchFeed', () {
    test(
        'return ProviderResponse<FeedPaginate> if the http call completes successfully',
        () async {
      final client = MockClient((request) async {
        final mapJson = [
          {'id': 1, 'feedName': 'Feed 1'}
        ];
        return http.Response(json.encode(mapJson), 200,
            headers: {'x-total-count': '21'});
      });

      final provider = FeedApiProvider(httpClient: client);
      var response = await provider.getFeedList(page: 1, limit: 10);
      expect(response, isA<ProviderResponse<FeedPaginate>>());
      expect(response.status, isTrue);
    });

    test(
        'return ProviderResponse<String> if the http call completes with an error',
        () async {
      final client = MockClient((request) async {
        return http.Response('not found', 404);
      });

      final provider = FeedApiProvider(httpClient: client);
      var response = await provider.getFeedList(page: 1, limit: 10);
      expect(response, isA<ProviderResponse<String>>());
      expect(response.status, false);
    });
  });
}
