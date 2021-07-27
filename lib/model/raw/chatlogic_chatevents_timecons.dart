import 'dart:convert';

class ChatLogicChatEventsTimeCons {
  ChatLogicChatEventsTimeCons({
    required this.max,
    required this.min,
  });

  late String? max;
  late String? min;

  ChatLogicChatEventsTimeCons.fromJson(Map<String, dynamic> jsondata) {
    this.max = jsondata["max"];
    this.min = jsondata["min"];
    ;
  }

  Map<dynamic, dynamic> toJson() {
    final jsonMapElem = new Map();
    jsonMapElem["max"] = this.max;
    jsonMapElem["min"] = this.min;
    return jsonMapElem;
    ;
  }
}
