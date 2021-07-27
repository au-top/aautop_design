import 'dart:convert';

import 'package:aautop_designer/model/chatlogic_chatevents_timecon.dart';

class ChatLogicChatEventsIsRes {
  ChatLogicChatEventsIsRes({
    required this.timeCons,
    required this.delay,
    required this.listenOn,
    required this.priorityEventLists,
  });

  late List<ChatLogicChatEventsTimeCon>? timeCons;
  late num? delay;
  late String? listenOn;
  late List<String>? priorityEventLists;

  ChatLogicChatEventsIsRes.fromJson(Map<String, dynamic> jsondata) {
    this.timeCons = List<ChatLogicChatEventsTimeCon>.from(
        jsondata["timeCons"]
            .map((e) => ChatLogicChatEventsTimeCon.fromJson(e)));
    ;
    this.delay = jsondata["delay"];
    this.listenOn = jsondata["listenOn"];
    this.priorityEventLists = jsondata["priorityEventLists"];
    ;
  }

  Map<dynamic,dynamic> toJson() {
    final jsonMapElem = new Map();
    jsonMapElem["timeCons"] = this.timeCons;
    jsonMapElem["delay"] = this.delay;
    jsonMapElem["listenOn"] = this.listenOn;
    jsonMapElem["priorityEventLists"] = this.priorityEventLists;
    return jsonMapElem;
  }
}
