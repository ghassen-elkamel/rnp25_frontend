class IdObject {
  int? id;
  Map<String, dynamic>? object;

  IdObject(dynamic item){

    if(item is int){
      id = item;
    }else{
      if(item is Map){
        if(item.containsKey("id")){
          id = item["id"];
        }
        object = item.cast<String, dynamic>();
      }
    }
  }
}
