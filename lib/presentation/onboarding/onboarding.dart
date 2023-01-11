import 'package:flutter/material.dart';
import 'package:med/app/di.dart';
import 'package:med/app/preferences.dart';
import 'package:med/presentation/resources/color_manager.dart';
import 'package:med/presentation/resources/routes_manager.dart';
import 'package:med/presentation/resources/size_manager.dart';

import '../resources/assets_manager.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  final PageController _pageController = PageController();

  List<OnboardingData> onboardingData = [
    OnboardingData(
        "Welcome to Lifeline360",
        "We're here to help you to aid the forgetful and busy with remembering to take your daily medications. It is designed for users who need help keeping track of their medication schedule and who are dedicated to keeping the schedule.",
        ImageAssets.ob1),
    OnboardingData(
        "Take your Medicines On Time",
        "Set up your alarm by picking the Date and Time of intake along with your Medicine Name, Illness Name, Amount, and kind of Medicine.",
        ImageAssets.ob2),
    OnboardingData(
        "Have a Healthy Lifestyle",
        "We let you develop your Healthy Lifestyle by giving you a Everyday. Tips in improving your health and avoid getting sickness.",
        ImageAssets.ob3),
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
            padding: const EdgeInsets.all(24.0),
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
      padding: const EdgeInsets.all(8.0),
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
          // TextButton(
          //   onPressed: () {
          //     Navigator.pushReplacementNamed(context, Routes.homeRoute);
          //   },
          //   child: const Text('Skip'),
          // ),
          (_currentIndex == onboardingData.length - 1)
              ? TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, Routes.homeRoute);
                  },
                  child: const Text('Proceed'))
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
