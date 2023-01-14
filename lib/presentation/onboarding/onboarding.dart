import 'package:flutter/material.dart';
import 'package:med/app/di.dart';
import 'package:med/app/preferences.dart';
import 'package:med/presentation/resources/color_manager.dart';
import 'package:med/presentation/resources/routes_manager.dart';
import 'package:med/presentation/resources/size_manager.dart';

import '../resources/assets_manager.dart';
import '../resources/strings_manager.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  final PageController _pageController = PageController();

  List<OnboardingData> onboardingData = [
    OnboardingData(AppStrings.welcome, AppStrings.hereToHelp, ImageAssets.ob1),
    OnboardingData(AppStrings.takeYourMedicinesOnTime,
        AppStrings.setUpYourAlarm, ImageAssets.ob2),
    OnboardingData(AppStrings.haveAHealthyLifestyle,
        AppStrings.developHealthyLifestyle, ImageAssets.ob3),
  ];

  int _currentIndex = 0;

  // set onboardingScreenViewed on first open
  _setOnBoardingScreenViewed() async {
    _appPreferences.setOnBoardingScreenViewed();
  }

  @override
  void initState() {
    // run_bind()
    _setOnBoardingScreenViewed();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _getBody(),
      bottomSheet: _getBottomSheet(),
    );
  }

  Widget _getBody() {
    return PageView.builder(
      scrollDirection: Axis.horizontal,
      controller: _pageController,
      itemCount: onboardingData.length,
      onPageChanged: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      itemBuilder: (context, index) {
        return _buildOnboardingPage();
      },
    );
  }

  Widget _buildOnboardingPage() {
    OnboardingData currentSlide = onboardingData[_currentIndex];

    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          Image.asset(
            currentSlide.image,
            height: 200.0,
          ),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
              child: Center(
                  child: Text(
            currentSlide.title,
            style: TextStyle(
              fontSize: AppSize.s24,
              color: ColorManager.blue,
            ),
            textAlign: TextAlign.center,
          ))),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(AppPadding.p24),
            child: Text(
              currentSlide.description,
              style: const TextStyle(fontSize: FontSize.s20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getBottomSheet() {
    return Container(
      padding: const EdgeInsets.all(AppPadding.p8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _currentIndex == 0
                ? null
                : () {
                    setState(() {
                      if (_currentIndex > 0) {
                        _currentIndex--;
                      }
                    });
                  },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(
                  _currentIndex == 0
                      ? Icons.circle_rounded
                      : Icons.circle_outlined,
                  size: AppSize.s16,
                  color: ColorManager.darkgray,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(
                  _currentIndex == 1
                      ? Icons.circle_rounded
                      : Icons.circle_outlined,
                  size: AppSize.s16,
                  color: ColorManager.darkgray,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(
                  _currentIndex == 2
                      ? Icons.circle_rounded
                      : Icons.circle_outlined,
                  size: AppSize.s16,
                  color: ColorManager.darkgray,
                ),
              ),
            ],
          ),
          (_currentIndex == onboardingData.length - 1)
              ? TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, Routes.mainRoute);
                  },
                  child: const Text(AppStrings.proceed))
              : IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    setState(
                      () {
                        if (_currentIndex < onboardingData.length - 1) {
                          _currentIndex++;
                        }
                      },
                    );
                  },
                ),
        ],
      ),
    );
  }
}

class OnboardingData {
  String title;

  String description;

  String image;

  OnboardingData(this.title, this.description, this.image);
}
