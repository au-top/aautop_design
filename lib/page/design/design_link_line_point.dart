

import 'package:aautop_designer/page/design.dart';
import 'package:aautop_designer/style/style.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:aautop_designer/data/chatevent_ui_packer.dart';
import "package:aautop_designer/model/events_type.dart";
import "package:aautop_designer/model/chatlogic_model.dart";
ChatEventUIPacker? fromEventIdFindChatEventUIPacker(
    List<ChatEventUIPacker> findLists, String findId) {
  final resFindId =
      findLists.indexWhere((element) => element.chatEvent.eventId == findId);
  if (resFindId != -1) {
    return findLists[resFindId];
  } else {
    return null;
  }
}

/// 负责绘图和向外传递控制参数 PATH
/// 所有和交互逻辑有关的内容在外边完成
/// 保证 [DesignLinkLinePoint] 的精简
class DesignLinkLinePoint extends CustomPainter {
  List<ChatEventUIPacker> chatEventUIPackers;
  DesignData designData;

  DesignLinkLinePoint(
      {required this.chatEventUIPackers, required this.designData});

  @override
  void paint(Canvas canvas, Size size) {
    Paint testPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.amber;

    //outChatEvent
    for (var chatEventUIElem in chatEventUIPackers) {
      if (chatEventUIElem.chatEvent.testIsAnyRes) {
        final linkOffset = chatEventUIElem.getRightLinkPoint();
        for (var elementId
            in chatEventUIElem.chatEvent.isRes!.priorityEventLists!) {
          //inChatEvent
          final findChatEvent =
              fromEventIdFindChatEventUIPacker(chatEventUIPackers, elementId);
          assert(findChatEvent != null);
          // 在控制表(Map)中存在
          assert(chatEventUIElem.linkBesselLineCons[elementId] != null);

          final linkSonOffset = findChatEvent!.getLeftLinkPoint();
          final activeJunctionInfo = designData.activeLinkInfo;

          final _abConPointMap = chatEventUIElem.linkBesselLineCons[elementId]!
              .buildAbsolutePos(chatEventUIElem, findChatEvent);
          final linkBesselLineConA =
              _abConPointMap[ChatEventUIPackerLinkBesselLineConEnum.A]!;
          final linkBesselLineConB =
              _abConPointMap[ChatEventUIPackerLinkBesselLineConEnum.B]!;

          final isActiveMe = activeJunctionInfo.data != null &&
              activeJunctionInfo.data!
                  .fromUIPackMatch(chatEventUIElem, findChatEvent);

          // draw link line Path
          {
            //create paint
            Paint paintLine = Paint()
              ..style = PaintingStyle.stroke
              ..filterQuality = FilterQuality.high
              ..isAntiAlias = true;
            // set line color
            if (isActiveMe) {
              // active
              paintLine.shader = ui.Gradient.linear(linkOffset, linkSonOffset, [
                chatEventUIElem.activeInColor,
                chatEventUIElem.activeOutColor,
              ], [
                0,
                1
              ]);
              paintLine.strokeWidth = chatEventUIElem.activeStrokeWidth;
            } else {
              // commonly
              paintLine.shader = ui.Gradient.linear(linkOffset, linkSonOffset, [
                chatEventUIElem.inColor,
                chatEventUIElem.outColor,
              ], [
                0,
                1
              ]);
              paintLine.strokeWidth = chatEventUIElem.strokeWidth;
            }
            Path viewPath = Path();
            viewPath.moveTo(linkOffset.dx, linkOffset.dy);
            viewPath.cubicTo(
              linkBesselLineConA.dx,
              linkBesselLineConA.dy,
              linkBesselLineConB.dx,
              linkBesselLineConB.dy,
              linkSonOffset.dx,
              linkSonOffset.dy,
            );
            canvas.drawPath(viewPath, paintLine);
          }
          // draw line con
          if (isActiveMe) {
            // create paint
            Paint paintCircle = Paint()
              ..style = PaintingStyle.stroke
              ..color = Colors.blue;

            Paint paintCircleFill = Paint()
              ..style = PaintingStyle.fill
              ..color = Colors.white;

            Paint paintLine = Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = chatEventUIElem.conCircleLinkLineWidth
              ..color = Colors.blue.shade200;

            canvas.drawLine(linkOffset, linkBesselLineConA, paintLine);
            canvas.drawCircle(linkBesselLineConA,
                chatEventUIElem.conCircleRadius - 0.8, paintCircleFill);
            canvas.drawCircle(linkBesselLineConA,
                chatEventUIElem.conCircleRadius, paintCircle);

            canvas.drawLine(linkSonOffset, linkBesselLineConB, paintLine);
            canvas.drawCircle(linkBesselLineConB,
                chatEventUIElem.conCircleRadius - 0.8, paintCircleFill);
            canvas.drawCircle(linkBesselLineConB,
                chatEventUIElem.conCircleRadius, paintCircle);
          }
          //debug paint
          if (debugPaint) {
            canvas.drawPath(
              chatEventUIElem.buildClickPath(designData, elementId),
              testPaint,
            );
            canvas.drawPath(
              chatEventUIElem.buildConLinkLineA(designData, elementId),
              testPaint,
            );
            canvas.drawPath(
              chatEventUIElem.buildConLinkLineB(designData, elementId),
              testPaint,
            );
          }
        }
        {
          if (designData.downMouseOffset != null &&
              designData.outActiveChatEventId != null &&
              designData.outActiveChatEventId ==
                  chatEventUIElem.chatEvent.eventId) {
            Paint paintLine = Paint()..style = PaintingStyle.stroke;
            paintLine.shader =
                ui.Gradient.linear(linkOffset, designData.downMouseOffset!, [
              chatEventUIElem.inColor,
              chatEventUIElem.outColor,
            ], [
              0,
              1
            ]);
            paintLine.strokeWidth = chatEventUIElem.strokeWidth;
            canvas.drawLine(
              chatEventUIElem.getRightLinkPoint(),
              designData.downMouseOffset!,
              paintLine,
            );
          }
        }
        //debug paint
        if (debugPaint) {
          canvas.drawPath(
            chatEventUIElem.buildLinkPoint(),
            testPaint,
          );
          canvas.drawPath(
            chatEventUIElem.buildCardRectPath(),
            testPaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
