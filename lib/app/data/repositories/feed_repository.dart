import 'package:meta/meta.dart';
import 'package:subscription_app/app/data/models/provider_response.dart';
import 'package:subscription_app/app/domain/providers/ifeed_provider.dart';
import 'package:subscription_app/app/domain/repositories/ifeed_repository.dart';

class FeedRepository implements IFeedRepository {
  final IFeedProvider apiClient;

  FeedRepository({@required this.apiClient}) : assert(apiClient != null);

  @override
  Future<ProviderResponse> getFeedList({@required int page, @required int limit, String keyword}) {
    return apiClient.getFeedList(page: page, limit: limit, keyword: keyword);
  }

  @override
  Future<ProviderResponse> subscribeFeed({@required int feedId}) {
    return apiClient.subscribeFeed(feedId: feedId);
  }
}
