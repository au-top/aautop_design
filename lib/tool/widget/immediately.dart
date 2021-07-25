import 'dart:async';

import 'package:flutter/cupertino.dart';

class Immediately extends StatefulWidget {
  final WidgetBuilder builder;
  final int tick;

  Immediately({required this.builder, required this.tick});

  @override
  State<StatefulWidget> createState() {
    return ImmediatelyState();
  }
}

class ImmediatelyState extends State<Immediately> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: widget.tick), (timer) {
      if(mounted){
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
