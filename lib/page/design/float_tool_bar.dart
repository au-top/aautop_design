import 'dart:math';

import 'package:aautop_designer/page/design/design.dart';
import 'package:aautop_designer/page/design/chatevent_ui_packer.dart';
import 'package:aautop_designer/page/design/design_link_line_point.dart';
import 'package:aautop_designer/style/style.dart';
import 'package:flutter/material.dart';

extension FloatToolBar on DesignState {
  Widget buildFloatChatEventToolBarWidget() {
    return Row(
      children: [
        floatToolBarButton(
          showIcon: const Icon(Icons.close_rounded),
          label: '删除',
          onTap: () {
            final delLinkInfo = data.activeUIPacker;
            assert(delLinkInfo != null);
            data.delChatEvent(data.activeUIPacker!.chatEvent.eventId!);
          },
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
    );
  }

  Widget buildFloatLinkToolBarWidget() {
    return Row(
      children: [
        floatToolBarButton(
          showIcon: const Icon(Icons.close_rounded),
          label: '删除',
          onTap: () {
            final delLinkInfo = data.activeLinkInfo.data;
            assert(delLinkInfo != null);

            data.delResInChatEventLink(
                delLinkInfo!.outChatEventId, delLinkInfo.inChatEventId);
          },
        ),
        dividingVertical(),
        floatToolBarButton(
          showIcon: const Icon(Icons.replay_rounded),
          label: '重置',
          onTap: () {
            final linkInfo = data.activeLinkInfo.data!;
            final findOutChatEvent =
                data.fromIdFindUIPacker(linkInfo.outChatEventId);
            assert(findOutChatEvent!.linkBesselLineCons
                .containsKey(linkInfo.inChatEventId));
            findOutChatEvent!.linkBesselLineCons[linkInfo.inChatEventId] =
                ChatEventUIPackerLinkBesselLineCon();
            data.notifyListeners();
          },
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
    );
  }

  Widget buildFloatToolBarWidget(
    Widget showToolBar,
    bool showState, {
    String? title,
  }) {
    Widget floatToolBarWidget = AnimatedSize(
      duration: const Duration(milliseconds: 200),
      child: showToolBar,
    );
    floatToolBarWidget = Material(
      elevation: 2,
      shadowColor: Colors.black54,
      borderRadius: BorderRadius.circular(5),
      color: Colors.white,
      child: floatToolBarWidget,
    );
    floatToolBarWidget = AnimatedOpacity(
      opacity: showState ? 1 : 0,
      duration: const Duration(milliseconds: 200),
      child: floatToolBarWidget,
    );
    floatToolBarWidget = IconTheme(
      data: const IconThemeData(size: 20, color: mainTextColorLow),
      child: floatToolBarWidget,
    );
    floatToolBarWidget = Stack(
      clipBehavior: Clip.none,
      children: [
        floatToolBarWidget,
        title != null
            ? Positioned(
                top: -5,
                left: -22,
                child: Transform.rotate(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: .5,
                            offset: Offset(1, 1))
                      ],
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Text(
                          title,
                          style: h7TextStyle.copyWith(color: mainColor),
                        )
                      ],
                      mainAxisSize: MainAxisSize.min,
                    ),
                  ),
                  angle: (pi / 360) * -45,
                ),
              )
            : const SizedBox(
                width: 0,
                height: 0,
              )
      ],
    );

    floatToolBarWidget = AnimatedPositioned(
      key: const ValueKey("floatToolBarWidget"),
      child: Align(
        alignment: Alignment.center,
        child: floatToolBarWidget,
      ),
      bottom: showState ? 20 : -5,
      left: 10,
      right: 10,
      duration: const Duration(milliseconds: 200),
    );

    return floatToolBarWidget;
  }
}
