import 'package:flutter/material.dart';

TimeOfDay easyTimeStrToTimeOfDay(String easyTimeStr){
  final easySplit=easyTimeStr.split(":");
  final easySplitInt=easySplit.map((e) => int.parse(e));
  final resTimeOfDay=TimeOfDay(hour: easySplitInt.first,minute: easySplitInt.last);
  return resTimeOfDay;
}

String timeOfDayToEasyTimeStr(TimeOfDay timeOfDay){
  return "${"${timeOfDay.hour}".padLeft(2,"0")}:${ "${timeOfDay.minute}".padLeft(2,"0") }";
}