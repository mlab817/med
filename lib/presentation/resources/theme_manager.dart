import 'package:flutter/material.dart';
import 'package:med/presentation/resources/color_manager.dart';
import 'package:med/presentation/resources/font_manager.dart';
import 'package:med/presentation/resources/size_manager.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    fontFamily: FontConstants.fontFamily,
    primaryColor: ColorManager.primary,
    disabledColor: ColorManager.gray,
    colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: ColorManager.gray),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      color: ColorManager.primary,
      elevation: AppSize.s4,
    ),
  );
}
