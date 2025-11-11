import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:portfolio/model/About_Me.dart';
import 'package:portfolio/model/Time_Line.dart';


class AboutMeController extends GetxController{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxBool aboutMeFetching = false.obs;
  AboutMe? aboutMe;

  RxBool timelineFetching = false.obs;
  List<TimeLine>? timeLine;

  @override
  void onInit() {
    // TODO: implement onInit
    _initializeAboutMeController();
    _initializeTimeline();
    super.onInit();
  }

  Future<void> _initializeAboutMeController() async{
    await _initializeAboutMe();
  }

  Future<void> _initializeAboutMe() async{
    try{
      if(!aboutMeFetching.value){
        debugPrint('[AboutMe Controller] 자기소개 불러오기 시작');
        final res = await _firestore.collection('about').doc('me').get();
        final data = res.data();

        if(data != null){
          debugPrint('[AboutMe Controller] 자기소개 불러오기 완료');
          aboutMe = AboutMe.fromJson(data);
          aboutMeFetching.value = true;
        }else{
          debugPrint('[AboutMe Controller] 자기소개 불러올 내용이 없어요');
        }
      }
    }catch(e){
      debugPrint('[AboutMe Controller] 자기소개 패치 실패함: $e');
    }
  }

  Future<void> _initializeTimeline() async{
    try{
      if(!timelineFetching.value){
        final res = await _firestore.collection('timeline').get();
        final listData = res.docs;

        if(listData.isNotEmpty){
          debugPrint('[AboutMe Controller] 타임라인 불러오기 완료');
          timeLine = listData.map((e)=> TimeLine.fromJson(e.data())).toList();
          timeLine!.sort((a,b)=> a.startDate.compareTo(b.startDate));
          timelineFetching.value = true;
        }else{
          debugPrint('[AboutMe Controller] 타임라인 불러올 내용이 없어요');
        }
      }
    }catch(e){
      debugPrint('[AboutMe Controller] 타임라인 패치 실패함: $e');
    }
  }
}