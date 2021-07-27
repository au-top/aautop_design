import 'package:aautop_designer/service/service_inherited.dart';
import 'package:aautop_designer/style/style.dart';
import 'package:aautop_designer/tool/widget/dependent.dart';
import 'package:flutter/material.dart';

class WindowTitlebarService extends ChangeNotifier {
  WindowTitlebarService() {
    print("new WindowTitlebarService");
  }

  final List<Widget> titlebarButtons = [];

  bool contains(Widget findWidget) {
    return titlebarButtons.contains(findWidget);
  }

  void add(Widget addWidget) {
    titlebarButtons.add(addWidget);
    notifyListeners();
  }

  void del(Widget delWidget) {
    titlebarButtons.remove(delWidget);
    notifyListeners();
  }

  void clear() {
    titlebarButtons.clear();
    notifyListeners();
  }
}

class WindowTitlebar extends StatefulWidget implements ServiceWidget<WindowTitlebarService> {
  const WindowTitlebar({required Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WindowTitlebarState();
  }

  @override
  WindowTitlebarService getService(GlobalKey key) {
    return (key.currentState! as WindowTitlebarState).windowTitlebarData;
  }
}

class WindowTitlebarState extends State<WindowTitlebar> {
  WindowTitlebarService windowTitlebarData = WindowTitlebarService();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 10,
        top: 1,
      ),
      child: DefaultTextStyle(
        child: Dependent<WindowTitlebarService>(
          builder: (bc, data) {
            print("build windows ${data.titlebarButtons.length} ${data.titlebarButtons}");
            return Row(
              children: [
                ...data.titlebarButtons,
              ],
            );
          },
          data: windowTitlebarData,
        ),
        style: h6TextStyleLowBold,
      ),
    );
  }
}
