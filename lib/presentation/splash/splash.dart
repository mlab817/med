import 'dart:async';

import 'package:flutter/material.dart';
import 'package:med/presentation/resources/routes_manager.dart';

import '../resources/assets_manager.dart';
import '../resources/size_manager.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;

  void _startDelay() {
    _timer = Timer(const Duration(seconds: 2), _goNext);
  }

  void _goNext() {
    Navigator.pushReplacementNamed(context, Routes.onboardingRoute);
  }

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(ImageAssets.icon, height: AppSize.s200,),
      ),
    );
  }
}
