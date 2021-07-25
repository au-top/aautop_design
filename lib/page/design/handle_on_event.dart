import 'package:aautop_designer/page/design/design.dart';
import 'package:aautop_designer/page/design/chatevent_ui_packer.dart';
import 'package:flutter/material.dart';
import "package:aautop_designer/model_function.dart";
extension HandleOnEvent on DesignState{

  clearDesignState(
      {required bool clearMoveUIPack,
        required bool clearActiveJunctionInfo,
        required bool clearConPointEnum,
        required bool clearOutActiveChatEventId,
        required bool clearDownMoveMouse}) {
    if (clearMoveUIPack) {
      data.moveUIPacker.data = null;
    }
    if (clearActiveJunctionInfo) {
      data.activeLinkInfo.data = null;
    }
    if (clearConPointEnum) {
      data.conPointEnum = null;
    }
    if (clearOutActiveChatEventId) {
      data.outActiveChatEventId = null;
    }
    if (clearDownMoveMouse) {
      data.downMouseOffset = null;
    }
  }

  handleOnPanDown(DragDownDetails details) {
    // down
    print("down");

    final testRes = (() {
      // test click card
      for (int _i=data.chatEventUIPackers.length-1;_i>=0;_i--) {
        var element=data.chatEventUIPackers[_i];
        if (element.chatEvent.testIsAnyRes) {
          if (element.buildLinkPoint().contains(details.localPosition)) {
            clearDesignState(
                clearMoveUIPack: true,
                clearActiveJunctionInfo: true,
                clearConPointEnum: true,
                clearOutActiveChatEventId: true,
                clearDownMoveMouse: true);
            data.outActiveChatEventId = element.chatEvent.eventId;
            return true;
          }

          for (final inEventId
          in element.chatEvent.isRes!.priorityEventLists!) {
            if (element
                .buildClickPath(data, inEventId)
                .contains(details.localPosition)) {
              clearDesignState(
                  clearMoveUIPack: true,
                  clearActiveJunctionInfo: true,
                  clearConPointEnum: true,
                  clearOutActiveChatEventId: true,
                  clearDownMoveMouse: true);
              // In端存在
              assert(data.chatLogic.fromIdGetChatEvent(inEventId) != null);
              data.activeLinkInfo.data = ResLinkInfo.fromRawIdStr(
                outChatEventId: element.chatEvent.eventId!,
                inChatEventId: inEventId,
              );
              return true;
            }
          }
        }

        if (data.activeLinkInfo.data != null) {
          final outUIPack = data
              .fromIdFindUIPacker(data.activeLinkInfo.data!.outChatEventId)!;
          final inUIPack = data.activeLinkInfo.data!.inChatEventId;
          if (outUIPack
              .buildConLinkLineA(data, inUIPack)
              .contains(details.localPosition)) {
            clearDesignState(
                clearMoveUIPack: true,
                clearActiveJunctionInfo: false,
                clearConPointEnum: false,
                clearOutActiveChatEventId: true,
                clearDownMoveMouse: true);
            data.conPointEnum = ChatEventUIPackerLinkBesselLineConEnum.A;
            return true;
          }
          if (outUIPack
              .buildConLinkLineB(data, inUIPack)
              .contains(details.localPosition)) {
            clearDesignState(
                clearMoveUIPack: true,
                clearActiveJunctionInfo: false,
                clearConPointEnum: false,
                clearOutActiveChatEventId: true,
                clearDownMoveMouse: true);
            data.conPointEnum = ChatEventUIPackerLinkBesselLineConEnum.B;
            return true;
          }
        } else if (element
            .buildCardRectPath()
            .contains(details.localPosition)) {
          clearDesignState(
              clearMoveUIPack: true,
              clearActiveJunctionInfo: true,
              clearConPointEnum: true,
              clearOutActiveChatEventId: true,
              clearDownMoveMouse: true);
          data.moveUIPacker.data = element;
          return true;
        }
      }
      return false;
    })();
    if (!testRes) {
      clearDesignState(
        clearMoveUIPack: true,
        clearActiveJunctionInfo: true,
        clearConPointEnum: true,
        clearOutActiveChatEventId: true,
        clearDownMoveMouse: true,
      );
    }
    data.moveUIPacker.notifyListeners();
  }


  handleOnPanUpdate(DragUpdateDetails details) {
    data.downMouseOffset = details.localPosition;
    if (data.moveUIPacker.data != null) {
      data.moveUIPacker.data!.updatePosFromOffset(details.delta);
    }else if (data.conPointEnum != null && data.activeLinkInfo.data != null) {
      final junctionInfo = data.activeLinkInfo.data!;
      final outChatEventPack =
      data.fromIdFindUIPacker(junctionInfo.outChatEventId);
      outChatEventPack!.linkBesselLineCons[junctionInfo.inChatEventId]!
          .setRelativeOffset(data.conPointEnum!, details.delta);
    }
    data.moveUIPacker.notifyListeners();
  }

  handleOnPanEnd([DragEndDetails? t]) {
    print("clear");

    if (data.outActiveChatEventId != null && data.downMouseOffset != null) {
      for (final nextElem in data.chatEventUIPackers) {
        if (nextElem.buildCardRectPath().contains(data.downMouseOffset!) &&
            nextElem.chatEvent.testIsAnyRes) {
          final findChatEventUIPack =
          data.fromIdFindUIPacker(data.outActiveChatEventId!);
          assert(findChatEventUIPack != null);
          findChatEventUIPack!.addResLink(nextElem.chatEvent);
          break;
        }
      }
    }

    clearDesignState(
      clearMoveUIPack: true,
      clearActiveJunctionInfo: false,
      clearConPointEnum: true,
      clearOutActiveChatEventId: true,
      clearDownMoveMouse: true,
    );
    data.moveUIPacker.notifyListeners();
  }

  handleOnAddCard() {
    data.insetChatEvent(
        chatEvents: ChatLogicFunction.createChatEvent(), left: 10, top: 10);
    data.notifyListeners();
  }
  handleOnAutoSort(){
    data.autoSortUIPack();
    data.notifyListeners();
  }




}