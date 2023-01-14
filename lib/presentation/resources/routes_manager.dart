import 'package:flutter/material.dart';
import 'package:med/data/models/reminder_model.dart';
import 'package:med/presentation/edit_reminder/edit_reminder.dart';
import 'package:med/presentation/main/main.dart';
import 'package:med/presentation/medicine/medicine.dart';
import 'package:med/presentation/notifications/notifications.dart';
import 'package:med/presentation/onboarding/onboarding.dart';
import 'package:med/presentation/resources/strings_manager.dart';
import 'package:med/presentation/show_reminder/show_reminder.dart';
import 'package:med/presentation/splash/splash.dart';
import 'package:med/presentation/tip/tip.dart';

class Routes {
  static const String homeRoute = "/home";
  static const String onboardingRoute = "/onboarding";
  static const String splashRoute = "/splash";
  static const String medicineRoute = "/medicine";
  static const String tipRoute = "/tip";
  static const String hotlinesRoute = "/hotlines";
  static const String historyRoute = "/history";
  static const String mainRoute = "/main";
  static const String showReminderRoute = "/showReminder";
  static const String editReminderRoute = "/editReminder";
  static const String notificationsRoute = "/notifications";
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
      case Routes.showReminderRoute:
        final String uuid = routeSettings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ShowReminderPage(uuid: uuid),
          fullscreenDialog: true,
        );
      case Routes.editReminderRoute:
        final Reminder reminder = routeSettings.arguments as Reminder;
        return MaterialPageRoute(
          builder: (_) => EditReminderPage(reminder: reminder),
        );
      case Routes.notificationsRoute:
        return MaterialPageRoute(builder: (_) => const NotificationsPage());
      default:
        return _undefinedRoute();
    }
  }

  static Route<dynamic> _undefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.notFound),
        ),
        body: const Center(
          child: Text(AppStrings.notFound),
        ),
      ),
    );
  }
}
