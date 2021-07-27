import 'dart:convert';
import "chatlogic_chatevents_timecons.dart";

class ChatLogicChatEventsIsRes {
  ChatLogicChatEventsIsRes({
    required this.timeCons,
    required this.delay,
    required this.listenOn,
    required this.priorityEventLists,
  });

  late List<ChatLogicChatEventsTimeCons>? timeCons;
  late num? delay;
  late String? listenOn;
  late List<String>? priorityEventLists;

  ChatLogicChatEventsIsRes.fromJson(Map<String, dynamic> jsondata) {
    this.timeCons = List<ChatLogicChatEventsTimeCons>.from(jsondata["timeCons"].map((e) => ChatLogicChatEventsTimeCons.fromJson(e)));
    ;
    this.delay = jsondata["delay"];
    this.listenOn = jsondata["listenOn"];
    this.priorityEventLists = List.castFrom<dynamic, String>(jsondata["priorityEventLists"]);
    ;
    ;
  }

  Map<dynamic, dynamic> toJson() {
    final jsonMapElem = new Map();
    jsonMapElem["timeCons"] = this.timeCons;
    jsonMapElem["delay"] = this.delay;
    jsonMapElem["listenOn"] = this.listenOn;
    jsonMapElem["priorityEventLists"] = this.priorityEventLists;
    return jsonMapElem;
    ;
  }
}
