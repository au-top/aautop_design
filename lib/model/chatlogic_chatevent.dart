import 'dart:convert';
import "chatlogic_chatevents_istimer.dart";
import "chatlogic_chatevents_isres.dart";

class ChatLogicChatEvent {
  ChatLogicChatEvent({
    required this.eventId,
    required this.eventsType,
    required this.isTimer,
    required this.isRes,
    required this.sendMsgs,
  });


  late String? eventId;
  late String? eventsType;
  late ChatLogicChatEventsIsTimer? isTimer;
  late ChatLogicChatEventsIsRes? isRes;
  late List<String>? sendMsgs;

  ChatLogicChatEvent.fromJson(Map<String, dynamic> jsondata) {
    this.eventId = jsondata["eventId"];
    this.eventsType = jsondata["eventsType"];
    this.isTimer = ChatLogicChatEventsIsTimer.fromJson(jsondata["isTimer"]);
    this.isRes = ChatLogicChatEventsIsRes.fromJson(jsondata["isRes"]);
    this.sendMsgs = jsondata["sendMsgs"];
    ;
  }

  String toJson() {
    final jsonMapElem = new Map();
    jsonMapElem["eventId"] = this.eventId;
    jsonMapElem["eventsType"] = this.eventsType;
    jsonMapElem["isTimer"] = this.isTimer;
    jsonMapElem["isRes"] = this.isRes;
    jsonMapElem["sendMsgs"] = this.sendMsgs;
    return jsonEncode(jsonMapElem);
    ;
  }
}
