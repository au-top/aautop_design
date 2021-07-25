import 'package:flutter/services.dart';

class TextFieldFilterNumber extends TextInputFormatter{
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if(RegExp("[0-9]*").firstMatch(newValue.text)?.group(0)?.length==newValue.text.length){
      return newValue;
    }else{
      return oldValue;
    }
  }
}