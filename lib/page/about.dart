import 'dart:async';

import 'package:aautop_designer/service/app_info_service.dart';
import 'package:aautop_designer/service/service_inherited.dart';
import 'package:aautop_designer/style/style.dart';
import 'package:aautop_designer/widget/windows_icon.dart';
import 'package:flutter/material.dart';

Widget buildAbout(BuildContext context) {
  double sizeCon = 0;
  const setSize = 400.0;
  final appInfoService = ServiceManage.fromGlobalKeyGetService<AppInfoService>(ServiceManage.of(context).appInfoService);
  return Scaffold(
    body: Stack(
      children: [
        GestureDetector(
          onPanDown: (d) {
            Navigator.pop(context);
          },
        ),
        Center(
          child: StatefulBuilder(builder: (bc, ns) {
            Timer(const Duration(milliseconds: 500), () {
              if (sizeCon != setSize) {
                ns(() => sizeCon = setSize);
              }
            });
            return FittedBox(
              fit: BoxFit.scaleDown,
              child: Container(
                height: 300,
                alignment: Alignment.topLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      child: Hero(
                        child: windowsIcon(),
                        tag: "windowsIcon",
                      ),
                      width: 300,
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    AnimatedContainer(
                      margin: const EdgeInsets.symmetric(vertical: 50),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                        // boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black.withOpacity(0.05), offset: const Offset(2, 2))],
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                      width: sizeCon,
                      height: double.infinity,
                      duration: const Duration(milliseconds: 240),
                      clipBehavior: Clip.antiAlias,
                      child: OverflowBox(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(children: [
                                  const TextSpan(text: "应用程序:"),
                                  const WidgetSpan(child: SizedBox(width: 12)),
                                  TextSpan(
                                    text: appInfoService.appName,
                                  )
                                ]),
                              ),
                              Text.rich(
                                TextSpan(children: [
                                  const TextSpan(text: "版本号:"),
                                  const WidgetSpan(child: SizedBox(width: 12)),
                                  TextSpan(
                                    text: appInfoService.appVersion,
                                  ),
                                ]),
                              ),
                              Text.rich(
                                TextSpan(children: [
                                  const TextSpan(text: "开发者:"),
                                  const WidgetSpan(child: SizedBox(width: 12)),
                                  TextSpan(
                                    text: appInfoService.developer,
                                  ),
                                ]),
                              ),
                              Text.rich(
                                TextSpan(children: [
                                  const TextSpan(text: "版权信息:"),
                                  const WidgetSpan(child: SizedBox(width: 12)),
                                  WidgetSpan(
                                    child: GestureDetector(
                                      child: const Text(
                                        "点击这里",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                      onTap: () {
                                        showLicensePage(
                                          context: context,
                                          applicationIcon: windowsIcon(),
                                          applicationName: appInfoService.appName,
                                          applicationVersion: appInfoService.appVersion,
                                        );
                                      },
                                    ),
                                  )
                                ]),
                              ),
                              Text.rich(
                                TextSpan(children: [
                                  const TextSpan(text: "其他贡献者:"),
                                  const WidgetSpan(child: SizedBox(width: 12)),
                                  TextSpan(
                                    text: appInfoService.otherContributors,
                                  ),
                                ]),
                              ),
                            ]
                                .map(
                                  (e) => Padding(
                                child: e,
                                padding: const EdgeInsets.symmetric(vertical: 5),
                              ),
                            )
                                .toList(),
                          ),
                        ),
                        maxWidth: setSize,
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
        )
      ],
    ),
  );
}
