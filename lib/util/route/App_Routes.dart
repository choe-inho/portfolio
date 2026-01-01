import 'package:get/get.dart';
import 'package:portfolio/controller/App_Controller.dart';
import 'package:portfolio/screen/hero/Hero_Page.dart';
import '../../screen/about/About_Me_Page.dart';
import '../../screen/projects/Projects_Page.dart';

class AppRoutes {
  // 라우트 이름 상수
  static const String home = '/';
  static const String aboutMe = '/about-me';
  static const String projects = '/projects';
  static const String contact = '/contact';

  // GetX 라우트 설정
  static List<GetPage> routes = [
    GetPage(
      name: home,
      page: () => GetBuilder<AppController>(
          builder: (controller) {
            return const HeroPage();
          }
      ),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: aboutMe,
      page: () => const AboutMePage(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: projects,
      page: () => const ProjectsPage(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    // TODO: Contact 페이지 추가 후 주석 해제
    // GetPage(
    //   name: contact,
    //   page: () => const ContactPage(),
    //   transition: Transition.fadeIn,
    //   transitionDuration: const Duration(milliseconds: 300),
    // ),
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
        return 3;
      default:
        return 0;
    }
  }
}