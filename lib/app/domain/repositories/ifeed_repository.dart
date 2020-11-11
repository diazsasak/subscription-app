import 'package:subscription_app/app/data/models/provider_response.dart';
import 'package:meta/meta.dart';

abstract class IFeedRepository {
  Future<ProviderResponse> getFeedList(
      {@required int page, @required int limit, String keyword});

  Future<ProviderResponse> subscribeFeed({@required int feedId});
}
