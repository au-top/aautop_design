/// style less
///
/// 存放 一些由 function 生成widget的方法
/// 大部分都只是用于对widget风格参数的管理
/// 而不是自建 widget
/// 自建 widget 因存放在对应page的文件夹下
/// 或者位于 tool/widget 中

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

const mainWarningColor = Colors.red;
const mainInvalidColor = Color.fromRGBO(173, 173, 173, 1.0);
const mainColor = Colors.blue;
const mainIconColor = Colors.black54;

const mainTextColor = Color.fromRGBO(20, 20, 20, 1);
const mainTextColorLow = Color.fromRGBO(100, 100, 100, 1);
const mainTextColorLess = Color.fromRGBO(232, 232, 232, 1);

const h1TextStyle = TextStyle(fontSize: 20, color: mainTextColor);

const h2TextStyle = TextStyle(fontSize: 18, color: mainTextColor);
const h2TextStyleMin = TextStyle(fontSize: 17, color: mainTextColor);

const h3TextStylePlus = TextStyle(fontSize: 16, color: mainTextColor);
const h3TextStyle = TextStyle(fontSize: 16, color: mainTextColor);

const h4TextStyle = TextStyle(fontSize: 15, color: mainTextColor);
const h4TextStyleLow = TextStyle(fontSize: 15, color: mainTextColorLow);

const h5TextStyle = TextStyle(fontSize: 14, color: mainTextColor);
const h5TextStyleBold = TextStyle(fontSize: 14, color: mainTextColor, fontWeight: FontWeight.bold);

const h6TextStyle = TextStyle(
  fontSize: 13,
  color: mainTextColor,
);
const h6TextStyleLow = TextStyle(
  fontSize: 13,
  color: mainTextColorLow,
);
const h6TextStyleLowBold = TextStyle(fontSize: 13, color: mainTextColorLow, fontWeight: FontWeight.bold);

const h7TextStyle = TextStyle(
  fontSize: 12,
  color: mainTextColor,
);
const h7TextStyleLow = TextStyle(
  fontSize: 12,
  color: mainTextColorLow,
);
const h8TextStyleLow = TextStyle(
  fontSize: 11,
  color: mainTextColorLow,
);

/// set paint debug mode
const debugPaint = false;

ThemeData buildRootThemeData(BuildContext context) => ThemeData(
      highlightColor: Colors.transparent,
      // splashColor: const Color.fromRGBO(30, 30,30, 0.1),
      splashColor: Colors.blueGrey.withOpacity(0.1),
      scrollbarTheme: ScrollbarThemeData(
        thickness: MaterialStateProperty.all(7),
      ),
      // splashFactory: InkRipple.splashFactory,
      hoverColor: Colors.transparent,
      chipTheme: buildChipThemeData(context),
      fontFamily: "Microsoft Yahei UI",
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          textStyle: MaterialStateProperty.all(h6TextStyle),
          elevation: MaterialStateProperty.all(0),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 24),
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(color: Colors.transparent),
      textTheme: const TextTheme(
        bodyText1: h6TextStyle,
        bodyText2: h6TextStyle,
        headline1: h1TextStyle,
        headline2: h2TextStyle,
        headline3: h3TextStyle,
        headline4: h4TextStyle,
        headline5: h5TextStyle,
        headline6: h6TextStyle,
      ),
      iconTheme: const IconThemeData(color: mainIconColor),
      inputDecorationTheme: const InputDecorationTheme(
        isDense: true,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
      }),
    );

ChipThemeData buildChipThemeData(BuildContext bc) => ChipThemeData(
      backgroundColor: Colors.lightBlueAccent,
      padding: const EdgeInsets.only(
        left: 6,
        right: 6,
        bottom: 1,
      ),
      labelPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      selectedColor: Colors.blue,
      secondaryLabelStyle: h6TextStyle,
      labelStyle: h7TextStyle.copyWith(color: Colors.white),
      brightness: Theme.of(bc).brightness,
      disabledColor: Colors.black38,
      secondarySelectedColor: Colors.blue,
    );
