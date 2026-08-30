import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/controller/App_Controller.dart';
import 'package:portfolio/screen/hero/Hero_Page.dart';
import '../../controller/Admin_Contoller.dart';
import '../../screen/about/About_Me_Page.dart';
import '../../screen/projects/Projects_Page.dart';
import '../../screen/contact/Contact_Page.dart';
import '../../screen/contact/Contact_Admin_Page.dart';
import 'package:web/web.dart' as web;

class AppRoutes {
  // 라우트 이름 상수
  static const String home = '/';
  static const String aboutMe = '/about-me';
  static const String projects = '/projects';
  static const String contact = '/contact';
  static const String contactAdmin = '/contact-admin'; // ⭐ Contact Admin 라우트

  // GetX 라우트 설정
  static List<GetPage> routes = [
    GetPage(
      name: home,
      page: () => GetBuilder<AppController>(
        builder: (controller) {
          return const HeroPage();
        },
      ),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      middlewares: [
        TitleMiddleware('최인호 포트폴리오'),
      ]
    ),
    GetPage(
      name: aboutMe,
      page: () => const AboutMePage(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      middlewares: [
          TitleMiddleware('최인호 포트폴리오 - 소개')
      ]
    ),
    GetPage(
      name: projects,
      page: () => const ProjectsPage(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
        middlewares: [
          TitleMiddleware('최인호 포트폴리오 - 프로젝트')
        ]
    ),
    GetPage(
      name: contact,
      page: () => const ContactPage(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
        middlewares: [
          TitleMiddleware('최인호 포트폴리오 - 연락처')
        ]
    ),
    // ⭐ Contact Admin 페이지
    GetPage(
      name: contactAdmin,
      page: () => const ContactAdminPage(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      // 관리자 권한 체크 미들웨어
      middlewares: [
        AdminMiddleware(),
        TitleMiddleware('최인호 포트폴리오 - 관리자')
      ],
    ),
  ];

  // 인덱스로 라우트 이름 가져오기
  // 0: Home, 1: About Me, 2: Projects, 3: Contact
  static String getRouteByIndex(int index) {
    switch (index) {
      case 0:
        return home;
      case 1:
        return aboutMe;
      case 2:
        return projects;
      case 3:
        return contact;
      default:
        return home;
    }
  }

  // 라우트 이름으로 인덱스 가져오기
  static int getIndexByRoute(String route) {
    switch (route) {
      case home:
        return 0;
      case aboutMe:
        return 1;
      case projects:
        return 2;
      case contact:
      case contactAdmin: // Contact Admin도 Contact 인덱스로 처리
        return 3;
      default:
        return 0;
    }
  }
}

/// 관리자 권한 체크 미들웨어
class AdminMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    try {
      final adminController = Get.find<AdminController>();

      // 로그인되지 않았거나 관리자가 아니면 Contact 페이지로 리다이렉트
      if (!adminController.isLoggedIn.value || !adminController.isAdmin.value) {
        debugPrint('❌ [AdminMiddleware] 권한 없음 - Contact 페이지로 리다이렉트');

        // 권한 없음 메시지 표시
        Future.delayed(Duration.zero, () {
          Get.snackbar(
            '접근 제한',
            '관리자 권한이 필요합니다',
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 3),
          );
        });

        return const RouteSettings(name: AppRoutes.contact);
      }

      debugPrint('✅ [AdminMiddleware] 관리자 권한 확인 - 접근 허용');
      return null;
    } catch (e) {
      debugPrint('❌ [AdminMiddleware] 에러 발생: $e');
      return const RouteSettings(name: AppRoutes.home);
    }
  }

  @override
  GetPage? onPageCalled(GetPage? page) {
    debugPrint('📄 [AdminMiddleware] 페이지 호출: ${page?.name}');
    return super.onPageCalled(page);
  }

  @override
  List<Bindings>? onBindingsStart(List<Bindings>? bindings) {
    debugPrint('🔗 [AdminMiddleware] Bindings 시작');
    return super.onBindingsStart(bindings);
  }
}

//탭창 옆 타이틀 수정
class TitleMiddleware extends GetMiddleware {
  final String title;

  TitleMiddleware(this.title);

  @override
  RouteSettings? redirect(String? route) {
    web.document.title = title;
    return null;
  }
}