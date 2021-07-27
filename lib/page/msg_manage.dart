import 'package:aautop_designer/style/less_dropdown_button.dart';
import 'package:aautop_designer/style/style.dart';
import 'package:aautop_designer/tool/widget/dependent.dart';
import 'package:aautop_designer/tool/widget/free_chip.dart';
import 'package:flutter/material.dart';
import 'package:aautop_designer/data/functions.dart';
import "package:aautop_designer/model/chatlogic.dart";
import "package:aautop_designer/model/chatlogic_msg.dart";
import "package:aautop_designer/model/msg_type.dart";
import "package:aautop_designer/model_function.dart";

class MsgManage extends StatefulWidget {
  ChatLogic chatLogic;

  MsgManage({Key? key, required this.chatLogic}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MsgManageState();
  }
}

class MsgManageStateData {
  String? activeMsgId;
}

class MsgManageState extends State<MsgManage> {
  final stateDataPack = DataPack<MsgManageStateData>(data: MsgManageStateData());
  ScrollController msgListScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      child: Scaffold(
        body: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: Dependent<DataPack<ChatLogic>>(
            builder: (bc, dataChatLogic) {
              return Row(
                children: [
                  Expanded(
                    child: Dependent<DataPack<MsgManageStateData>>(
                      builder: (bc, data) {
                        if (data.data.activeMsgId != null && dataChatLogic.data.msgs!.indexWhere((element) => data.data.activeMsgId == element.msgId!) != -1) {
                          final showMsgElem = dataChatLogic.data.msgs![dataChatLogic.data.msgs!.indexWhere((element) => data.data.activeMsgId == element.msgId!)];
                          return SizedBox(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                    child: const ListTile(
                                      leading: Text(
                                        "编辑器",
                                        style: h2TextStyleMin,
                                      ),
                                    ),
                                    padding: const EdgeInsets.only(
                                      bottom: 5,
                                      top: 5,
                                    ),
                                  ),
                                  const Divider(
                                    height: 0.5,
                                  ),
                                  ListTile(
                                    leading: const Text("ID"),
                                    title: Text(showMsgElem.msgId!),
                                  ),
                                  ListTile(
                                    leading: const Text("类型"),
                                    title: buildLessDropdownButton<String>(
                                      onChanged: (e) {
                                        showMsgElem.type = e;
                                        dataChatLogic.notifyListeners();
                                      },
                                      isExpanded: true,
                                      items: [
                                        ...MsgType.values.map((e) => e.toEnumString()).map(
                                              (e) => DropdownMenuItem(
                                                child: Text(e),
                                                value: e,
                                              ),
                                            )
                                      ],
                                      value: showMsgElem.type,
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "内容表达式",
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                          child: Card(
                                            elevation: 1,
                                            shadowColor: Colors.black26,
                                            child: Container(
                                              child: Material(
                                                child: TextField(
                                                  controller: TextEditingController(
                                                    text: showMsgElem.content!,
                                                  ),
                                                  decoration: const InputDecoration(
                                                    hintText: "消息表达式",
                                                    border: InputBorder.none,
                                                    isDense: true,
                                                  ),
                                                  maxLines: null,
                                                  onChanged: (v) {
                                                    showMsgElem.content = v;
                                                  },
                                                  style: h7TextStyleLow,
                                                ),
                                                color: Colors.transparent,
                                              ),
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 5,
                                              ),
                                              constraints: const BoxConstraints(
                                                minHeight: 100,
                                                maxHeight: 150,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                  ),
                                  ListTile(
                                    trailing: ElevatedButton(
                                      onPressed: () {
                                        dataChatLogic.notifyListeners();
                                      },
                                      child: const Text("刷新"),
                                      style: ButtonStyle(
                                        elevation: MaterialStateProperty.all(0),
                                        padding: MaterialStateProperty.all(
                                          const EdgeInsets.symmetric(
                                            horizontal: 30,
                                            vertical: 8,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                            ),
                            height: double.infinity,
                          );
                        } else {
                          //no find
                          return const Center(
                            child: Text(
                              "No Find Elem",
                              style: h3TextStyle,
                            ),
                          );
                        }
                      },
                      data: stateDataPack,
                    ),
                  ),
                  msgManageSideBoxWidget(dataChatLogic)
                ],
              );
            },
            data: createDependentDataPack(widget.chatLogic),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      dense: true,
    );
  }

  Container msgManageSideBoxWidget(DataPack<ChatLogic> dataChatLogic) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(color: Colors.black45, width: 0.2),
        ),
      ),
      width: 300,
      child: Column(
        children: [
          Material(
            child: ListTile(
              title: const Text(
                "消息列表",
                style: h2TextStyleMin,
              ),
              trailing: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      dataChatLogic.data.msgs!.add(
                        ChatLogicMsg(
                          type: MsgType.text.toEnumString(),
                          content: '',
                          msgId: chatLogicMsgIDBuild(),
                        ),
                      );
                      dataChatLogic.notifyListeners();
                    },
                    icon: const Icon(
                      Icons.add,
                      color: mainIconColor,
                    ),
                  ),
                ],
                mainAxisSize: MainAxisSize.min,
              ),
              dense: true,
            ),
            color: Colors.transparent,
          ),
          Expanded(
            child: ListView.builder(
              controller: msgListScrollController,
              padding: const EdgeInsets.only(left: 5),
              itemBuilder: (bc, index) {
                final msgData = dataChatLogic.data.msgs![index];
                return Material(
                  child: InkWell(
                    child: Container(
                      child: ListTile(
                        leading: FreeChip(
                          label: Text(
                            dataChatLogic.data.msgs![index].type!,
                          ),
                        ),
                        dense: true,
                        title: Text(
                          "${dataChatLogic.data.msgs![index].content}".trim(),
                          overflow: TextOverflow.ellipsis,
                          style: h5TextStyle,
                          maxLines: 1,
                        ),
                        subtitle: Text(
                          "ID: ${dataChatLogic.data.msgs![index].msgId}".trim(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        trailing: msgConfigWidget(dataChatLogic, index),
                      ),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black38,
                            width: 0.2,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      stateDataPack.data.activeMsgId = msgData.msgId;
                      dataChatLogic.notifyListeners();
                    },
                  ),
                  color: Colors.transparent,
                );
              },
              itemCount: dataChatLogic.data.msgs!.length,
            ),
          )
        ],
      ),
    );
  }

  PopupMenuButton<Function> msgConfigWidget(DataPack<ChatLogic> dataChatLogic, int index) {
    return PopupMenuButton<Function>(
      elevation: 2,
      padding: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      itemBuilder: (BuildContext context) {
        return [
          msgManageDeleteButtonWidget(dataChatLogic, index),
        ];
      },
      child: const Icon(
        Icons.settings_rounded,
        color: mainIconColor,
      ),
      onSelected: (v) => v(),
    );
  }

  PopupMenuItem<Function> msgManageDeleteButtonWidget(DataPack<ChatLogic> dataChatLogic, int index) {
    return PopupMenuItem(
      height: 18,
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: const ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20),
        leading: Icon(
          Icons.close_rounded,
          color: mainIconColor,
        ),
        title: Text(
          "删除",
          style: h5TextStyle,
        ),
      ),
      value: () {
        final delMsg = dataChatLogic.data.msgs![index];
        showDialog(
          context: context,
          builder: (bc) {
            final editLists = dataChatLogic.data.findMsgInEvent(findMsgId: delMsg.msgId!).toList();
            return Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                width: 400,
                height: 250,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Material(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "警告",
                        style: h3TextStyle.copyWith(color: mainWarningColor),
                      ),
                      const Text("删除这条Msg可能会改变以下Events"),
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (bc, index) {
                            final findId = editLists[index];
                            final findEvent = dataChatLogic.data.fromIdGetChatEvent(findId);
                            if (findEvent != null) {
                              return Container(
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(text: "ID: ${findEvent.eventId.toString()}"),
                                      const WidgetSpan(
                                          child: SizedBox(
                                        width: 10,
                                      )),
                                      WidgetSpan(
                                        child: FreeChip(
                                          label: Text(
                                            findEvent.eventsType.toString(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                margin: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                              );
                            } else {
                              return Text("No Find Event Id $findId");
                            }
                          },
                          itemCount: editLists.length,
                        ),
                      ),
                      Theme(
                        data: ThemeData(
                          elevatedButtonTheme: ElevatedButtonThemeData(
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(child: Container()),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                              child: const Text("删除"),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(mainWarningColor),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: const Text("取消"),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(mainColor),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  color: Colors.transparent,
                ),
              ),
            );
          },
        ).then((value) {
          if (value == true) {
            dataChatLogic.data.delMsg(delMsgId: delMsg.msgId!);
            dataChatLogic.notifyListeners();
          }
        });
      },
    );
  }
}
