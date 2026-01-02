import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:portfolio/model/Contact.dart';

class ContactForm{
  final IconData icon;
  final String title;
  final String value;
  final String description;
  final Color color;
  final bool canCopy;
  final VoidCallback onTap;

  ContactForm({
    required this.icon,
    required this.title,
    required this.value,
    required this.description,
    required this.color,
    required this.canCopy,
    required this.onTap
  });

  static Color toColor(String title){
    switch(title){
      case 'Email' : return
    }
  }
}

class ContactController extends GetxController{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    // TODO: implement onInit
    fetchContact();
    super.onInit();
  }

  RxBool fetching = false.obs;
  Contact? contact;

  static final List<Map<String, dynamic>> _contactData = [
    {
      'icon': LucideIcons.mail,
      'title': 'Email',
      'value': 'iconoding.dev@gmail.com',
      'description': '이메일로 문의하기',
      'color': (BuildContext context) => Theme.of(context).colorScheme.primary,
      'canCopy': true,
      'onTap': () async {
        final uri = Uri.parse('mailto:iconoding.dev@gmail.com');
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }
      },
    },
    {
      'icon': LucideIcons.github,
      'title': 'GitHub',
      'value': 'github.com/choe-inho',
      'description': '프로젝트 코드 보기',
      'color': (BuildContext context) => Theme.of(context).colorScheme.secondary,
      'canCopy': false,
      'onTap': () async {
        final uri = Uri.parse('https://github.com/choe-inho');
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
    },
    {
      'icon': LucideIcons.externalLink,
      'title': 'Blog',
      'value': 'iconoding.tistory.com',
      'description': '기술 블로그 방문하기',
      'color': (BuildContext context) => Theme.of(context).colorScheme.tertiary,
      'canCopy': false,
      'onTap': () async {
        final uri = Uri.parse('https://iconoding.tistory.com/');
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
    },
    {
      'icon': LucideIcons.phone,
      'title': 'Phone',
      'value': '010-1234-5678',
      'description': '전화 문의하기',
      'color': (BuildContext context) => Theme.of(context).colorScheme.success,
      'canCopy': true,
      'onTap': () async {
        final uri = Uri.parse('tel:010-1234-5678');
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }
      },
    },
    {
      'icon': LucideIcons.linkedin,
      'title': 'LinkedIn',
      'value': 'linkedin.com/in/yourprofile',
      'description': '프로페셔널 네트워크',
      'color': (BuildContext context) => const Color(0xFF0A66C2),
      'canCopy': false,
      'onTap': () async {
        final uri = Uri.parse('https://linkedin.com/in/yourprofile');
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
    },
    {
      'icon': LucideIcons.mapPin,
      'title': 'Location',
      'value': '서울, 대한민국',
      'description': '현재 위치',
      'color': (BuildContext context) => Theme.of(context).colorScheme.error,
      'canCopy': false,
      'onTap': () async {
        // 위치 관련 동작 (예: 구글 맵 열기)
      },
    },
  ];
  Future<void> fetchContact() async{
    try{
      final res = await _firestore.collection('contact').doc('MfbG8A8QTzkVCx8qSz92').get();
      final data = res.data();
      if(data == null){
        throw Exception('불러온 데이터 없음');
      }else{
        contact = Contact.fromJson(data);
        update();
      }
    }catch(err){
      debugPrint('[Contact Controller] 데이터 불러오기 실패:$err');
    }finally{
      fetching.value = true;
    }
  }
}