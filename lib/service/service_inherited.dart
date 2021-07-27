import 'package:flutter/cupertino.dart';

abstract class ServiceWidget<T>   {
  T getService(GlobalKey key);
}

class ServiceManage extends InheritedWidget {
  late final GlobalKey windowTitlebarService;
  ServiceManage({
    Key? key,
    required GlobalKey? setWindowTitlebarService,
    required BuildContext buildContext,
    required Widget child,
  }) : super(key: key, child: child){
    windowTitlebarService=setWindowTitlebarService??ServiceManage.of(buildContext).windowTitlebarService;
  }
  @override
  bool updateShouldNotify(ServiceManage oldWidget) {
    return windowTitlebarService!=oldWidget.windowTitlebarService;
  }


  static T fromGlobalKeyGetService<T>(GlobalKey key){
    final serviceWidget = (key.currentWidget as ServiceWidget<T>);
    return serviceWidget.getService(key);
  }

  static ServiceManage of(BuildContext buildContext){
    return buildContext.dependOnInheritedWidgetOfExactType<ServiceManage>()!;
  }
}
