import 'dart:math';
import 'package:aautop_designer/data/mock.dart';
import 'package:aautop_designer/model/chatlogic_msg.dart';
import 'package:aautop_designer/page/design/float_tool_bar.dart';
import 'package:aautop_designer/page/msg_select.dart';
import 'package:aautop_designer/page/msg_manage.dart';
import 'package:aautop_designer/page/design/chatevent_card.dart';
import 'package:aautop_designer/page/design/chatevent_ui_packer.dart';
import 'package:aautop_designer/page/design/design_link_line_point.dart';
import 'package:aautop_designer/style/less_dropdown_button.dart';
import 'package:aautop_designer/tool/extend_math.dart';
import 'package:aautop_designer/tool/textfield_filter.dart';
import 'package:aautop_designer/tool/time_tool.dart';
import 'package:aautop_designer/page/design/handle_on_event.dart';
import 'package:aautop_designer/tool/widget/dependent.dart';
import 'package:aautop_designer/tool/widget/free_chip.dart';
import 'package:aautop_designer/tool/widget/scrollbar_view.dart';
import 'package:flutter/material.dart';
import "package:aautop_designer/model/chatlogic.dart";
import "package:aautop_designer/model/chatlogic_chatevent.dart";
import "package:aautop_designer/model/chatlogic_chatevents_timecon.dart";
import "package:aautop_designer/model/events_type.dart";
import "package:aautop_designer/model_function.dart";
import 'package:flutter/painting.dart';

import '../../style/style.dart';

class DesignData extends ChangeNotifier {
  late ChatLogic chatLogic;
  Color backgroundColors = const Color.fromRGBO(246, 246, 246, 1.0);

  /// ChatEventUIPackers
  List<ChatEventUIPacker> chatEventUIPackers = [];

  /// 选中的移动对象
  DataPack<ChatEventUIPacker?> moveUIPacker = createDependentDataPack<ChatEventUIPacker?>(null);

  /// 选中的UIPack对象
  ChatEventUIPacker? activeUIPacker;

  /// 选中连接线的关系关联 对象
  DataPack<ResLinkInfo?> activeLinkInfo = createDependentDataPack<ResLinkInfo?>(null);

  /// 选中连接线的控制枚举
  ChatEventUIPackerLinkBesselLineConEnum? conPointEnum;

  /// 插入连接线时的 out 端ID
  String? outActiveChatEventId;

  /// 按下时鼠标的位置
  Offset? downMouseOffset;

  /// transformationController
  TransformationController transformationController = TransformationController();

  /// 滚动条 Size
  static const scrollbarSize = 8.0;

  /// 自动排序时的间距
  static const autoSortMarginOffset = Offset(25, 15);

  DesignData({
    required this.chatLogic,
    required this.chatEventUIPackers,
    ChatEventUIPacker? moveUIPackerData,
  }) {
    moveUIPacker.data = moveUIPackerData;
    moveUIPacker.notifyListeners();
  }

  void autoSortUIPack() {
    List<ChatEventUIPacker> resTypeChatEvents = [];
    List<ChatEventUIPacker> resSubTypeChatEvents = [];
    List<ChatEventUIPacker> timerTypeChatEvents = [];

    for (var uiPackElem in chatEventUIPackers) {
      if (uiPackElem.chatEvent.testIsRes) {
        resTypeChatEvents.add(uiPackElem);
      } else if (uiPackElem.chatEvent.testIsSubRes) {
        resSubTypeChatEvents.add(uiPackElem);
      } else if (uiPackElem.chatEvent.testIsTimer) {
        timerTypeChatEvents.add(uiPackElem);
      } else {
        assert(false);
      }
    }

    /// 开始设置 timer 位置
    const rowMaxCount = 6;
    timerTypeChatEvents.asMap().forEach((index, value) {
      final newOffset = Offset(
            (index % rowMaxCount) * (ChatEventUIPacker.sizeCon.width + autoSortMarginOffset.dx),
            (index ~/ rowMaxCount) * (ChatEventUIPacker.sizeCon.height + autoSortMarginOffset.dy),
          ) +
          autoSortMarginOffset;
      value.setPosFromOffset(newOffset);
    });

    var resStartOffset = Offset(
      0,
      ((timerTypeChatEvents.length ~/ rowMaxCount) + 1) * (ChatEventUIPacker.sizeCon.height + autoSortMarginOffset.dy),
    );
    Offset subResBaseOffset = autoSortMarginOffset + resStartOffset;
    _autoSortSonUIPack(subResBaseOffset, resTypeChatEvents);
  }

  Offset _autoSortSonUIPack(Offset offsetBase, List<ChatEventUIPacker> chatEventUIPackers) {
    assert(chatEventUIPackers.isNotEmpty);
    Offset? returnEndOffset;
    Offset sonOffset = Offset.zero;
    for (int index = 0; index < chatEventUIPackers.length; index++) {
      final elem = chatEventUIPackers[index];
      final newOffset = offsetBase +
          Offset(
            0,
            index * (ChatEventUIPacker.sizeCon.height + DesignData.autoSortMarginOffset.dy),
          ) +
          sonOffset;

      if (elem.chatEvent.isRes!.priorityEventLists!.isNotEmpty) {
        sonOffset += Offset(
          0,
          _autoSortSonUIPack(
                newOffset + Offset(ChatEventUIPacker.sizeCon.width + DesignData.autoSortMarginOffset.dx, 0),
                _fromIdListToChatEvents(elem.chatEvent.isRes!.priorityEventLists!),
              ).dy -
              ChatEventUIPacker.sizeCon.height -
              DesignData.autoSortMarginOffset.dy,
        );
      }
      elem.setPosFromOffset(newOffset);
      returnEndOffset = newOffset;
    }
    return returnEndOffset!;
  }

  List<ChatEventUIPacker> _fromIdListToChatEvents(List<String> idList) {
    final a = (idList.map((id) => fromIdFindUIPacker(id)).toList()..removeWhere((element) => element == null));
    return List.castFrom<ChatEventUIPacker?, ChatEventUIPacker>(a);
  }

  ChatEventUIPacker? fromIdFindUIPacker(String id) {
    final chatEventUIPackId = chatEventUIPackers.indexWhere((element) => element.chatEvent.eventId == id);
    return chatEventUIPackId != -1 ? chatEventUIPackers[chatEventUIPackId] : null;
  }

  insetChatEvent({required ChatLogicChatEvent chatEvents, double? top, double? left}) {
    if (!chatLogic.chatEvents!.contains(chatEvents)) {
      chatLogic.chatEvents!.add(chatEvents);
    }
    chatEventUIPackers.add(
      ChatEventUIPacker(
        top: top ?? 0.0,
        left: left ?? 0.0,
        chatEvent: chatEvents,
      ),
    );
  }

  addResInChatEventLink(ChatEventUIPacker outChatEvent, ChatEventUIPacker inChatEvent) {
    outChatEvent.chatEvent.isRes!.priorityEventLists = (outChatEvent.chatEvent.isRes!.priorityEventLists!.toSet()..add(inChatEvent.chatEvent.eventId!)).toList();
  }

  delResInChatEventLink(String delOutChatEventId, String delInChatEventId) {
    final findOutChatEvent = fromIdFindUIPacker(delOutChatEventId);
    assert(findOutChatEvent != null);
    findOutChatEvent!.delResLink(delInChatEventId);
    notifyListeners();
  }

  delChatEvent(String delChatEventId) {
    chatEventUIPackers.removeWhere((element) => element.chatEvent.eventId == delChatEventId);
    chatLogic.chatEvents!.removeWhere((element) => element.eventId == delChatEventId);
    for (var element in chatEventUIPackers) {
      if (element.chatEvent.testIsAnyRes) {
        element.delResLink(delChatEventId);
      }
    }
    notifyListeners();
  }

  void protectRunningState() {
    if (outActiveChatEventId != null) {
      if (fromIdFindUIPacker(outActiveChatEventId!) == null) {
        outActiveChatEventId = null;
      }
    }

    if (activeLinkInfo.data != null) {
      final outChatEvent = fromIdFindUIPacker(activeLinkInfo.data!.outChatEventId);
      final inChatEvent = fromIdFindUIPacker(activeLinkInfo.data!.inChatEventId);
      if (outChatEvent == null || inChatEvent == null) {
        activeLinkInfo.data = null;
      } else {
        if (!outChatEvent.linkBesselLineCons.containsKey(activeLinkInfo.data!.inChatEventId)) {
          activeLinkInfo.data = null;
        }
      }
    }
    if (activeUIPacker != null) {
      if (fromIdFindUIPacker(activeUIPacker!.chatEvent.eventId!) == null) {
        activeUIPacker = null;
      }
    }

    if (moveUIPacker.data != null) {
      if (fromIdFindUIPacker(moveUIPacker.data!.chatEvent.eventId!) == null) {
        moveUIPacker.data = null;
      }
    }
  }

  @override
  void notifyListeners() {
    protectRunningState();
    super.notifyListeners();
  }
}

class Design extends StatefulWidget {
  const Design({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DesignState();
  }
}

class DesignState extends State<Design> {
  late DesignData data;

  @override
  void initState() {
    super.initState();
    final chatLogic = mockData();
    final chatEventUIPackers = chatLogic.chatEvents!
        .asMap()
        .map(
          (k, v) => MapEntry(
            k,
            ChatEventUIPacker(
              chatEvent: v,
              top: k * ChatEventUIPacker.sizeCon.height + (k + 1) * 30,
              left: 30.0,
            ),
          ),
        )
        .values
        .toList();
    data = DesignData(
      chatLogic: chatLogic,
      chatEventUIPackers: chatEventUIPackers,
    );
  }

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
              items: EventsType.values
                  .map(
                    (e) => DropdownMenuItem<String>(
                      child: Text(
                        e.toEnumString(),
                      ),
                      value: e.toEnumString(),
                    ),
                  )
                  .toList(),
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

  Widget designMain() {
    return Column(
      children: [

        // header tool bar
        designMainHeaderToolBar(),
        // design
        Expanded(
          child: SizedBox(
            child: designMainContent(),
            width: double.infinity,
          ),
        ),
      ],
    );
  }

  LayoutBuilder designMainContent() {
    return LayoutBuilder(
      builder: (bc, viewBoxSize) {
        return Dependent<DesignData>(
          data: data,
          builder: (bc, data) => Dependent<DataPack<ResLinkInfo?>>(
            data: data.activeLinkInfo,
            builder: (bc, _) => Dependent<DataPack<ChatEventUIPacker?>>(
              data: data.moveUIPacker,
              builder: (bc, _) {
                const minScaleValue = 0.6;
                return Builder(
                  builder: (bc) {
                    double boxContentWidth = viewBoxSize.maxWidth * (1 + 1 - minScaleValue);
                    double boxContentHeight = viewBoxSize.maxHeight * (1 + 1 - minScaleValue);
                    final chatEventUIPackerBuildWidgets = [];

                    for (var chatEventUIPacker in data.chatEventUIPackers) {
                      final maxOffset = chatEventUIPacker.getRightBottomPoint();

                      boxContentWidth < maxOffset.dx ? boxContentWidth = maxOffset.dx : null;
                      boxContentHeight < maxOffset.dy ? boxContentHeight = maxOffset.dy : null;

                      ChatEventCardMode chatEventCardMode;

                      if (data.outActiveChatEventId == null) {
                        if (data.activeUIPacker != null && chatEventUIPacker.chatEvent.eventId == data.activeUIPacker!.chatEvent.eventId) {
                          chatEventCardMode = ChatEventCardMode.active;
                        } else {
                          chatEventCardMode = ChatEventCardMode.ordinary;
                        }
                      } else if (chatEventUIPacker.chatEvent.testIsAnyRes) {
                        chatEventCardMode = ChatEventCardMode.high;
                      } else {
                        chatEventCardMode = ChatEventCardMode.less;
                      }

                      // build card widgets
                      chatEventUIPackerBuildWidgets.add(
                        ChatEventCard(
                          onTap: () {
                            data.activeUIPacker = chatEventUIPacker;
                            data.notifyListeners();
                          },
                          chatLogic: data.chatLogic,
                          chatEventUIPacker: chatEventUIPacker,
                          mode: chatEventCardMode,
                        ),
                      );
                    }

                    final scW = boxContentWidth / viewBoxSize.maxWidth;
                    final scH = boxContentHeight / viewBoxSize.maxHeight;
                    final sc = max(scW, scH);
                    return Stack(
                      children: [
                        InteractiveViewer(
                          maxScale: 1.1,
                          minScale: minScaleValue,
                          constrained: false,
                          transformationController: data.transformationController,
                          child: GestureDetector(
                            child: Container(
                              color: data.backgroundColors,
                              width: viewBoxSize.maxWidth * sc,
                              height: viewBoxSize.maxHeight * sc,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  //card
                                  ...chatEventUIPackerBuildWidgets,
                                  Positioned(
                                    child: CustomPaint(
                                      painter: DesignLinkLinePoint(
                                        designData: data,
                                        chatEventUIPackers: data.chatEventUIPackers,
                                      ),
                                    ),
                                    left: 0,
                                    top: 0,
                                  ),
                                ],
                              ),
                            ),
                            onPanDown: handleOnPanDown,
                            onPanUpdate: handleOnPanUpdate,
                            onPanEnd: handleOnPanEnd,
                            onPanCancel: handleOnPanEnd,
                          ),
                        ),
                        floatLinkToolBarBuilder(),
                        Dependent<TransformationController>(
                          builder: (bc, transformationController) {
                            final maxBarHeight = boxContentHeight;
                            return Positioned(
                              child: SizedBox(
                                child: ScrollbarView(
                                  showLength: minMax(
                                    (viewBoxSize.maxHeight / data.transformationController.value.getMaxScaleOnAxis()) / maxBarHeight,
                                    minValue: 0.0,
                                    maxValue: 1.0,
                                  ),
                                  start: minMax(
                                    transformationController.toScene(Offset.zero).dy / maxBarHeight,
                                    minValue: 0.0,
                                    maxValue: 1.0,
                                  ),
                                ),
                                width: DesignData.scrollbarSize,
                              ),
                              top: 0,
                              bottom: DesignData.scrollbarSize,
                              right: 0,
                            );
                          },
                          data: data.transformationController,
                        ),
                        Dependent<TransformationController>(
                          builder: (bc, transformationController) {
                            final maxBarWidth = boxContentWidth;
                            return Positioned(
                              child: SizedBox(
                                child: ScrollbarView(
                                  scrollbarViewDir: ScrollbarViewDir.transverse,
                                  showLength: minMax(
                                    (viewBoxSize.maxWidth / data.transformationController.value.getMaxScaleOnAxis()) / maxBarWidth,
                                    minValue: 0.0,
                                    maxValue: 1.0,
                                  ),
                                  start: minMax(
                                    transformationController.toScene(Offset.zero).dx / maxBarWidth,
                                    minValue: 0.0,
                                    maxValue: 1.0,
                                  ),
                                ),
                                height: DesignData.scrollbarSize,
                              ),
                              left: 0,
                              bottom: 0,
                              right: DesignData.scrollbarSize,
                            );
                          },
                          data: data.transformationController,
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Container designMainHeaderToolBar() {
    return Container(
      child: Theme(
        child: Material(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Tooltip(
                child: ElevatedButton(
                  onPressed: handleOnAddCard,
                  child: Container(
                    child: Row(
                      children: const [
                        Icon(Icons.add_rounded),
                        SizedBox(
                          width: 5,
                        ),
                        Text("新增 Event")
                      ],
                      mainAxisSize: MainAxisSize.min,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                  ),
                ),
                message: "新增 ChatEvent",
              ),
              Tooltip(
                child: ElevatedButton(
                  onPressed: handleOnAutoSort,
                  child: Container(
                    child: Row(
                      children: const [
                        Icon(Icons.sort_rounded),
                        SizedBox(
                          width: 5,
                        ),
                        Text("自动排序")
                      ],
                      mainAxisSize: MainAxisSize.min,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                  ),
                ),
                message: "自动整理 ChatEvent",
              ),
            ],
          ),
          color: Colors.transparent,
        ),
        data: ThemeData(
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.resolveWith((states) => states.contains(MaterialState.pressed) ? Theme.of(context).splashColor : Colors.transparent),
              foregroundColor: MaterialStateProperty.all(Colors.black),
              textStyle: MaterialStateProperty.all(h5TextStyle.copyWith(color: Colors.black)),
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
              elevation: MaterialStateProperty.all(0),
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
          ),
          iconTheme: const IconThemeData(size: 20),
        ),
      ),
      width: double.infinity,
      height: 42,
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: mainTextColorLess)),
      ),
    );
  }

  Widget floatLinkToolBarBuilder() {
    Widget floatToolBarWidget;
    if (data.activeLinkInfo.data != null) {
      floatToolBarWidget = buildFloatToolBarWidget(buildFloatLinkToolBarWidget(), true, title: "Link");
    } else if (data.activeUIPacker != null) {
      floatToolBarWidget = buildFloatToolBarWidget(buildFloatChatEventToolBarWidget(), true, title: "ChatEvent");
    } else {
      floatToolBarWidget = buildFloatToolBarWidget(
        const SizedBox(
          width: 10,
          height: 10,
        ),
        false,
      );
    }
    return floatToolBarWidget;
  }

  Container dividingVertical() {
    return Container(
      height: 15,
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(
            width: 1,
            color: Colors.black38,
          ),
        ),
      ),
    );
  }

  InkWell floatToolBarButton({
    required String label,
    required void Function() onTap,
    required Widget showIcon,
    TextStyle? textStyle,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(3),
      onTap: onTap,
      child: Padding(
        child: Row(
          children: [
            Text(
              label,
              style: textStyle ?? h4TextStyleLow,
            ),
            showIcon
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
        ),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListTileTheme(
        horizontalTitleGap: 10,
        contentPadding: const EdgeInsets.all(0),
        dense: true,
        child: Row(
          children: [
            Expanded(
              child: designMain(),
            ),
            Dependent<DesignData>(
              data: data,
              builder: (context, data) {
                return sideBoxWidget(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
