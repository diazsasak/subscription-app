import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:subscription_app/app/data/models/feed.dart';
import 'package:subscription_app/app/data/models/feed_paginate.dart';
import 'package:subscription_app/app/data/models/provider_response.dart';
import 'package:subscription_app/app/data/models/subscribe_response.dart';
import 'package:subscription_app/app/domain/providers/ifeed_provider.dart';
import 'package:subscription_app/app/settings/server_address.dart';

const baseUrl = '$SERVER_ADDRESS/api/v1';

class FeedApiProvider implements IFeedProvider {
  final http.Client httpClient;

  FeedApiProvider({@required this.httpClient}) : assert(httpClient != null);

  @override
  Future<ProviderResponse> getFeedList(
      {@required int page, @required int limit, String keyword}) async {
    try {
      var url = '$baseUrl/feeds?_page=$page&_limit=$limit&_sort=id';
      if (keyword != null) {
        url += '&feedName_like=$keyword';
      }
      var r = await httpClient.get(url);
      var response = _setupResponse(r);
      if (response['status']) {
        return ProviderResponse<FeedPaginate>(
          status: true,
          data: FeedPaginate(
            total: int.parse(r.headers['x-total-count']),
            feeds:
                (response['data'] as List).map((e) => Feed.fromMap(e)).toList(),
          ),
        );
      } else {
        return ProviderResponse.generalError;
      }
    } catch (e) {
      print('the error: ' + e.toString());
      return ProviderResponse.generalError;
    }
  }

  @override
  Future<ProviderResponse> subscribeFeed({@required int feedId}) async {
    try {
      var r = await httpClient.get('$baseUrl/feed/$feedId/subscribe');
      var response = _setupResponse(r);
      if (response['status']) {
        return ProviderResponse<SubscribeResponse>(
          status: true,
          data: SubscribeResponse.fromMap(response['data']),
        );
      } else {
        return ProviderResponse.generalError;
      }
    } catch (e) {
      print('the error: ' + e.toString());
      return ProviderResponse.generalError;
    }
  }

  Map<String, dynamic> _setupResponse(http.Response response) {
    var responseData = <String, dynamic>{};
    // print(response.request.url);
    print(response.statusCode);
    // print(response.body);
    if (response.statusCode != 200) {
      responseData['status'] = false;
      if (response.statusCode == 500) {
        responseData['data'] = 'Something went wrong, please try again.';
      } else if (response.statusCode == 404) {
        responseData['data'] = 'Server not found.';
      } else if (response.statusCode == 403) {
        responseData['data'] = 'No access.';
      } else if (response.statusCode == 401) {
        responseData['data'] = 'Unauthorized.';
      }
    } else {
      responseData['status'] = true;
      responseData['data'] = json.decode(response.body);
    }
    return responseData;
  }
}
