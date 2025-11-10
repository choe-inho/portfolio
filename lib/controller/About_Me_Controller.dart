import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:portfolio/main.dart';
import 'package:portfolio/model/About_Me.dart';
import 'package:portfolio/model/Contact.dart';

import '../model/Skill.dart';

class AboutMeController extends GetxController{
  RxBool aboutMeFetching = false.obs;
  AboutMe? aboutMe;

  RxBool contactFetching = false.obs;
  Contact? contact;

  @override
  void onInit() {
    // TODO: implement onInit
    _initializeAboutMeController();
    super.onInit();
  }

  Future<void> _initializeAboutMeController() async{
    await _initializeAboutMe();
    await _initializeContact();
  }

  Future<void> _initializeAboutMe() async{
    try{
      if(!aboutMeFetching.value){

        aboutMeFetching.value = true;
      }
    }catch(e){
      debugPrint('[AboutMe Controller] 자기소개 패치 실패함: $e');
    }
  }

  Future<void> _initializeContact() async{
    try{
      if(!contactFetching.value){
        contactFetching.value = true;
      }
    }catch(e){
      debugPrint('[AboutMe Controller] 연락처 패치 실패함: $e');
    }
  }

}