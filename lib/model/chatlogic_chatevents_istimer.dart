import 'dart:convert';
import "chatlogic_chatevents_timecon.dart";

class ChatLogicChatEventsIsTimer {
  ChatLogicChatEventsIsTimer({
    required this.timeCons,
    required this.frequency,
    required this.coolDownTime,
  });

  late List<ChatLogicChatEventsTimeCon>? timeCons;
  late num? frequency;
  late num? coolDownTime;

  ChatLogicChatEventsIsTimer.fromJson(Map<String, dynamic> jsondata) {
    this.timeCons = List<ChatLogicChatEventsTimeCon>.from(
        jsondata["timeCons"]
            .map((e) => ChatLogicChatEventsTimeCon.fromJson(e)));
    ;
    this.frequency = jsondata["frequency"];
    this.coolDownTime = jsondata["coolDownTime"];
    ;
  }

  Map<dynamic,dynamic> toJson() {
    final jsonMapElem = new Map();
    jsonMapElem["timeCons"] = this.timeCons;
    jsonMapElem["frequency"] = this.frequency;
    jsonMapElem["coolDownTime"] = this.coolDownTime;
    return jsonMapElem;
    ;
  }
}
