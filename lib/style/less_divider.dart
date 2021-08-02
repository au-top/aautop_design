import 'package:flutter/material.dart';

Widget buildLessDivider({double? height, Color? color, EdgeInsets? margin}) {
  return Builder(
    builder: (bc) => Container(
      width: double.infinity,
      height: height ?? Theme.of(bc).dividerTheme.thickness ?? 1,
      color: color ?? Theme.of(bc).dividerColor,
      margin: margin ?? EdgeInsets.symmetric(vertical: Theme.of(bc).dividerTheme.thickness ?? 12),
    ),
  );
}
