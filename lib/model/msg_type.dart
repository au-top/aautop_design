enum MsgType{
  text,
  image,
  onText,
  onImage
}
extension ToEventsType on MsgType{
  String toEnumString(){
    switch(this){
      case MsgType.text:
        return "text";
      case MsgType.image:
        return "image";
      case MsgType.onText:
        return "onText";
      case MsgType.onImage:
        return "onImage";
    }
  }
}