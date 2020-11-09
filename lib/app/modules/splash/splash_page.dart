import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subscription_app/app/routes/app_routes.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(
        Duration(
          seconds: 2,
        ), () {
      Get.offNamed(Routes.DASHBOARD);
    });
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Icon(
              Icons.subscriptions,
              color: Colors.white,
              size: 30.0,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            'Subscription App',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
