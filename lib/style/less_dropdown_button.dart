import 'package:flutter/material.dart';

DropdownButton buildLessDropdownButton<T>({
  bool? isDense,
  Widget? underline,
  List<DropdownMenuItem<T>>? items,
  T? value,
  ValueChanged<T?>? onChanged,
  bool? isExpanded,
}) {
  return DropdownButton<T>(
    isDense: isDense ?? false,
    items: items,
    value: value,
    onChanged: onChanged,
    isExpanded: isExpanded ?? false,
    borderRadius: BorderRadius.circular(8),
    underline: underline,
    elevation: 1,
    dropdownColor: Colors.white,
  );
}
