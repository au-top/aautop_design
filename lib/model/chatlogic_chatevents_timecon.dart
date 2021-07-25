import 'dart:convert';


class ChatLogicChatEventsTimeCon {
    ChatLogicChatEventsTimeCon({ required this.max,
 required this.min,
  });
    late String? max;
    late String? min;
    
    ChatLogicChatEventsTimeCon.fromJson(Map<String,dynamic> jsondata) {
      
this.max= jsondata["max"] ;
this.min= jsondata["min"] ;
;
      
    }
    String toJson() {
      final jsonMapElem=new Map();jsonMapElem["max"]=this.max;
jsonMapElem["min"]=this.min;
return jsonEncode(jsonMapElem);;
    }
    
}