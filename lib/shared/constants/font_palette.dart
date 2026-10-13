
import 'package:flutter/material.dart';
import 'package:knowledge_vault_app/shared/constants/colors.dart';

class FontPalette {
  static const themeFont="Manrope";
  static TextTheme get textLightTheme{
    final base=Typography.material2021().black;
    return base.copyWith(
      bodyMedium: base.bodyMedium?.copyWith(fontFamily:themeFont),
      titleMedium: base.titleMedium?.copyWith(fontFamily:themeFont ),
      titleLarge: base.titleLarge?.copyWith(fontFamily: themeFont)
    );
  }
  static TextTheme get textDarkTheme{
    final base = Typography.material2021().white;
    return base.copyWith(
      bodyMedium: base.bodyMedium?.copyWith(fontFamily: themeFont),
      titleMedium: base.titleMedium?.copyWith(fontFamily: themeFont),
      titleLarge: base.titleLarge?.copyWith(fontFamily: themeFont)
    );
  }
  static TextStyle hW400S14=TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: kBlack
  );
   static TextStyle hW400S16=TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: kBlack
  );
   static TextStyle hW400S18=TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: kBlack
  );
   static TextStyle hW500S13=TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    color: kBlack
  );
    static TextStyle hW500S16=TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    color: kBlack
  );
    static TextStyle hW700S16=TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    color: kBlack
  );
     static TextStyle hW700S26=TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    color: kBlack
  );
     static TextStyle hW700S32=TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    color: kBlack
  );
       static TextStyle hW800S26=TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    letterSpacing: 0,
    color: kBlack
  );
}