import 'package:aautop_designer/model/events_type.dart';

import 'package:aautop_designer/page/design.dart';
import 'package:flutter/material.dart';
import "package:aautop_designer/model/chatlogic_model.dart";

/// 可用于表示两个 [ChatEventUIPack] 的连接关系
/// [outChatEvent] 表示父
/// [inChatEvent] 表示子
class ResLinkInfo {
  late String outChatEventId;
  late String inChatEventId;

  ResLinkInfo(
      {required ChatLogicChatEvent inChatEvent,
      required ChatLogicChatEvent outChatEvent}) {
    outChatEventId = outChatEvent.eventId!;
    outChatEventId = inChatEvent.eventId!;
  }

  ResLinkInfo.fromRawIdStr(
      {required this.outChatEventId, required this.inChatEventId});

  bool fromUIPackMatch(
      ChatEventUIPacker testOutChatEvent, ChatEventUIPacker testInChatEvent) {
    return _chatEventMatch(
        testOutChatEvent.chatEvent, testInChatEvent.chatEvent);
  }

  bool fromChatEventMatch(
      ChatLogicChatEvent testOutChatEvent, ChatLogicChatEvent testInChatEvent) {
    return _chatEventMatch(testOutChatEvent, testInChatEvent);
  }

  bool _chatEventMatch(
      ChatLogicChatEvent testOutChatEvent, ChatLogicChatEvent testInChatEvent) {
    return testOutChatEvent.eventId == outChatEventId &&
        testInChatEvent.eventId == inChatEventId;
  }
}

enum ChatEventUIPackerLinkBesselLineConEnum { A, B }

/// ChatEventUIPacker 控制 Link Line 的配置
/// conA 表示距离 Out端的偏移量
/// conB 表示距离 In端的偏移量
class ChatEventUIPackerLinkBesselLineCon {
  Offset _conA = const Offset(
    20,
    20,
  );
  Offset _conB = const Offset(
    -20,
    -20,
  );

  /// 计算实际的控制点位置
  Map<ChatEventUIPackerLinkBesselLineConEnum, Offset> buildAbsolutePos(
      ChatEventUIPacker outChatEvent, ChatEventUIPacker inChatEvent) {
    final linkOutOffset = outChatEvent.getRightLinkPoint();
    final linkInOffset = inChatEvent.getLeftLinkPoint();
    return {
      ChatEventUIPackerLinkBesselLineConEnum.A: linkOutOffset +
          getFromConEnum(ChatEventUIPackerLinkBesselLineConEnum.A),
      ChatEventUIPackerLinkBesselLineConEnum.B: linkInOffset +
          getFromConEnum(ChatEventUIPackerLinkBesselLineConEnum.B)
    };
  }

  /// 将枚举映射为属性
  Offset getFromConEnum(ChatEventUIPackerLinkBesselLineConEnum conEnum) {
    switch (conEnum) {
      case ChatEventUIPackerLinkBesselLineConEnum.A:
        return _conA;
      case ChatEventUIPackerLinkBesselLineConEnum.B:
        return _conB;
    }
  }

  /// 使用枚举设置属性
  void setFromConEnum(
      ChatEventUIPackerLinkBesselLineConEnum conEnum, Offset newOffset) {
    switch (conEnum) {
      case ChatEventUIPackerLinkBesselLineConEnum.A:
        _conA = newOffset;
        break;
      case ChatEventUIPackerLinkBesselLineConEnum.B:
        _conB = newOffset;
        break;
    }
  }

  void setRelativeOffset(
      ChatEventUIPackerLinkBesselLineConEnum conEnum, Offset newOffset) {
    switch (conEnum) {
      case ChatEventUIPackerLinkBesselLineConEnum.A:
        _conA += newOffset;
        break;
      case ChatEventUIPackerLinkBesselLineConEnum.B:
        _conB += newOffset;
        break;
    }
  }

  ChatEventUIPackerLinkBesselLineCon();
}

///
/// ChatEventUIPacker ChatEvent 的 ui 配置封装
///
class ChatEventUIPacker extends ChangeNotifier {
  ChatLogicChatEvent chatEvent;

  /// 备注属性 [remarks]
  /// 目前无用
  String remarks = "";

  static Size sizeCon = const Size(300, 180);

  double top;
  double left;
  final linkDirIconSize = 20.0;
  final linkCircleSize = 8.0;

  final inIconColor = const Color.fromRGBO(255, 255, 255, 1.0);
  final outIconColor = const Color.fromRGBO(255, 255, 255, 1.0);

  final inColor = const Color.fromRGBO(0, 106, 255, 1.0);
  final outColor = const Color.fromRGBO(50, 200, 255, 1.0);
  final strokeWidth = 2.0;

  final activeInColor = const Color.fromRGBO(0, 106, 255, 1.0);
  final activeOutColor = const Color.fromRGBO(50, 200, 255, 1.0);
  final activeStrokeWidth = 3.0;

  /// 连接线 click 检测区域[Path] 宽度
  final lineClickWidth = 5.0;

  /// 连接线贝赛尔 控制点 size
  final conCircleRadius = 4.5;

  /// 连接线贝赛尔 控制线 size
  final conCircleLinkLineWidth = 2.4;

  /// 连接线贝赛尔 控制区(控制圈) size
  final conCircleClickWidth = 6.0;

  /// 连接线 的贝塞尔曲线控制节点表 (偏移量) 详细见  [ChatEventUIPackerLinkBesselLineCon]
  final linkBesselLineCons = <String, ChatEventUIPackerLinkBesselLineCon>{};

  ChatEventUIPacker(
      {required this.top, required this.left, required this.chatEvent}) {
    // is res or subres
    if (chatEvent.testIsAnyRes) {
      // init link line pos con map
      for (final priorityChatEventId in chatEvent.isRes!.priorityEventLists!) {
        linkBesselLineCons[priorityChatEventId] = ChatEventUIPackerLinkBesselLineCon();
      }
    }
  }

  void crossReset() {
    if (left < 5) {
      left = 5;
    }
    if (top < 5) {
      top = 5;
    }
  }

  void updatePosFromOffset(Offset offset) {
    left += offset.dx;
    top += offset.dy;
    crossReset();
  }

  void setPosFromOffset(Offset offset) {
    left = offset.dx;
    top = offset.dy;
  }
}

extension ChatEventFunction on ChatEventUIPacker {
  addResLink(ChatLogicChatEvent newInChatEvent) {
    assert(chatEvent.testIsAnyRes);
    assert(newInChatEvent.testIsAnyRes);
    chatEvent.isRes!.priorityEventLists!.add(newInChatEvent.eventId!);
    if(!linkBesselLineCons.containsKey(newInChatEvent.eventId!)){
      linkBesselLineCons[newInChatEvent.eventId!] = ChatEventUIPackerLinkBesselLineCon();
    }
  }
  delResLink(String inChatEventId){
    chatEvent.isRes!.priorityEventLists!.remove(inChatEventId);
    if(linkBesselLineCons.containsKey(inChatEventId)){
      linkBesselLineCons.remove(inChatEventId);
    }
  }
}

extension OffsetFunction on ChatEventUIPacker {
  Offset getLeftLinkPoint() {
    return Offset(left, top + ChatEventUIPacker.sizeCon.height / 2);
  }

  Offset getLeftTopPoint() {
    return Offset(left - 5, top - 5);
  }

  Offset getRightLinkPoint() {
    return Offset(left + ChatEventUIPacker.sizeCon.width + linkCircleSize / 2,
        top + ChatEventUIPacker.sizeCon.height / 2);
  }

  Offset getCenterPoint() {
    return Offset(left + ChatEventUIPacker.sizeCon.width / 2,
        top + ChatEventUIPacker.sizeCon.height / 2);
  }

  Offset getRightBottomPoint() {
    return Offset(left + ChatEventUIPacker.sizeCon.width,
        top + ChatEventUIPacker.sizeCon.height);
  }
}

extension TestPathBuilder on ChatEventUIPacker {
  Path buildCardRectPath() {
    return Path()
      ..addRect(Rect.fromLTWH(
        left,
        top,
        ChatEventUIPacker.sizeCon.width,
        ChatEventUIPacker.sizeCon.height,
      ));
  }

  Path buildClickPath(DesignData data, String inElementId) {
    final inChatEventUIPack = data.fromIdFindUIPacker(inElementId)!;
    final _abConPointMap = linkBesselLineCons[inElementId]!
        .buildAbsolutePos(this, inChatEventUIPack);
    final linkBesselLineConA =
        _abConPointMap[ChatEventUIPackerLinkBesselLineConEnum.A]!;
    final linkBesselLineConB =
        _abConPointMap[ChatEventUIPackerLinkBesselLineConEnum.B]!;
    final linkSonOffset = inChatEventUIPack.getLeftLinkPoint();
    final linkOffset = getRightLinkPoint();
    Path clickTestPath = Path();
    clickTestPath.moveTo(linkOffset.dx, linkOffset.dy + lineClickWidth);
    clickTestPath.cubicTo(
      linkBesselLineConA.dx + lineClickWidth,
      linkBesselLineConA.dy + lineClickWidth,
      linkBesselLineConB.dx + lineClickWidth,
      linkBesselLineConB.dy + lineClickWidth,
      linkSonOffset.dx,
      linkSonOffset.dy + lineClickWidth,
    );
    clickTestPath.relativeLineTo(0, lineClickWidth * -2);
    clickTestPath.cubicTo(
      linkBesselLineConB.dx - lineClickWidth,
      linkBesselLineConB.dy - lineClickWidth,
      linkBesselLineConA.dx - lineClickWidth,
      linkBesselLineConA.dy - lineClickWidth,
      linkOffset.dx,
      linkOffset.dy - lineClickWidth,
    );
    clickTestPath.close();
    return clickTestPath;
  }

  Path buildConLinkLineA(DesignData data, String inElementId) {
    final inChatEventUIPack = data.fromIdFindUIPacker(inElementId)!;
    final _abConPointMap = linkBesselLineCons[inElementId]!
        .buildAbsolutePos(this, inChatEventUIPack);
    final linkBesselLineConA =
        _abConPointMap[ChatEventUIPackerLinkBesselLineConEnum.A]!;
    _abConPointMap[ChatEventUIPackerLinkBesselLineConEnum.B]!;
    Path clickTestPath = Path();
    clickTestPath.addOval(Rect.fromCircle(
        center: linkBesselLineConA, radius: conCircleClickWidth));
    clickTestPath.close();
    return clickTestPath;
  }

  Path buildConLinkLineB(DesignData data, String inElementId) {
    final inChatEventUIPack = data.fromIdFindUIPacker(inElementId)!;
    final _abConPointMap = linkBesselLineCons[inElementId]!
        .buildAbsolutePos(this, inChatEventUIPack);
    final linkBesselLineConB =
        _abConPointMap[ChatEventUIPackerLinkBesselLineConEnum.B]!;
    Path clickTestPath = Path();
    clickTestPath.addOval(Rect.fromCircle(
        center: linkBesselLineConB, radius: conCircleClickWidth));
    clickTestPath.close();
    return clickTestPath;
  }

  Path buildLinkPoint() {
    final outPointPath = Path();
    outPointPath
      ..addRect(Rect.fromCircle(center: getRightLinkPoint(), radius: 9))
      ..close();
    return outPointPath;
  }
}
