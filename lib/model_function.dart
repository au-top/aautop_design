import 'package:aautop_designer/data/functions.dart';
import "package:aautop_designer/model/chatlogic.dart";
import "package:aautop_designer/model/chatlogic_chatevent.dart";
import 'package:aautop_designer/model/chatlogic_chatevents_isres.dart';
import 'package:aautop_designer/model/chatlogic_chatevents_istimer.dart';
import "package:aautop_designer/model/chatlogic_msg.dart";
import 'package:aautop_designer/model/events_type.dart';




extension ChatLogicChatEventTypeTest on ChatLogicChatEvent {
  bool get testIsAnyRes=>eventsType==EventsType.subres.toEnumString()||eventsType==EventsType.res.toEnumString();
  bool get testIsRes=>eventsType==EventsType.res.toEnumString();
  bool get testIsSubRes=>eventsType==EventsType.subres.toEnumString();
  bool get testIsTimer=>eventsType==EventsType.timer.toEnumString();
}


extension ChatLogicFunction on ChatLogic {

  Set<String> findMsgInEvent({required String findMsgId}) {
    final resEventId = <String>{};
    for (var element in chatEvents!) {
      if (element.isRes != null && element.isRes!.listenOn == findMsgId) {
        resEventId.add(element.eventId!);
      }
      if (element.sendMsgs != null && element.sendMsgs!.contains(findMsgId)) {
        resEventId.add(element.eventId!);
      }
    }
    return resEventId;
  }

  void delMsg({required String delMsgId}) {
    final index = msgs!.indexWhere((element) => element.msgId == delMsgId);
    msgs!.removeAt(index);
    for (var element in chatEvents!) {
      if (element.isRes != null && element.isRes!.listenOn == delMsgId) {
        element.isRes!.listenOn = null;
      }
      element.sendMsgs!.remove(delMsgId);
    }
  }
  void delChatEvent({required String delChatEventId}){
    chatEvents!.removeWhere((element) => element.eventId==delChatEventId);
  }

  ChatLogicChatEvent? fromIdGetChatEvent(String id) {
    final findIndex =
        chatEvents!.indexWhere((element) => element.eventId == id);
    if (findIndex != -1) {
      return chatEvents![findIndex];
    } else {
      return null;
    }
  }

  ChatLogicMsg? fromIdGetMsg(String id) {
    final findIndex = msgs!.indexWhere((element) => element.msgId == id);
    if (findIndex != -1) {
      return msgs![findIndex];
    } else {
      return null;
    }
  }

  static ChatLogicChatEvent createChatEvent({EventsType? eventsType}) {
    return ChatLogicChatEvent(
      sendMsgs: [],
      isRes: ChatLogicChatEventsIsRes(
        timeCons: [],
        priorityEventLists: [],
        listenOn: null,
        delay: null,
      ),
      isTimer: ChatLogicChatEventsIsTimer(
        timeCons: [],
        coolDownTime: null,
        frequency: null,
      ),
      eventsType: (eventsType ?? EventsType.res).toEnumString(),
      eventId: chatLogicMsgIDBuild(),
    );
  }
}
