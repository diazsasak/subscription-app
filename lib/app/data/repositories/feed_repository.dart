import 'package:meta/meta.dart';
import 'package:subscription_app/app/data/models/provider_response.dart';
import 'package:subscription_app/app/data/providers/feed_api_provider.dart';

class FeedRepository {
  final FeedApiProvider apiClient;

  FeedRepository({@required this.apiClient}) : assert(apiClient != null);

  Future<ProviderResponse> getFeedList({@required int page, @required int limit, String keyword}) {
    return apiClient.getFeedList(page: page, limit: limit, keyword: keyword);
  }

  Future<ProviderResponse> subscribeFeed({@required int feedId}) {
    return apiClient.subscribeFeed(feedId: feedId);
  }
}
