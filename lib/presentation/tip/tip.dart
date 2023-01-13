import 'package:flutter/material.dart';
import 'package:med/data/health_tips.dart';
import 'package:med/presentation/resources/color_manager.dart';
import 'package:med/presentation/tip_detail/tip_detail.dart';

import '../resources/size_manager.dart';

class TipPage extends StatefulWidget {
  const TipPage({super.key});

  @override
  State<TipPage> createState() => _TipPageState();
}

class _TipPageState extends State<TipPage> {
  late Tip _randomTip;

  void _getRandomTip() {
    setState(() {
      _randomTip = HealthCareTip.getRandomTip();
    });
  }

  @override
  void initState() {
    super.initState();
    _getRandomTip();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        backgroundColor: ColorManager.white,
        elevation: AppSize.s0,
        leading: CloseButton(
          color: ColorManager.blue,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Tip for Today!',
              style: TextStyle(
                color: ColorManager.blue,
                fontWeight: FontWeight.w500,
                fontSize: AppSize.s24,
              ),
            ),
            const SizedBox(height: AppSize.s50),
            SizedBox(
              height: AppSize.s150,
              child: Hero(
                tag: 'tipPhoto',
                child: Image.asset(_randomTip.image),
              ), //Lottie.asset(JsonAssets.tipJson, fit: BoxFit.contain),
            ),
            const SizedBox(height: AppSize.s20),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSize.s24,
              ),
              child: Text(
                _randomTip.title,
                style: TextStyle(
                  color: ColorManager.blue,
                  fontSize: FontSize.s20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              height: AppSize.s150,
              child: SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.all(AppPadding.p12),
                child: Text(
                  _randomTip.shortDescription,
                  style: const TextStyle(
                    fontSize: FontSize.s18,
                  ),
                ),
              )),
            ),
            if (_randomTip.longDescription != null)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.primary,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TipDetail(tip: _randomTip),
                    ),
                  );
                },
                child: const Text('Read More'),
              ),
          ],
        ),
      ),
    );
  }
}
