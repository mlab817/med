import 'package:flutter/material.dart';
import 'package:med/presentation/onboarding/onboarding.dart';
import 'package:med/presentation/resources/routes_manager.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Poppins",
      ),
      onGenerateRoute: RouteGenerator.getRoute,
      initialRoute: Routes.splashRoute,
      home: const OnboardingPage(),
    );
  }
}
