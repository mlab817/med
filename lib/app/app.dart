import 'package:flutter/material.dart';
import 'package:med/presentation/main/main.dart';
import 'package:med/presentation/resources/routes_manager.dart';
import 'package:med/presentation/resources/theme_manager.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getApplicationThem(),
      onGenerateRoute: RouteGenerator.getRoute,
      initialRoute: Routes.splashRoute,
      // Routes.splashRoute,
      home: const MainPage(),
    );
  }
}
