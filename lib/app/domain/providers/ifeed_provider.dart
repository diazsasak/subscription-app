import 'package:meta/meta.dart';
import 'package:subscription_app/app/data/models/provider_response.dart';

abstract class IFeedProvider {
  Future<ProviderResponse> getFeedList(
      {@required int page, @required int limit, String keyword});

  Future<ProviderResponse> subscribeFeed({@required int feedId});

}
