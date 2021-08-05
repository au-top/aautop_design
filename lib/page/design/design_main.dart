import 'dart:math';

import 'package:aautop_designer/model/chatlogic_model.dart';
import 'package:aautop_designer/page/design/float_tool_bar.dart';
import 'package:aautop_designer/page/design/chatevent_card.dart';
import 'package:aautop_designer/data/chatevent_ui_packer.dart';
import 'package:aautop_designer/page/design/design_link_line_point.dart';
import 'package:aautop_designer/style/style.dart';

import 'package:aautop_designer/tool/extend_math.dart';

import 'package:aautop_designer/page/design/handle_on_event.dart';
import 'package:aautop_designer/tool/widget/dependent.dart';
import 'package:aautop_designer/tool/widget/scrollbar_view.dart';
import 'package:flutter/material.dart';


import 'package:flutter/painting.dart';
import 'package:aautop_designer/page/design.dart';
import 'package:flutter/cupertino.dart';

///
/// design 的设计区Widget 相关方法
///
extension DesignMain on DesignState {
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
                                   data.viewBoxOffset.dy / maxBarHeight,
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
                                    data.viewBoxOffset.dx / maxBarWidth,
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
        data: Theme.of(context).copyWith(
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
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: mainTextColorLess)),
      ),
    );
  }
}
