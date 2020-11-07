import 'package:get/get.dart';
import 'package:subscription_app/app/modules/dashboard/dashboard_binding.dart';
import 'package:subscription_app/app/modules/dashboard/dashboard_page.dart';
import 'package:subscription_app/app/modules/splash/splash_page.dart';
import 'package:subscription_app/app/routes/app_routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(name: Routes.SPLASH, page: () => SplashPage()),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => DashboardPage(),
      binding: DashboardBinding(),
    ),
  ];
}
