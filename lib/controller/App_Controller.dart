import 'package:get/get.dart';
import 'package:portfolio/main.dart';

enum DeviceType{
  mobile, tablet, web, unknown
}

class AppController extends GetxController{
  Rx<DeviceType> device = (DeviceType.unknown).obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  _initializedAppController(){
    InitStep('디바이스 확인 리스너 달기',);
  }

  _checkDevice(){

  }
}