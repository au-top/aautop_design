import 'package:aautop_designer/tool/widget/free_chip.dart';
import 'package:flutter/material.dart';
import 'package:aautop_designer/page/design/chatevent_ui_packer.dart';
import 'package:aautop_designer/style/style.dart';
import "package:aautop_designer/model/chatlogic_model.dart";
import "package:aautop_designer/model/events_type.dart";

enum ChatEventCardMode {
  less,
  ordinary,
  high,
  active,
}

class ChatEventCard extends StatelessWidget {
  final ChatEventUIPacker chatEventUIPacker;
  final ChatLogic chatLogic;
  final void Function()? onTap;
  final nullBoxWidth = 10.0;
  final ChatEventCardMode mode;

  const ChatEventCard({
    Key? key,
    required this.chatEventUIPacker,
    required this.chatLogic,
    required this.mode,
    this.onTap,
  }) : super(key: key);

  Widget eventId() {
    return cardListTile(
      leading: const Text("ID"),
      title: Container(
        child: Text(
          chatEventUIPacker.chatEvent.eventId.toString(),
          style: h7TextStyleLow,
        ),
        padding: EdgeInsets.symmetric(horizontal: nullBoxWidth),
      ),
      trailing: FreeChip(
        label: Text(
          chatEventUIPacker.chatEvent.eventsType.toString(),
        ),
      ),
    );
  }

  Widget timeCons(List<ChatLogicChatEventsTimeCon> chatLogic_chatEvents_timeCons) {
    return cardListTile(
        leading: const Text("时间段"),
        title: Expanded(
          child: SizedBox(
            child: Wrap(
              children: [
                ...chatLogic_chatEvents_timeCons.map(
                  (e) => Padding(
                    child: Text(
                      "${e.min}-${e.max}",
                      style: h6TextStyleLow,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                  ),
                )
              ],
            ),
            height: 50,
          ),
        ),
        titleEnd: const SizedBox(),
        trailing: const SizedBox());
  }

  Widget resListen() {
    if (chatEventUIPacker.chatEvent.testIsAnyRes) {
      //res
      final resContent = chatEventUIPacker.chatEvent.isRes!;
      return Column(
        children: [
          Builder(
            builder: (BuildContext context) {
              if (resContent.listenOn != null) {
                final findMsg = chatLogic.fromIdGetMsg(resContent.listenOn!);
                if (findMsg != null) {
                  return cardListTile(
                    leading: const Text("监听消息"),
                    title: Text(
                      findMsg.content.toString(),
                      style: h7TextStyleLow,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: FreeChip(
                      label: Text(findMsg.type!),
                    ),
                  );
                }
              }
              return cardListTile(
                leading: const Text("监听消息"),
                title: const Text(
                  "这是空的",
                  style: h7TextStyleLow,
                ),
              );
              // resContent.listenOn
            },
          ),
        ],
      );
    } else if (chatEventUIPacker.chatEvent.testIsTimer) {
      assert(false);
      return cardListTile(
        title: const Text("Is a Timer"),
      );
    } else {
      assert(false);
      return cardListTile(
        title: const Text("No Def EventType"),
      );
    }
  }

  Widget sendMsgs() {
    return Container(
      child: cardListTile(
        leading: const Text("发送消息"),
        title: Expanded(
          child: SizedBox(
            height: 30,
            child: SingleChildScrollView(
              controller: ScrollController(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...chatEventUIPacker.chatEvent.sendMsgs!.map((e) => chatLogic.fromIdGetMsg(e)).where((element) => element != null).map((e) => Text(e!.content.toString())),
                ],
              ),
            ),
          ),
        ),
        trailing: Container(),
        titleEnd: Container(),
      ),
      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
    );
  }

  Widget cardListTile({Widget? leading, Widget? title, Widget? titleEnd, Widget? trailing}) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          leading ?? const Spacer(),
          SizedBox(
            width: nullBoxWidth,
          ),
          title ?? const Spacer(),
          titleEnd ?? const Spacer(),
          trailing ?? const Spacer(),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 4),
    );
  }

  Container cardContent() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        controller: ScrollController(),
        child: Builder(
          builder: (bc) {
            final eventType = chatEventUIPacker.chatEvent.eventsType;
            if (eventType == EventsType.res.toEnumString() || eventType == EventsType.subres.toEnumString()) {
              // res
              return Column(
                children: [
                  eventId(),
                  sendMsgs(),
                  resListen(),
                  timeCons(
                    chatEventUIPacker.chatEvent.isRes!.timeCons ?? [],
                  ),
                ],
              );
            } else if (eventType == EventsType.timer.toEnumString()) {
              // timer
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  eventId(),
                  sendMsgs(),
                  cardListTile(
                    leading: const Text("最小间隔时间"),
                    title: Text(chatEventUIPacker.chatEvent.isTimer!.coolDownTime.toString()),
                  ),
                  cardListTile(
                    leading: const Text("每天最大次数"),
                    title: Text(chatEventUIPacker.chatEvent.isTimer!.frequency.toString()),
                  ),
                ],
              );
            } else {
              // no def find
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [Text("No Def Find")],
              );
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final contentCard = SizedBox(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            child: Container(
              clipBehavior: Clip.antiAlias,
              child: Material(
                child: InkWell(
                  onTap: onTap ?? () => null,
                  child: cardContent(),
                ),
                color: Colors.transparent,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                border: Border.all(color: mainTextColorLess, width: 1),
              ),
            ),
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
          ),
          Positioned(
            top: ChatEventUIPacker.sizeCon.height / 2 - chatEventUIPacker.linkCircleSize,
            left: -chatEventUIPacker.linkCircleSize / 2,
            child: Container(
              padding: EdgeInsets.all(chatEventUIPacker.linkCircleSize),
              decoration: BoxDecoration(
                color: chatEventUIPacker.outIconColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: ChatEventUIPacker.sizeCon.height / 2 - chatEventUIPacker.linkCircleSize,
            left: ChatEventUIPacker.sizeCon.width - chatEventUIPacker.linkCircleSize,
            child: Container(
              padding: EdgeInsets.all(chatEventUIPacker.linkCircleSize),
              decoration: BoxDecoration(
                color: chatEventUIPacker.inIconColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          //in
          Positioned(
            child: Icon(
              Icons.chevron_right,
              size: chatEventUIPacker.linkDirIconSize,
              color: mainIconColor,
            ),
            top: ChatEventUIPacker.sizeCon.height / 2 - chatEventUIPacker.linkDirIconSize / 2,
            left: ChatEventUIPacker.sizeCon.width - chatEventUIPacker.linkDirIconSize / 2,
          ),
          // out
          Positioned(
            child: Icon(
              Icons.chevron_right,
              size: chatEventUIPacker.linkDirIconSize,
              color: mainIconColor,
            ),
            top: ChatEventUIPacker.sizeCon.height / 2 - chatEventUIPacker.linkDirIconSize / 2,
            left: -chatEventUIPacker.linkDirIconSize / 3,
          ),
        ],
      ),
      width: ChatEventUIPacker.sizeCon.width,
      height: ChatEventUIPacker.sizeCon.height,
    );

    //add mode
    double opacity = 1.0;
    BoxDecoration boxDecoration = const BoxDecoration();
    switch (mode) {
      case ChatEventCardMode.less:
        {
          boxDecoration = const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(180, 180, 180, 0),
                blurRadius: 8,
                spreadRadius: 0,
                offset: Offset(4, 3),
              )
            ],
          );
          opacity = 0.45;
        }
        break;
      case ChatEventCardMode.ordinary:
        {
          boxDecoration = const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(180, 180, 180, 0),
                blurRadius: 8,
                spreadRadius: 0,
                offset: Offset(4, 3),
              )
            ],
          );
          opacity = 1.0;
        }
        break;
      case ChatEventCardMode.active:
        {
          boxDecoration = const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(150, 150, 150, 0.25),
                blurRadius: 4,
                spreadRadius: 0,
                offset: Offset(4, 4),
              )
            ],
          );
          opacity = 1.0;
        }
        break;
      case ChatEventCardMode.high:
        {
          boxDecoration = const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(150, 150, 150, 0.45),
                blurRadius: 8,
                spreadRadius: 0,
                offset: Offset(4, 3),
              )
            ],
          );
          opacity = 1.0;
        }
        break;
    }

    return Positioned(
      key: ValueKey(chatEventUIPacker.chatEvent.eventId),
      child: AnimatedContainer(
        decoration: boxDecoration,
        duration: const Duration(milliseconds: 200),
        child: AnimatedOpacity(
          opacity: opacity,
          duration: const Duration(milliseconds: 200),
          child: contentCard,
        ),
      ),
      top: chatEventUIPacker.top,
      left: chatEventUIPacker.left,
    );
  }
}
