import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/controller/App_Controller.dart';
import 'package:portfolio/util/config/App_Constants.dart';
import '../../util/route/App_Routes.dart';
import '../common/Portfoil_Footer.dart';
import '../common/Portfolio_Navigation_Bar.dart' as nav;
import 'Skills_Header.dart';
import 'Skills_Content_Section.dart';
import 'Skills_Experience_Section.dart';

class SkillsPage extends StatefulWidget {
  const SkillsPage({super.key});

  @override
  State<SkillsPage> createState() => _SkillsPageState();
}

class _SkillsPageState extends State<SkillsPage> {
  int _currentNavIndex = 2; // Skills 페이지는 인덱스 2
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
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

    final route = AppRoutes.getRouteByIndex(index);
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
                  child: SkillsHeader(),
                ),

                // 스킬 콘텐츠 섹션 (카테고리별 스킬)
                const SliverToBoxAdapter(
                  child: SkillsContentSection(),
                ),

                // 스킬 경험 섹션 (프로젝트 경험)
                const SliverToBoxAdapter(
                  child: SkillsExperienceSection(),
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