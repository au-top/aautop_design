import 'package:flutter/material.dart';

Material windowsIcon() {
  return Material(
    color: Colors.transparent,
    elevation: 5,
    shadowColor: Colors.black26,
    borderRadius: BorderRadius.circular(50),
    clipBehavior: Clip.antiAlias,
    child: Image.asset(
      "assets/image/app_icon.png",
    ),
  );
}