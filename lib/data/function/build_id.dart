import 'dart:math';
int IdIndex=0;
String chatLogicMsgIDBuild(){
  String timeToken = DateTime.now().millisecondsSinceEpoch.toRadixString(32);
  IdIndex+=1;
  String randomId = IdIndex.toRadixString(36)+int.parse(Random().nextDouble().toString().substring(2)).toRadixString(36).substring(0,4);
  String idStr="${timeToken}${randomId}Msg";
  return idStr;
 }