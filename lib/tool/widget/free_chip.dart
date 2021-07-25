import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class FreeChip extends StatelessWidget {
  final Widget label;
  final Widget? icon;
  final Color? background;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? borderRadius;
  final BoxBorder? borderSide;
  final Color? shadowColor;
  final double? elevation;
  final Offset? shadowOffset;
  final TextStyle? textStyle;
  const FreeChip({
    Key? key,
    required this.label,
    this.background,
    this.margin,
    this.padding,
    this.icon,
    this.borderRadius,
    this.borderSide,
    this.shadowColor,
    this.elevation,
    this.shadowOffset,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chipTheme = Theme.of(context).chipTheme;
    return DefaultTextStyle(
      style: chipTheme.labelStyle,
      child: Container(
        child: label,
        padding: padding ?? chipTheme.padding,
        margin: margin,
        decoration: BoxDecoration(
          border: borderSide ?? Border.fromBorderSide(chipTheme.side ?? BorderSide.none),
          color: background ?? chipTheme.backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius ?? 10),
          boxShadow: [
            BoxShadow(
              color: shadowColor ?? chipTheme.shadowColor ?? Colors.black12,
              blurRadius: elevation ?? chipTheme.elevation ?? 0,
              offset: shadowOffset ?? Offset.zero,
            )
          ],
        ),
      ),
    );
  }
}
