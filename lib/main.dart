import 'dart:convert';

import 'package:aautop_designer/page/design/design.dart';
import 'package:aautop_designer/style/style.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Frame());
}

class Frame extends StatelessWidget {
  const Frame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: buildRootThemeData(context),
      debugShowCheckedModeBanner: false,
      home: const AppFrame(),
    );
  }
}

class AppFrame extends StatefulWidget {
  const AppFrame({Key? key}):super(key: key);
  @override
  State<StatefulWidget> createState() {
    return AppFrameState();
  }
}

class AppFrameState extends State<AppFrame> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Design(),
    );
  }
}
