import 'dart:convert';
import "chatlogic_chatevent.dart";
import "chatlogic_msg.dart";

class ChatLogic {

  ChatLogic({
    required this.chatEvents,
    required this.msgs,
  });

  late List<ChatLogicChatEvent>? chatEvents;
  late List<ChatLogicMsg>? msgs;

  ChatLogic.fromJson(Map<String, dynamic> jsondata) {
    this.chatEvents = List<ChatLogicChatEvent>.from(
        jsondata["chatEvents"].map((e) => ChatLogicChatEvent.fromJson(e)));
    this.msgs = List<ChatLogicMsg>.from(
        jsondata["msgs"].map((e) => ChatLogicMsg.fromJson(e)));
  }

  String toJson() {
    final jsonMapElem = new Map();
    jsonMapElem["chatEvents"] = this.chatEvents;
    jsonMapElem["msgs"] = this.msgs;
    return jsonEncode(jsonMapElem);
  }

}
