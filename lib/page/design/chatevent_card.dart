import 'dart:math';

import 'package:aautop_designer/tool/widget/free_chip.dart';
import 'package:flutter/material.dart';
import 'package:aautop_designer/data/chatevent_ui_packer.dart';
import 'package:aautop_designer/style/style.dart';
import "package:aautop_designer/model/chatlogic_model.dart";
import "package:aautop_designer/tool/extend_list.dart";

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

  Widget _createCardListTile({Widget? leading, Widget? title, Widget? titleEnd, Widget? trailing}) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          leading ?? const SizedBox(),
          SizedBox(
            width: nullBoxWidth,
          ),
          title ?? const SizedBox(),
          titleEnd ?? const SizedBox(),
          trailing ?? const SizedBox(),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 4),
    );
  }

  Widget _buildEventId() {
    return _createCardListTile(
      leading: const Text("ID"),
      title: Expanded(
        child: Container(
          child: Text(
            chatEventUIPacker.chatEvent.eventId.toString(),
            style: h7TextStyleLow,
          ),
          padding: EdgeInsets.symmetric(horizontal: nullBoxWidth),
        ),
      ),
      trailing: FreeChip(
        label: Text(
          chatEventUIPacker.chatEvent.eventsType.toString(),
        ),
      ),
    );
  }

  Widget _buildTimeCons(List<ChatLogicChatEventsTimeCon> chatLogic_chatEvents_timeCons) {
    final timeConGroupWidgets = chatLogic_chatEvents_timeCons
        .map(
          (e) => Text("${e.min}-${e.max} "),
        )
        .toList()
        .subgroup(2)
        .map((e) => Row(children: e,mainAxisAlignment: MainAxisAlignment.start,))
        .toList();

    return _createCardListTile(
      leading: const Text("时间段"),
      title: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...timeConGroupWidgets.sublist(
              0,
              min(timeConGroupWidgets.length, 3),
            ),
            if (timeConGroupWidgets.length > 3)
              const Text(
                "最多显示6个",
                style: h8TextStyleLow,
              )
          ],
        ),
      ),
      titleEnd: const SizedBox(),
      trailing: const SizedBox(),
    );
  }

  Widget _buildResListen() {
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
                  return _createCardListTile(
                    leading: const Text("监听消息"),
                    title: Expanded(
                      child: Text(
                        findMsg.content.toString(),
                        style: h7TextStyleLow,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    trailing: FreeChip(
                      label: Text(findMsg.type!),
                    ),
                  );
                }
              }
              return _createCardListTile(
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
      return _createCardListTile(
        title: const Text("Is a Timer"),
      );
    } else {
      assert(false);
      return _createCardListTile(
        title: const Text("No Def EventType"),
      );
    }
  }

  Widget _buildSendMsgs() {
    return Container(
      child: _createCardListTile(
        leading: const Text("发送消息"),
        title: Expanded(
          child: SizedBox(
            child: Builder(
              builder: (bc) {
                final showList = chatEventUIPacker.chatEvent.sendMsgs!
                    .map((e) => chatLogic.fromIdGetMsg(e))
                    .where((element) => element != null)
                    .map(
                      (e) => Text(
                        e!.content.toString(),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                    .toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...showList.sublist(0, min(showList.length, 3)),
                    if (showList.length > 3)
                      const Text(
                        "最多显示3条",
                        style: h8TextStyleLow,
                      )
                  ],
                );
              },
            ),
          ),
        ),
        trailing: Container(),
        titleEnd: Container(),
      ),
      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
    );
  }

  Container _buildCardContent() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        controller: ScrollController(),
        child: Builder(
          builder: (bc) {
            if (chatEventUIPacker.chatEvent.testIsAnyRes) {
              // res
              return Column(
                children: [
                  _buildEventId(),
                  _buildSendMsgs(),
                  _buildResListen(),
                  _buildTimeCons(
                    chatEventUIPacker.chatEvent.isRes!.timeCons ?? [],
                  ),
                ],
              );
            } else if (chatEventUIPacker.chatEvent.testIsTimer) {
              // timer
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildEventId(),
                  _buildSendMsgs(),
                  _createCardListTile(
                    leading: const Text("最小间隔时间"),
                    title: Text(chatEventUIPacker.chatEvent.isTimer!.coolDownTime.toString()),
                  ),
                  _createCardListTile(
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
                  child: _buildCardContent(),
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
