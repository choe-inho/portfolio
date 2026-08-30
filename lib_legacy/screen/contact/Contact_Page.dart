import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:portfolio/controller/Contact_Controller.dart';
import 'package:portfolio/util/config/App_Constants.dart';
import 'package:portfolio/util/route/App_Routes.dart';
import '../../controller/Admin_Contoller.dart';
import '../common/Portfoil_Footer.dart';
import '../common/Portfolio_Navigation_Bar.dart' as nav;
import 'Contact_Header.dart';
import 'Contact_Info_Section.dart';
import 'Contact_Form_Section.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  int _currentNavIndex = 3; // Contact 페이지는 인덱스 3
  final ScrollController _scrollController = ScrollController();
  late ContactController _contactController;

  @override
  void initState() {
    super.initState();

    // ContactController 초기화 (빌드 전에 완료)
    _contactController = Get.put(ContactController());

    // 현재 라우트에 따라 네비게이션 인덱스 설정
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentRoute = Get.currentRoute;
      setState(() {
        _currentNavIndex = AppRoutes.getIndexByRoute(currentRoute);
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleNavigationItemSelected(int index) {
    setState(() {
      _currentNavIndex = index;
    });

    // GetX를 이용한 페이지 이동
    final route = AppRoutes.getRouteByIndex(index);

    // 이미 해당 페이지에 있다면 이동하지 않음
    if (Get.currentRoute != route) {
      Get.toNamed(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      endDrawer: nav.NavigationDrawer(
        currentIndex: _currentNavIndex,
        onItemSelected: _handleNavigationItemSelected,
      ),

      // ⭐ FloatingActionButton 추가 (관리자만 표시)
      floatingActionButton: _AdminFloatingButton(),

      body: Column(
        children: [
          // 네비게이션 바
          nav.PortfolioNavigationBar(
            currentIndex: _currentNavIndex,
            onItemSelected: _handleNavigationItemSelected,
          ),

          // 스크롤 가능한 콘텐츠
          Expanded(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // 헤더 섹션
                const SliverToBoxAdapter(
                  child: ContactHeader(),
                ),

                // 연락처 정보 섹션
                const SliverToBoxAdapter(
                  child: ContactInfoSection(),
                ),

                // 문의 폼 섹션
                const SliverToBoxAdapter(
                  child: ContactFormSection(),
                ),

                // 하단 여백
                SliverToBoxAdapter(
                  child: SizedBox(height: constants.spacingXXL),
                ),

                // Footer
                const SliverToBoxAdapter(
                  child: PortfolioFooter(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 관리자 전용 FloatingActionButton
class _AdminFloatingButton extends StatefulWidget {
  const _AdminFloatingButton();

  @override
  State<_AdminFloatingButton> createState() => _AdminFloatingButtonState();
}

class _AdminFloatingButtonState extends State<_AdminFloatingButton> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final adminController = Get.find<AdminController>();
    final theme = Theme.of(context);

    return Obx(() {
      // 로그인된 사용자만 버튼 표시
      if (!adminController.isLoggedIn.value) {
        return const SizedBox.shrink();
      }

      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        child: FloatingActionButton.extended(
          onPressed: () {
            // 관리자 권한 확인
            if (adminController.isAdmin.value) {
              Get.toNamed(AppRoutes.contactAdmin);
            } else {
              // 권한 없음 메시지
              Get.snackbar(
                '접근 제한',
                '관리자 권한이 필요합니다',
                snackPosition: SnackPosition.TOP,
                backgroundColor: theme.colorScheme.error,
                colorText: theme.colorScheme.onError,
                duration: const Duration(seconds: 2),
              );
            }
          },
          icon: Icon(
            adminController.isAdmin.value
                ? LucideIcons.settings
                : LucideIcons.lock,
            size: 20.r,
          ),
          label: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: Text(
              _isExpanded
                  ? (adminController.isAdmin.value ? '문의 관리' : '권한 없음')
                  : '관리',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          backgroundColor: adminController.isAdmin.value
              ? theme.colorScheme.primary
              : theme.colorScheme.secondary,
          elevation: 8,
        ),
      );
    });
  }
}