import 'package:flutter/material.dart';
import 'package:med/presentation/home/home.dart';
import 'package:med/presentation/hotlines/hotlines.dart';
import 'package:med/presentation/medicine/medicine.dart';
import 'package:med/presentation/onboarding/onboarding.dart';
import 'package:med/presentation/splash/splash.dart';
import 'package:med/presentation/tip/tip.dart';

import '../notification/notification.dart';

class Routes {
  static const String homeRoute = "/home";
  static const String onboardingRoute = "/onboarding";
  static const String splashRoute = "/splash";
  static const String medicineRoute = "/medicine";
  static const String tipRoute = "/tip";
  static const String hotlinesRoute = "/hotlines";
  static const String notificationsRoute = "/notifications";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case Routes.homeRoute:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case Routes.onboardingRoute:
        return MaterialPageRoute(builder: (_) => const OnboardingPage());
      case Routes.medicineRoute:
        return MaterialPageRoute(builder: (_) => const MedicinePage());
      case Routes.tipRoute:
        return MaterialPageRoute(builder: (_) => const TipPage());
      case Routes.hotlinesRoute:
        return MaterialPageRoute(builder: (_) => const HotlinesPage());
      case Routes.notificationsRoute:
        return MaterialPageRoute(builder: (_) => const NotificationPage());
      default:
        return _undefinedRoute();
    }
  }

  static Route<dynamic> _undefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text("Not Found"),
        ),
        body: const Center(
          child: Text("Not Found"),
        ),
      ),
    );
  }
}
