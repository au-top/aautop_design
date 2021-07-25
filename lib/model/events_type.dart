enum EventsType{
  res,
  timer,
  subres,
}
extension toEventsType on EventsType{
  String toEnumString(){
    switch(this){
      case EventsType.res:
        return "res";
      case EventsType.timer:
        return "timer";
      case EventsType.subres:
        return "subres";
    }
  }
}