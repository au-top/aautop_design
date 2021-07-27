import 'dart:math';

import 'package:aautop_designer/page/design/design.dart';
import 'package:aautop_designer/page/msg_select.dart';
import 'package:aautop_designer/page/msg_manage.dart';
import 'package:aautop_designer/style/less_dropdown_button.dart';
import 'package:aautop_designer/style/style.dart';
import 'package:aautop_designer/tool/textfield_filter.dart';
import 'package:aautop_designer/tool/time_tool.dart';
import 'package:aautop_designer/tool/widget/free_chip.dart';
import 'package:flutter/material.dart';
import "package:aautop_designer/model/chatlogic_model.dart";

import "package:aautop_designer/model/events_type.dart";

import 'package:flutter/painting.dart';

extension DesignChatEventEditor on DesignState{


  Widget onTimerConfigWidget(DesignData data, BuildContext context) {
    final chatEvent = data.activeUIPacker!.chatEvent;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "定时器配置",
          style: h3TextStylePlus,
        ),
        const Divider(),
        inputTextWidget(
          label: "最小间隔时间",
          trailing: "ms",
          text: chatEvent.isTimer!.coolDownTime.toString(),
          onChanged: (v) {
            chatEvent.isTimer!.coolDownTime = int.parse(
              v.isNotEmpty ? v : "0",
            );
          },
        ),
        inputTextWidget(
          label: "每天最大次数",
          trailing: "次",
          text: chatEvent.isTimer!.frequency.toString(),
          onChanged: (v) {
            chatEvent.isTimer!.frequency = int.parse(
              v.isNotEmpty ? v : "0",
            );
          },
        ),
        // time cons
        timeConsWidget(
          context,
          chatEvent.isTimer!.timeCons!,
          data,
        ),
      ],
      mainAxisSize: MainAxisSize.min,
    );
  }

  Widget onResConfigWidget(DesignData data, BuildContext context) {
    final chatEvent = data.activeUIPacker!.chatEvent;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "响应式配置",
          style: h3TextStylePlus,
        ),
        const Divider(),
        inputTextWidget(
            label: "延迟时间",
            trailing: "ms",
            text: chatEvent.isRes!.delay.toString(),
            onChanged: (v) {
              chatEvent.isRes!.delay = int.parse(
                v.isNotEmpty ? v : "0",
              );
            }),
        // listen on
        listenOnWidget(data, chatEvent, context),
        // time cons
        timeConsWidget(context, chatEvent.isRes!.timeCons!, data),
      ],
      mainAxisSize: MainAxisSize.min,
    );
  }

  Widget sendMsgsWidget(BuildContext context, ChatLogicChatEvent chatEvent, DesignData data) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: const Text(
            "发送消息",
            style: h5TextStyle,
          ),
          trailing: Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.add_rounded,
                  color: mainIconColor,
                ),
                onPressed: () {
                  showDialog<List<String>>(
                    context: context,
                    builder: (bc) {
                      return Dialog(
                        child: MsgSelect(
                          dataLogicData: data.chatLogic,
                          selectMsg: chatEvent.sendMsgs ?? [],
                        ),
                      );
                    },
                  ).then((value) {
                    if (value != null) {
                      chatEvent.sendMsgs = value;
                      data.notifyListeners();
                    }
                  });
                },
              ),
              openMsgsManageWidget(context, data)
            ],
            mainAxisSize: MainAxisSize.min,
          ),
        ),
        Container(
          child: attrLists(
            context,
            builderListElem: (bc) {
              return [
                ...chatEvent.sendMsgs!.map<ChatLogicMsg?>((e) => data.chatLogic.fromIdGetMsg(e)).where((element) => element != null).map(
                      (e) => Container(
                    child: msgCard(e!),
                    padding: const EdgeInsets.only(top: 1, bottom: 3, left: 6, right: 0),
                    decoration: BoxDecoration(
                      border: Border.all(color: mainTextColorLess),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                )
              ];
            },
            height: 100,
          ),
          padding: const EdgeInsets.all(3),
        ),
      ],
    );
  }

  Widget timeConsWidget(
      BuildContext context,
      List<ChatLogicChatEventsTimeCon> timeCons,
      DesignData data,
      ) {
    return attrLists(
      context,
      title: const Text(
        "时间段配置",
        style: h5TextStyle,
      ),
      builderListElem: (bc) => timeCons
          .map(
            (e) => Container(
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    InkWell(
                      child: Text(
                        e.min.toString(),
                        style: h5TextStyle,
                      ),
                      onTap: () {
                        showTimePicker(context: context, initialTime: easyTimeStrToTimeOfDay(e.min!)).then((value) {
                          if (value != null) {
                            e.min = timeOfDayToEasyTimeStr(value);
                            data.notifyListeners();
                          }
                        });
                      },
                    ),
                    const Text(
                      "-",
                      style: h5TextStyle,
                    ),
                    InkWell(
                      child: Text(
                        e.max.toString(),
                        style: h5TextStyle,
                      ),
                      onTap: () {
                        showTimePicker(context: context, initialTime: easyTimeStrToTimeOfDay(e.min!)).then((value) {
                          if (value != null) {
                            e.max = timeOfDayToEasyTimeStr(value);
                            data.notifyListeners();
                          }
                        });
                      },
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.close_rounded,
                  color: mainIconColor,
                ),
                onPressed: () {
                  timeCons.remove(e);
                  data.notifyListeners();
                },
              )
            ],
          ),
          margin: const EdgeInsets.only(
            bottom: 8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              50,
            ),
          ),
        ),
      )
          .toList(),
      titleTrailing: IconButton(
        icon: const Icon(
          Icons.add_rounded,
          color: mainIconColor,
        ),
        onPressed: () {
          timeCons.add(
            ChatLogicChatEventsTimeCon(
              min: '00:00',
              max: '23:59',
            ),
          );
          data.notifyListeners();
        },
      ),
    );
  }

  ListTile inputTextWidget({
    required String label,
    required String trailing,
    required Function(String) onChanged,
    required String text,
  }) {
    return ListTile(
      leading: Text(
        label,
        style: h5TextStyle,
      ),
      title: TextField(
        controller: TextEditingController(text: text),
        decoration: InputDecoration(
          suffixText: trailing,
        ),
        onChanged: onChanged,
        inputFormatters: [TextFieldFilterNumber()],
      ),
    );
  }

  ListTile listenOnWidget(DesignData data, ChatLogicChatEvent chatEvent, BuildContext context) {
    return ListTile(
      leading: const Text(
        "监听",
        style: h5TextStyle,
      ),
      title: buildLessDropdownButton<String>(
        underline: Container(),
        isExpanded: true,
        items: [
          ...data.chatLogic.msgs!.map(
                (e) => DropdownMenuItem<String>(
              child: FittedBox(
                child: msgCard(e),
              ),
              value: e.msgId!,
            ),
          )
        ],
        value: chatEvent.isRes!.listenOn,
        onChanged: (v) {
          chatEvent.isRes!.listenOn = v;
          data.notifyListeners();
        },
      ),
      trailing: openMsgsManageWidget(context, data),
    );
  }

  Widget msgCard(ChatLogicMsg msg) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FreeChip(
            label: Text(msg.type!),
          ),
          Text(
            "ID: ${msg.msgId}",
            overflow: TextOverflow.ellipsis,
            style: h7TextStyleLow,
          ),
          Text(
            msg.content ?? "",
            style: h7TextStyleLow,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      padding: const EdgeInsets.only(bottom: 4, top: 4),
    );
  }

  IconButton openMsgsManageWidget(BuildContext context, DesignData data) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (bc) {
            return Container(
              child: MsgManage(
                chatLogic: data.chatLogic,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            );
          },
        ).whenComplete(() => data.notifyListeners());
      },
      icon: const Icon(
        Icons.settings_rounded,
        color: mainIconColor,
        size: 20,
      ),
    );
  }

  SizedBox attrLists(
      BuildContext context, {
        required List<Widget> Function(BuildContext) builderListElem,
        Widget? title,
        Widget? titleTrailing,
        double? height,
      }) {
    return SizedBox(
      child: Column(
        children: [
          title != null || titleTrailing != null ? ListTile(title: title ?? Container(), trailing: titleTrailing ?? Container()) : Container(),
          Expanded(
            child: ListView(
              controller: ScrollController(),
              children: [...builderListElem(context)],
            ),
          )
        ],
        mainAxisSize: MainAxisSize.min,
      ),
      height: height ?? 200,
    );
  }

  Container sideBoxWidget(BuildContext context) {
    final chatEvent = data.activeUIPacker?.chatEvent;
    Widget content;

    if (chatEvent != null) {
      content = ListView(
        children: [
          const Text(
            "事件类型配置",
            style: h3TextStylePlus,
          ),
          const Divider(),
          ListTile(
            leading: const Text(
              "ID",
              style: h5TextStyle,
            ),
            title: Text(
              chatEvent.eventId.toString(),
            ),
          ),
          ListTile(
            leading: const Text(
              "事件类型",
              style: h5TextStyle,
            ),
            title: buildLessDropdownButton<String>(
              underline: Container(),
              value: chatEvent.eventsType,
              isExpanded: true,
              isDense: true,
              onChanged: (nv) {
                chatEvent.eventsType = nv;
                data.notifyListeners();
              },
              items: EventsType.values.map((e) => DropdownMenuItem<String>(
                  child: Text(
                    e.toEnumString(),
                  ),
                  value: e.toEnumString(),
                ),
              ).toList(),
            ),
          ),
          ListTile(
            title: sendMsgsWidget(context, chatEvent, data),
          ),
          const SizedBox(
            height: 20,
          ),
          Builder(builder: (bc) {
            if (chatEvent.eventsType == EventsType.res.toEnumString() || chatEvent.eventsType == EventsType.subres.toEnumString()) {
              return onResConfigWidget(data, context);
            } else if (chatEvent.eventsType == EventsType.timer.toEnumString()) {
              return onTimerConfigWidget(data, context);
            } else {
              return const Text("No Def Type");
            }
          })
        ],
      );
    } else {
      content = const Center(
        child: Text("No Active Event"),
      );
    }
    return Container(
      decoration: const BoxDecoration(
        border: Border(left: BorderSide(color: mainTextColorLess, width: 1)),
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(left: 10, right: 5, top: 10),
      width: 270,
      child: content,
    );
  }
}