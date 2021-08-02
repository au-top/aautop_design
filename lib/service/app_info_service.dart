import 'package:aautop_designer/service/service_inherited.dart';
import 'package:aautop_designer/style/style.dart';
import 'package:aautop_designer/tool/widget/dependent.dart';
import 'package:flutter/material.dart';

class AppInfoService extends ChangeNotifier {
  final appVersion="b0.1";
  final appName="AAutopDesign";
  final developer=["autop"].join(',');
  final otherContributors=["gongziye"].join(",");
}

class AppInfo extends StatefulWidget implements ServiceWidget<AppInfoService> {
  const AppInfo({required Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AppInfoState();
  }

  @override
  AppInfoService getService(GlobalKey key) {
    return (key.currentState! as AppInfoState).appInfoService;
  }
}

class AppInfoState extends State<AppInfo> {
  AppInfoService appInfoService = AppInfoService();

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
