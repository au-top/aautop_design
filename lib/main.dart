
import 'dart:io';

import 'package:aautop_designer/page/about.dart';
import 'package:aautop_designer/page/design.dart';
import 'package:aautop_designer/service/app_info_service.dart';
import 'package:aautop_designer/service/service_inherited.dart';
import 'package:aautop_designer/service/window_titlebar_service.dart';
import 'package:aautop_designer/style/style.dart';
import 'package:aautop_designer/widget/windows_icon.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(Frame());
  if (Platform.isMacOS || Platform.isLinux || Platform.isWindows) {
    doWhenWindowReady(() {
      final win = appWindow;
      const initialSize = Size(1000, 550);
      win.minSize = initialSize;
      win.size = initialSize;
      win.alignment = Alignment.center;
      win.title = "AAutopDesigner";
      win.show();
    });
  }
}

class Frame extends StatelessWidget {
  final globalWindowTitlebarServiceKey = GlobalKey();
  final globalAppInfoServiceKey = GlobalKey();

  Frame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final contentNav = Navigator(
      initialRoute: "/",
      onGenerateRoute: (RouteSettings routeSetting) {
        WidgetBuilder? builder;
        switch (routeSetting.name) {
          case "/":
            {
              builder = (BuildContext bc) => const AppFrame();
            }
            break;
        }
        return MaterialPageRoute(builder: builder!, settings: routeSetting);
      },
    );

    return Builder(
      builder: (bc) {
        return ServiceManage(
          buildContext: bc,
          setWindowTitlebarService: globalWindowTitlebarServiceKey,
          setAppInfoService: globalAppInfoServiceKey,
          child: MaterialApp(
            theme: buildRootThemeData(context),
            debugShowCheckedModeBanner: false,
            home: Material(
              color: Colors.white,
              // borderRadius: BorderRadius.circular(15),
              // clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Column(
                children: [
                  // setup app Info Service Widget
                  Builder(
                    builder: (bc) => AppInfo(key: ServiceManage.of(bc).appInfoService),
                  ),
                  // setup window title system bar Service Widget
                  buildWindowToolbar(),
                  //content body
                  Expanded(
                    child: contentNav,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Builder buildWindowToolbar() {
    return Builder(
      builder: (bc) => Container(
        color: Colors.white,
        height: 26,
        child: Row(
          children: [
            Expanded(
              child: MoveWindow(
                child: Container(
                  padding: const EdgeInsets.only(left: 5, top: 6),
                  child: Row(
                    children: [
                      GestureDetector(
                        child: Hero(
                          tag: "windowsIcon",
                          child: Tooltip(
                            child: windowsIcon(),
                            message: "关于",
                          ),
                        ),
                        onPanDown: (d) {
                          Navigator.of(bc).push(
                            MaterialPageRoute(
                              builder: (bc) => buildAbout(bc),
                            ),
                          );
                        },
                      ),
                      Expanded(
                        child: WindowTitlebar(
                          key: ServiceManage.of(bc).windowTitlebarService,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            MoveWindow(
              child: _WindowButtons(),
            ),
          ],
        ),
      ),
    );
  }
}

class AppFrame extends StatefulWidget {
  const AppFrame({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AppFrameState();
  }
}

class AppFrameState extends State<AppFrame> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Design(),
    );
  }
}

final buttonColors = WindowButtonColors(
  iconNormal: const Color(0xFF000000),
  mouseOver: const Color(0x9CD9D9D9),
  mouseDown: const Color(0xE9106FB4),
  iconMouseOver: Colors.black,
  iconMouseDown: Colors.white,
);

final closeButtonColors = WindowButtonColors(
  mouseOver: const Color(0xFFD32F2F),
  mouseDown: const Color(0xFFB71C1C),
  iconNormal: const Color(0xFF000000),
  iconMouseOver: Colors.white,
);


/// windows min , max , close button
class _WindowButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(
          colors: buttonColors,
          animate: true,
        ),
        MaximizeWindowButton(colors: buttonColors, animate: true),
        CloseWindowButton(colors: closeButtonColors, animate: true),
      ],
    );
  }
}
