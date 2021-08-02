import 'package:flutter/cupertino.dart';

abstract class ServiceWidget<T>   {
  T getService(GlobalKey key);
}

class ServiceManage extends InheritedWidget {
  late final GlobalKey windowTitlebarService;
  late final GlobalKey appInfoService;
  ServiceManage({
    Key? key,
    required GlobalKey? setWindowTitlebarService,
    required GlobalKey? setAppInfoService,
    required BuildContext buildContext,
    required Widget child,
  }) : super(key: key, child: child){
    windowTitlebarService=setWindowTitlebarService??ServiceManage.of(buildContext).windowTitlebarService;
    appInfoService=setAppInfoService??ServiceManage.of(buildContext).appInfoService;
  }
  @override
  bool updateShouldNotify(ServiceManage oldWidget) {
    return windowTitlebarService!=oldWidget.windowTitlebarService||appInfoService!=oldWidget.appInfoService;
  }


  static T fromGlobalKeyGetService<T>(GlobalKey key){
    final serviceWidget = (key.currentWidget as ServiceWidget<T>);
    return serviceWidget.getService(key);
  }

  static ServiceManage of(BuildContext buildContext){
    return buildContext.dependOnInheritedWidgetOfExactType<ServiceManage>()!;
  }
}
