import 'package:flutter/material.dart';
import 'package:med/presentation/resources/color_manager.dart';
import 'package:med/presentation/resources/size_manager.dart';

import '../../data/health_tips.dart';

class TipDetail extends StatelessWidget {
  const TipDetail({Key? key, required this.tip}) : super(key: key);

  final Tip tip;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: const Text('Tip for Today'),
        centerTitle: true,
        elevation: AppSize.s0,
        backgroundColor: ColorManager.primary,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: AppSize.s10,
            ),
            Text(
              tip.title,
              style: TextStyle(
                fontSize: FontSize.s24,
                fontWeight: FontWeight.w600,
                color: ColorManager.primary,
              ),
            ),
            const SizedBox(
              height: AppSize.s10,
            ),
            Image.asset(tip.image),
            const SizedBox(
              height: AppSize.s10,
            ),
            SizedBox(
              // padding: const EdgeInsets.all(AppPadding.p12),
              height: AppSize.s300,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(AppPadding.p12),
                  child: Text(
                    tip.longDescription,
                    style: const TextStyle(fontSize: FontSize.s16),
                  ),
                ),
              ),
            ),
            Text(
              'Scroll down for more information',
              style: TextStyle(
                fontSize: FontSize.s14,
                color: ColorManager.darkgray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
