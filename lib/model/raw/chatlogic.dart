import 'dart:convert';
import "chatlogic_chatevents.dart";
import "chatlogic_msgs.dart";

class ChatLogic {
  ChatLogic({
    required this.chatEvents,
    required this.msgs,
  });

  late List<ChatLogicChatEvents>? chatEvents;
  late List<ChatLogicMsgs>? msgs;

  ChatLogic.fromJson(Map<String, dynamic> jsondata) {
    this.chatEvents = List<ChatLogicChatEvents>.from(jsondata["chatEvents"].map((e) => ChatLogicChatEvents.fromJson(e)));
    this.msgs = List<ChatLogicMsgs>.from(jsondata["msgs"].map((e) => ChatLogicMsgs.fromJson(e)));
  }

  Map<dynamic, dynamic> toJson() {
    final jsonMapElem = new Map();
    jsonMapElem["chatEvents"] = this.chatEvents;
    jsonMapElem["msgs"] = this.msgs;
    return jsonMapElem;
    ;
  }
}
