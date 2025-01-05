import 'package:get/get.dart';

safeBack<T>({T? result}){
  if(Get.previousRoute.isEmpty){
    Get.offAllNamed(Get.currentRoute.split("/")[1]);
  }else{
    Get.back(result: result);
  }
}

