import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subscription_app/app/modules/splash/splash_page.dart';
import 'package:subscription_app/app/routes/app_pages.dart';
import 'package:subscription_app/app/theme/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      darkTheme: ThemeData.dark(),
      title: 'Subscription App',
      debugShowCheckedModeBanner: false,
      theme: theme,
      defaultTransition: Transition.cupertino,
      getPages: AppPages.pages,
      home: SplashPage(),
    );
  }
}
