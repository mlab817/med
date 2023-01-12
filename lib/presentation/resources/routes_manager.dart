import 'package:flutter/material.dart';
import 'package:med/presentation/main/main.dart';
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
  static const String historyRoute = "/history";
  static const String mainRoute = "/main";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case Routes.mainRoute:
        return MaterialPageRoute(builder: (_) => const MainPage());
      case Routes.onboardingRoute:
        return MaterialPageRoute(builder: (_) => const OnboardingPage());
      case Routes.tipRoute:
        return MaterialPageRoute(builder: (_) => const TipPage());
      case Routes.medicineRoute:
        return MaterialPageRoute(builder: (_) => const MedicinePage());
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
