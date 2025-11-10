import 'package:flutter/material.dart';
import 'package:portfolio/util/config/App_Constants.dart';
import '../common/Portfoil_Footer.dart';
import '../common/Portfolio_Navigation_Bar.dart' as nav;
import '../common/Quick_Navigation_Cards.dart';
import 'Hero_Section.dart';

class HeroPage extends StatefulWidget {
  const HeroPage({super.key});

  @override
  State<HeroPage> createState() => _HeroPageState();
}

class _HeroPageState extends State<HeroPage> {
  int _currentNavIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleNavigationItemSelected(int index) {
    setState(() {
      _currentNavIndex = index;
    });

    // TODO: 각 섹션으로 스크롤 또는 페이지 이동
    debugPrint('Navigation item selected: $index');
  }

  void _handleViewProjects() {
    // TODO: Projects 섹션으로 이동
    _handleNavigationItemSelected(3);
  }

  void _handleContact() {
    // TODO: Contact 섹션으로 이동
    _handleNavigationItemSelected(4);
  }

  @override
  Widget build(BuildContext context) {
    final constants = AppConstants.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      // Drawer 추가
      endDrawer: nav.NavigationDrawer(
        currentIndex: _currentNavIndex,
        onItemSelected: _handleNavigationItemSelected,
      ),
      body: Column(
        children: [
          // 네비게이션 바 (고정)
          nav.PortfolioNavigationBar(
            currentIndex: _currentNavIndex,
            onItemSelected: _handleNavigationItemSelected,
          ),

          // 스크롤 가능한 콘텐츠
          Expanded(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Hero Section
                SliverToBoxAdapter(
                  child: HeroSection(
                    onViewProjects: _handleViewProjects,
                    onContact: _handleContact,
                  ),
                ),

                // Quick Navigation Cards
                SliverToBoxAdapter(
                  child: QuickNavigationCards(
                    onCardTap: _handleNavigationItemSelected,
                  ),
                ),

                // 하단 여백
                SliverToBoxAdapter(
                  child: SizedBox(height: constants.spacingXL),
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