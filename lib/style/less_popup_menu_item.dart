import 'package:aautop_designer/style/style.dart';
import 'package:flutter/material.dart';

PopupMenuItem<T> buildLessPopupMenuItem<T>({
  required Widget child,
  required T value,
  VoidCallback? onTap,
  TextStyle? textStyle,
}) {
  return PopupMenuItem<T>(
    child: child,
    value: value,
    onTap: onTap,
    textStyle: textStyle ?? h6TextStyle,
    padding: const EdgeInsets.only(left: 10),
    height: 32,
  );
}

Widget buildLessPopupMenuButton<T>({
  required List<PopupMenuItem<T>> items,
  Widget? icon,
  VoidCallback? onCanceled,
  void Function(T)? onSelected,
  Widget? child,
  String? tooltip,
  double? iconSize,
  EdgeInsets? padding,
  Offset? offset,
}) {
  return PopupMenuButton<T>(
    child: child ?? const SizedBox(),
    itemBuilder: (bc) {
      return items;
    },
    offset: offset ?? const Offset(-10, 12),
    icon: icon,
    tooltip: tooltip,
    iconSize: iconSize,
    padding: padding ?? const EdgeInsets.symmetric(horizontal: 2),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    onSelected: onSelected,
    onCanceled: onCanceled,
    elevation: 2,
  );
}
