import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:aautop_designer/page/design/design_chatevent_editor.dart';
import 'package:aautop_designer/page/design/design_dialog.dart';
import 'package:aautop_designer/page/design/design_main.dart';
import 'package:aautop_designer/data/chatevent_ui_packer.dart';
import 'package:aautop_designer/service/service_inherited.dart';
import 'package:aautop_designer/service/window_titlebar_service.dart';
import 'package:aautop_designer/style/less_popup_menu_item.dart';
import 'package:aautop_designer/tool/widget/dependent.dart';

import "package:aautop_designer/model/chatlogic_model.dart";

class DesignData extends ChangeNotifier {
  ChatLogic chatLogic;

  /// Design 区域背景颜色
  Color backgroundColors = const Color.fromRGBO(246, 246, 246, 1.0);

  /// 保存文件的Path
  String? saveDirPath;

  /// 保存文件的Name
  String? saveFileName;

  /// 最后保存时间
  DateTime lastSaveTime=DateTime.now();

  /// ChatEventUIPackers
  late List<ChatEventUIPacker> chatEventUIPackers;

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

  /// 可视图窗口偏移
  Offset get viewBoxOffset=>transformationController.toScene(Offset.zero);

  DesignData({
    required this.chatLogic,
    required this.chatEventUIPackers,
    ChatEventUIPacker? moveUIPackerData,
  }) {
    moveUIPacker.data = moveUIPackerData;
    moveUIPacker.notifyListeners();
  }

  DesignData.createHelper(this.chatLogic) {
    chatEventUIPackers = chatLogic.chatEvents!
        .asMap()
        .map(
          (k, v) => MapEntry(
            k,
            ChatEventUIPacker(
              chatEvent: v,
              top: 0,
              left: 0,
            ),
          ),
        )
        .values
        .toList();
  }
  



  Duration getLastSaveDuration(){
    return  DateTime.now().difference(lastSaveTime);

  }

  void autoSortUIPack() {
    List<ChatEventUIPacker> resTypeChatEvents = [];
    List<ChatEventUIPacker> resSubTypeChatEvents = [];
    List<ChatEventUIPacker> timerTypeChatEvents = [];

    for (var uiPackElem in chatEventUIPackers) {
      if (uiPackElem.chatEvent.testIsRes) {
        resTypeChatEvents.add(uiPackElem);
      } else if (uiPackElem.chatEvent.testIsAnySub) {
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
      ((timerTypeChatEvents.length / rowMaxCount).ceil()) * (ChatEventUIPacker.sizeCon.height + autoSortMarginOffset.dy),
    );
    Offset subResBaseOffset = autoSortMarginOffset + resStartOffset;
    if (resTypeChatEvents.isNotEmpty) {
      _autoSortSonUIPack(subResBaseOffset, resTypeChatEvents, topLayer: true);
    }
  }

  Offset _autoSortSonUIPack(Offset offsetBase, List<ChatEventUIPacker> chatEventUIPackers, {bool topLayer = false}) {
    assert(chatEventUIPackers.isNotEmpty);
    Offset nowShiftingOffset = Offset.zero;
    Offset? returnEndOffset;
    for (int index = 0, sortIndex = 0; index < chatEventUIPackers.length; index++) {
      final elem = chatEventUIPackers[index];
      if (topLayer || elem.chatEvent.testIsAnySub) {
        final newOffset = offsetBase +
            Offset(
              0,
              sortIndex * (ChatEventUIPacker.sizeCon.height + DesignData.autoSortMarginOffset.dy),
            ) +
            nowShiftingOffset;
        if (elem.chatEvent.isRes!.priorityEventLists!.isNotEmpty) {
          final sonEndChatEventOffset = _autoSortSonUIPack(
            newOffset +
                Offset(
                  ChatEventUIPacker.sizeCon.width + DesignData.autoSortMarginOffset.dx,
                  0,
                ),
            _fromIdListToChatEvents(elem.chatEvent.isRes!.priorityEventLists!),
          );
          final addHeight = sonEndChatEventOffset.dy - newOffset.dy;
          // 排序后的子元素偏移坐标必须等于或大于父元素的Y坐标
          assert(addHeight >= 0.0);
          // 累计每次排序后的Y偏移值
          nowShiftingOffset += Offset(0, addHeight);
        }
        elem.setPosFromOffset(newOffset);
        returnEndOffset = newOffset;
        sortIndex++;
      }
    }
    return returnEndOffset ?? offsetBase;
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
    //data source
    final chatLogic = ChatLogic(chatEvents: [], msgs: []);
    data = DesignData.createHelper(chatLogic)..autoSortUIPack;
    // async init
    Future(
      () async {
        buildWindowsTitlebarToService(context);
      },
    );
  }

  recreateDesignData(ChatLogic chatLogic) {
    setState(() {
      data = DesignData.createHelper(chatLogic)..autoSortUIPack();
    });
  }

  buildWindowsTitlebarToService(BuildContext context) {
    final windowsTitlebarService = ServiceManage.fromGlobalKeyGetService<WindowTitlebarService>(ServiceManage.of(context).windowTitlebarService);

    windowsTitlebarService.add(
      buildLessPopupMenuButton<Function>(
        onSelected: (f) => f(),
        child: const Text("文件"),
        items: [
          buildLessPopupMenuItem(
            child: const Text("新建"),
            value: () {
              showCreateDesignDialog(context, this);
            },
          ),
          buildLessPopupMenuItem(
            child: const Text("读取"),
            value: () {
              showReadDesignDialog(context, this);
            },
          ),
          buildLessPopupMenuItem(
            child: const Text("保存"),
            value: () {
              showSaveDesignDialog(context, data);
            },
          ),
        ],
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
