import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:subscription_app/app/data/models/provider_response.dart';
import 'package:subscription_app/app/data/models/subscribe_response.dart';
import 'package:subscription_app/app/data/providers/feed_api_provider.dart';

void main() {
  group('subscribeFeed', () {
    test(
        'return ProviderResponse<SubscribeResponse> if the http call completes successfully',
        () async {
      final client = MockClient((request) async {
        final mapJson = {'id': 'subsId1', 'feedId': 1};
        return http.Response(json.encode(mapJson), 200);
      });
      final provider = FeedApiProvider(httpClient: client);

      expect(await provider.subscribeFeed(feedId: 1),
          isA<ProviderResponse<SubscribeResponse>>());
    });

    test(
        'return ProviderResponse<String> if the http call completes with an error',
        () async {
      final client = MockClient((request) async {
        return http.Response('not found', 404);
      });

      final provider = FeedApiProvider(httpClient: client);

      expect(await provider.subscribeFeed(feedId: 1),
          isA<ProviderResponse<String>>());
    });
  });
}
