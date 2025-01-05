import 'dart:developer';

extension EnumTransformation <T extends Enum> on Iterable<T> {
  T?  tryTransformation(String? json){
    T? result;
    try{
      if(json != null) {
        result = byName(json);
      }
    }catch (_){
      log("cant parse ENUM $T");
    }
    return result;
  }
}