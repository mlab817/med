import 'package:flutter/material.dart';
import 'package:med/presentation/resources/routes_manager.dart';

import 'notification/notification.dart';

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
      initialRoute: Routes.notificationsRoute,
      // Routes.splashRoute,
      home: const NotificationPage(),
    );
  }
}
