import 'dart:convert';

class ChatLogicMsg {
  ChatLogicMsg({
    required this.msgId,
    required this.type,
    required this.content,
  });

  late String? msgId;
  late String? type;
  late String? content;

  ChatLogicMsg.fromJson(Map<String, dynamic> jsondata) {
    this.msgId = jsondata["msgId"];
    this.type = jsondata["type"];
    this.content = jsondata["content"];

  }

  Map<dynamic,dynamic> toJson() {
    final jsonMapElem = new Map();
    jsonMapElem["msgId"] = this.msgId;
    jsonMapElem["type"] = this.type;
    jsonMapElem["content"] = this.content;
    return jsonMapElem;
  }
}
