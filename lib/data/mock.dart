import 'dart:math';
import "package:aautop_designer/model/events_type.dart";
import "package:aautop_designer/model/msg_type.dart";
import "package:aautop_designer/model/chatlogic_model.dart";

ChatLogic mockData() {
  final ChatLogic chatLogic = ChatLogic(chatEvents: [], msgs: []);

  final chatLogicMsgsOne = ChatLogicMsg(
    type: MsgType.onText.toEnumString(),
    msgId: Random().nextDouble().toString().substring(2),
    content: 'HelloWorld On Text',
  );
  final chatLogicMsgsTwo = ChatLogicMsg(
    type: MsgType.text.toEnumString(),
    msgId: Random().nextDouble().toString().substring(2),
    content: 'HelloWorld Text',
  );

  final chatEventOne = ChatLogicChatEvent(
    eventId: Random().nextDouble().toString().substring(2),
    sendMsgs: [chatLogicMsgsTwo.msgId!],
    eventsType: EventsType.timer.toEnumString(),
    isRes: null,
    isTimer: ChatLogicChatEventsIsTimer(
      frequency: 2,
      coolDownTime: 1000 * 60 * 60 * 1,
      timeCons: [
        ChatLogicChatEventsTimeCon(min: '01:00', max: '09:00')
      ],
    ),
  );
  final chatEventThree = ChatLogicChatEvent(
    eventId: Random().nextDouble().toString().substring(2),
    sendMsgs: [chatLogicMsgsTwo.msgId!],
    eventsType: EventsType.res.toEnumString(),
    isRes: ChatLogicChatEventsIsRes(
      listenOn: chatLogicMsgsOne.msgId!,
      priorityEventLists: [],
      delay: 1000,
      timeCons: [
        ChatLogicChatEventsTimeCon(min: '01:00', max: '09:00')
      ],
    ),
    isTimer: null,
  );

  final chatEventTwo = ChatLogicChatEvent(
    eventId: Random().nextDouble().toString().substring(2),
    sendMsgs: [chatLogicMsgsTwo.msgId!],
    eventsType: EventsType.res.toEnumString(),
    isRes: ChatLogicChatEventsIsRes(
      listenOn: chatLogicMsgsOne.msgId!,
      priorityEventLists: [chatEventThree.eventId!],
      delay: 1000,
      timeCons: [
        ChatLogicChatEventsTimeCon(min: '01:00', max: '09:00')
      ],
    ),
    isTimer: null,
  );

  chatLogic.chatEvents!.add(chatEventOne);
  chatLogic.chatEvents!.add(chatEventTwo);
  chatLogic.chatEvents!.add(chatEventThree);
  chatLogic.msgs!.add(chatLogicMsgsOne);
  chatLogic.msgs!.add(chatLogicMsgsTwo);
  return chatLogic;
}