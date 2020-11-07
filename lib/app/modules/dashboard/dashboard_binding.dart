import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:subscription_app/app/data/providers/feed_api_provider.dart';
import 'package:subscription_app/app/data/repositories/feed_repository.dart';
import 'package:subscription_app/app/modules/dashboard/dashboard_controller.dart';

class DashboardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardCtrl>(
      () => DashboardCtrl(
        feedRepository: FeedRepository(
          apiClient: FeedApiProvider(
            httpClient: Client(),
          ),
        ),
      ),
    );
  }
}
