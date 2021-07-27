import 'dart:convert';
import 'dart:io';

import "package:aautop_designer/model/chatlogic_model.dart";
import 'package:flutter/material.dart';
import 'package:aautop_designer/page/design/design.dart';
import 'package:aautop_designer/style/style.dart';
import 'package:filepicker_windows/filepicker_windows.dart';


class SaveDesignDialog extends StatefulWidget {
  final DesignData designData;

  const SaveDesignDialog({Key? key, required this.designData}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SaveDesignDialogState();
  }

  static String createDefaultFileName() {
    final dateTimeNow = DateTime.now();
    return "${dateTimeNow.year}_${dateTimeNow.month}_${dateTimeNow.day}_${dateTimeNow.hour}_${dateTimeNow.minute}_${dateTimeNow.second}";
  }
}

class _SaveDesignDialogState extends State<SaveDesignDialog> {
  /// proxy to designData attr
  set saveDirPath(v) {
    widget.designData.saveDirPath = v;
  }

  String? get saveDirPath {
    return widget.designData.saveDirPath;
  }

  set createFileName(v) {
    widget.designData.createFileName = v;
  }

  String get createFileName {
    widget.designData.createFileName = ReadDesignDialog.createDefaultFileName();
    return widget.designData.createFileName!;
  }

  void saveToFile() {
    if (saveDirPath != null) {
      File saveToFile = File("$saveDirPath${Platform.pathSeparator}$createFileName.json");
      final writeJson = jsonEncode(widget.designData.chatLogic.toJson());
      saveToFile.createSync(recursive: true);
      saveToFile.writeAsStringSync(writeJson);
      Navigator.of(context).pop();
    }
  }

  bool testButtonUsable() {
    return saveDirPath != null && createFileName.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: const IconThemeData(
        size: 26,
      ),
      child: ListTileTheme(
        child: Container(
          width: 450,
          height: 280,
          clipBehavior: Clip.antiAlias,
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 1,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  ListTile(
                    leading: Column(
                      children: const [
                        Icon(
                          Icons.insert_drive_file,
                          color: Colors.blue,
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    title: TextField(
                      decoration: const InputDecoration(labelText: "新建文件名", isDense: true, suffixText: ".json"),
                      controller: TextEditingController(
                        text: createFileName,
                      ),
                      onChanged: (v) {
                        createFileName = v;
                      },
                    ),
                  ),
                  Tooltip(
                    child: Builder(
                      builder: (bc) {
                        void onTap() {
                          final dir = DirectoryPicker()
                            ..defaultFilterIndex = 0
                            ..title = '选择保存到的文件夹';
                          final f = dir.getDirectory();
                          setState(() {
                            saveDirPath = f?.path;
                          });
                        }

                        return ListTile(
                          leading: Column(
                            children: const [
                              Icon(
                                Icons.save_rounded,
                                color: Colors.blue,
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                          title: const Text("保存路径"),
                          subtitle: Text(
                            saveDirPath ?? "无路径",
                            overflow: TextOverflow.ellipsis,
                            style: h8TextStyleLow,
                          ),
                          trailing: ElevatedButton(
                            child: const Text("选择"),
                            onPressed: onTap,
                          ),
                          onTap: onTap,
                        );
                      },
                    ),
                    message: saveDirPath ?? "无路径",
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.view_in_ar,
                      color: Colors.blue,
                    ),
                    title: const Text(
                      "统计 ChatEvent",
                    ),
                    subtitle: Wrap(
                      children: [
                        FractionallySizedBox(
                          child: Text(
                            "Res: ${widget.designData.chatEventUIPackers.where((element) => element.chatEvent.testIsRes).length}",
                          ),
                          widthFactor: 0.5,
                        ),
                        FractionallySizedBox(
                          child: Text(
                            "SubRes: ${widget.designData.chatEventUIPackers.where((element) => element.chatEvent.testIsSubRes).length}",
                          ),
                          widthFactor: 0.5,
                        ),
                        FractionallySizedBox(
                          child: Text(
                            "Timer: ${widget.designData.chatEventUIPackers.where((element) => element.chatEvent.testIsTimer).length}",
                          ),
                          widthFactor: 0.5,
                        ),
                        FractionallySizedBox(
                          child: Text(
                            "Count: ${widget.designData.chatEventUIPackers.length}",
                          ),
                          widthFactor: 0.5,
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.data_usage,
                      color: Colors.blue,
                    ),
                    title: const Text(
                      "统计 Message",
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Count: ${widget.designData.chatLogic.msgs?.length ?? 0}",
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    dense: true,
                    title: ElevatedButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 6, vertical: 10)),
                      ),
                      onPressed: testButtonUsable() ? saveToFile : null,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.save_rounded,
                              size: 24,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "保存",
                              style: h5TextStyle.copyWith(color: testButtonUsable() ? Colors.white : Colors.black54),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.only(bottom: 4, top: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        dense: true,
        minVerticalPadding: 2,
        horizontalTitleGap: 0,
      ),
    );
  }
}

class ReadDesignDialog extends StatefulWidget {
  final DesignState designState;

  const ReadDesignDialog({Key? key, required this.designState}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ReadDesignDialogState();
  }

  static String createDefaultFileName() {
    final dateTimeNow = DateTime.now();
    return "${dateTimeNow.year}_${dateTimeNow.month}_${dateTimeNow.day}_${dateTimeNow.hour}_${dateTimeNow.minute}_${dateTimeNow.second}";
  }
}

class _ReadDesignDialogState extends State<ReadDesignDialog> {
  /// proxy to designData attr
  set saveDirPath(v) {
    widget.designState.data.saveDirPath = v;
  }

  String? get saveDirPath {
    return widget.designState.data.saveDirPath;
  }

  set createFileName(v) {
    widget.designState.data.createFileName = v;
  }

  String? get createFileName {
    return widget.designState.data.createFileName!;
  }

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      child: IconTheme(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Material(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.insert_drive_file,
                      color: Colors.blue,
                    ),
                    title: const Text(
                      "加载新Design文件",
                      style: h4TextStyle,
                    ),
                    onTap: () {
                      final filepicker = OpenFilePicker()
                        ..filterSpecification = {"JSON File": "*.json", "ALL File": "*.*"}
                        ..title = "载入新的Design文件";
                      final file = filepicker.getFile();
                      if(file!=null){
                        print("load file ${file.path}");
                        final fileContent=file.readAsStringSync();
                        print(fileContent);
                        ChatLogic.fromJson(jsonDecode(fileContent));
                        print(ChatLogic);
                      }else{
                        print("no file");
                      }
                      // print(file.path);
                    },
                  )
                ],
              ),
            ),
            color: Colors.transparent,
          ),
          height: 200,
          width: 400,
        ),
        data: const IconThemeData(
          color: Colors.blue,
        ),
      ),
    );
  }
}

Future<void> showSaveDesignDialog(BuildContext context, DesignData designData) async {
  showDialog(
    context: context,
    barrierColor: Colors.black12,
    builder: (bc) {
      return Center(
        child: SaveDesignDialog(
          designData: designData,
        ),
      );
    },
  );
}

Future<void> showReadDesignDialog(BuildContext context, DesignState designState) async {
  showDialog(
    context: context,
    barrierColor: Colors.black12,
    builder: (bc) {
      return Center(
        child: ReadDesignDialog(
          designState: designState,
        ),
      );
    },
  );
}
