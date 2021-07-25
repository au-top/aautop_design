import 'package:flutter/material.dart';


class DataPack<T>extends ChangeNotifier {
  late T data;
  DataPack({required this.data});
}

/// Dependent data 函数封装
DataPack<T> createDependentDataPack<T>(T data){
  return DataPack<T>(data: data);
}



class Dependent<T extends ChangeNotifier> extends StatefulWidget {
  final Widget Function(BuildContext,T) builder;
  final T data;

  const Dependent({Key? key, required this.builder, required this.data})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DependentState<T>();
  }
}

class DependentState<T extends ChangeNotifier> extends State<Dependent<T>> {
  void update() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    widget.data.addListener(update);
  }

  @override
  void didUpdateWidget(covariant Dependent<T> oldWidget) {
    if (oldWidget != widget) {
      oldWidget.data.removeListener(update);
      widget.data.addListener(update);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.data.removeListener(update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (bc) {
      return widget.builder(bc,widget.data);
    });
  }

}
