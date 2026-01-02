import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:portfolio/controller/Projects_Controller.dart';
import 'package:portfolio/util/config/App_Constants.dart';
import 'package:portfolio/util/route/App_Routes.dart';
import '../../controller/Admin_Contoller.dart';
import '../admin/Admin_Login_Dialog.dart';
import '../common/Portfoil_Footer.dart';
import '../common/Portfolio_Navigation_Bar.dart' as nav;
import 'Project_Form_Dialog.dart';
import 'Projects_Filter_Section.dart';
import 'Projects_Grid_Section.dart';
import 'Projects_Header.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  late ProjectsController _projectsController;
  late AdminController _adminController;
  int _currentNavIndex = 2;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _projectsController = Get.put(ProjectsController());
    _adminController = Get.put(AdminController(), permanent: true);

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

    final route = AppRoutes.getRouteByIndex(index);
    if (Get.currentRoute != route) {
      Get.toNamed(route);
    }
  }

  /// 관리자 기능 실행 전 권한 확인
  Future<void> _executeAdminAction(VoidCallback action) async {
    if (_adminController.canUseAdminFeatures) {
      // 이미 로그인된 관리자
      action();
    } else {
      // 로그인 필요
      final loggedIn = await showDialog<bool>(
        context: context,
        builder: (context) => const AdminLoginDialog(),
      );

      if (loggedIn == true) {
        action();
      }
    }
  }

  void _showAddProjectDialog() {
    showDialog(
      context: context,
      builder: (context) => const ProjectFormDialog(),
    );
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
      // 관리자 패널 (항상 표시, 로그인 상태에 따라 다르게 작동)
      floatingActionButton: _AdminFAB(
        onPressed: () => _executeAdminAction(_showAddProjectDialog),
      ),
      body: Column(
        children: [
          // 네비게이션 바
          nav.PortfolioNavigationBar(
            currentIndex: _currentNavIndex,
            onItemSelected: _handleNavigationItemSelected,
          ),

          // 관리자 상태 표시 바 (로그인 시에만)
          Obx(() {
            if (_adminController.isLoggedIn.value) {
              return _AdminStatusBar();
            }
            return const SizedBox.shrink();
          }),

          // 스크롤 가능한 콘텐츠
          Expanded(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                const SliverToBoxAdapter(child: ProjectsHeader()),
                const SliverToBoxAdapter(child: ProjectsFilterSection()),
                const SliverToBoxAdapter(child: ProjectsGridSection()),
                SliverToBoxAdapter(
                  child: SizedBox(height: constants.spacingXXL),
                ),
                const SliverToBoxAdapter(child: PortfolioFooter()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 관리자 FAB
class _AdminFAB extends StatelessWidget {
  final VoidCallback onPressed;

  const _AdminFAB({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final adminController = Get.find<AdminController>();
    final theme = Theme.of(context);

    return Obx(() {
      final isAdmin = adminController.canUseAdminFeatures;

      return FloatingActionButton.extended(
        onPressed: onPressed,
        backgroundColor: isAdmin
            ? theme.colorScheme.primary
            : theme.colorScheme.secondary,
        icon: Icon(
          isAdmin ? LucideIcons.plus : LucideIcons.shield,
          color: theme.colorScheme.onPrimary,
        ),
        label: Text(
          isAdmin ? '프로젝트 추가' : '관리자 로그인',
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    });
  }
}

/// 관리자 상태 표시 바
class _AdminStatusBar extends StatelessWidget {
  const _AdminStatusBar();

  @override
  Widget build(BuildContext context) {
    final adminController = Get.find<AdminController>();
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: constants.horizontalPadding(context),
        vertical: constants.spacingS,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            LucideIcons.shieldCheck,
            size: 16,
            color: theme.colorScheme.primary,
          ),
          SizedBox(width: constants.spacingS),
          Text(
            '관리자 모드: ${adminController.currentUser?.email ?? "알 수 없음"}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: () => adminController.signOut(),
            icon: Icon(LucideIcons.logOut, size: 14),
            label: const Text('로그아웃'),
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
              padding: EdgeInsets.symmetric(
                horizontal: constants.spacingM,
                vertical: constants.spacingXS,
              ),
            ),
          ),
        ],
      ),
    );
  }
}