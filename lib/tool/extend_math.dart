import 'dart:math';

T minMax<T extends num >(T value,{required T maxValue,required T minValue}){
  return min<T>(max<T>(value,minValue), maxValue);
}