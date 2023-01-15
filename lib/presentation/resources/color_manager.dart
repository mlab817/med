import 'package:flutter/material.dart';

class ColorManager {
  static Color black = HexColor.fromHex("#211F23");
  static Color gray = HexColor.fromHex("#dce2e8");
  static Color lightgray = HexColor.fromHex("#f3f3f3");
  static Color green = HexColor.fromHex("##5CB85C");
  static Color violet = HexColor.fromHex("#4F46E5");
  static Color blue = HexColor.fromHex("#0b2875");
  static Color white = HexColor.fromHex("#ffffff");
  static Color darkgray = HexColor.fromHex("#A9A9A9");
  static Color red = HexColor.fromHex("#D9534F");
  static Color lightred = HexColor.fromHex("#dc3535");
  static Color peach = HexColor.fromHex("#E24C2C");
  static Color primary = HexColor.fromHex("#0b2875");
}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString = 'FF$hexColorString'; // FF stands for opacity
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}
