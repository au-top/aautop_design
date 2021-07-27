
import "package:aautop_designer/model/chatlogic_model.dart";
import 'package:aautop_designer/model/msg_type.dart';
import 'package:aautop_designer/style/style.dart';
import 'package:aautop_designer/tool/widget/free_chip.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class MsgSelect extends StatefulWidget {
  ChatLogic dataLogicData;
  late final List<String> selectMsgList;

  MsgSelect({Key? key, required this.dataLogicData, required List<String> selectMsg}) : super(key: key) {
    selectMsgList = List<String>.from(selectMsg);
  }

  @override
  State<StatefulWidget> createState() {
    return MsgSelectState();
  }
}

class MsgSelectState extends State<MsgSelect> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final onTypeEvents = List<ChatLogicMsg>.from(widget.dataLogicData.msgs!)
      ..removeWhere(
        (element) => element.type == null || element.type == MsgType.onText.toEnumString() || element.type == MsgType.onImage.toEnumString(),
      );
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListTileTheme(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Column(
            children: [
              const ListTile(
                title: Text(
                  "选择发送消息",
                  style: h3TextStyle,
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: const EdgeInsets.all(5),
                  child: ListView.builder(
                    itemBuilder: (bc, index) => Container(
                      margin: const EdgeInsets.only(right: 15),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: mainTextColorLow.withOpacity(0.1),
                            width: 1,
                          ),
                          right: BorderSide(
                            color: mainTextColorLow.withOpacity(0.1),
                            width: 1,
                          ),
                          bottom: BorderSide(
                            color: mainTextColorLow.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                      ),
                      child: ListTile(
                        dense: true,
                        leading: FreeChip(
                          label: Text(onTypeEvents[index].type ?? ""),
                        ),
                        title: Row(
                          children: [
                            Text(
                              onTypeEvents[index].content ?? "",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        subtitle: Row(
                          children: [
                            Text(
                              "ID: ${onTypeEvents[index].msgId ?? ""}",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        trailing: Checkbox(
                          onChanged: (bool? value) {
                            if (value != null && onTypeEvents[index].msgId != null) {
                              setState(() {
                                if (widget.selectMsgList.contains(onTypeEvents[index].msgId)) {
                                  widget.selectMsgList.remove(onTypeEvents[index].msgId!);
                                } else {
                                  widget.selectMsgList.add(onTypeEvents[index].msgId!);
                                }
                              });
                            }
                          },
                          value: widget.selectMsgList.contains(onTypeEvents[index].msgId),
                        ),
                      ),
                    ),
                    itemCount: onTypeEvents.length,
                  ),
                ),
              ),
              Container(
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(null);
                      },
                      child: const Text("取消"),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(widget.selectMsgList);
                      },
                      child: const Text("确定"),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.end,
                ),
                padding: const EdgeInsets.only(bottom: 10, left: 5, right: 5, top: 10),
              )
            ],
          ),
        ),
      ),
    );
  }
}
