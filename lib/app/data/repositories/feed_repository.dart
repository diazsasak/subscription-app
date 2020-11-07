import 'package:meta/meta.dart';
import 'package:subscription_app/app/data/providers/feed_api_provider.dart';

class FeedRepository {
  final FeedApiProvider apiClient;

  FeedRepository({@required this.apiClient}) : assert(apiClient != null);

  getFeedList({@required int page, String keyword}) {
    return apiClient.getFeedList(page: page, keyword: keyword);
  }

  subscribeFeed({@required int feedId}) {
    return apiClient.subscribeFeed(feedId: feedId);
  }
}
