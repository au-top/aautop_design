extension ListGroup<E> on List<E>{
  List<List<E>> subgroup(int groupLength){
    final  result=<List<E>>[];
    List<E> _group=[];
    int _index=0;
    for (var value in this) {
      _group.add(value);
      _index++;
      if((_index%groupLength)==0){
        result.add(_group);
        _group=[];
      }
    }
    return result;
  }
}