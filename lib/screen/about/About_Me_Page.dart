import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/controller/About_Me_Controller.dart';
import 'package:portfolio/util/config/App_Constants.dart';
import '../../util/route/App_Routes.dart';
import '../common/Portfoil_Footer.dart';
import '../common/Portfolio_Navigation_Bar.dart' as nav;
import 'About_Me_Header.dart';
import 'About_Me_Profile_Section.dart';
import 'About_Me_Strength_Section.dart';
import 'About_Me_Timeline_Section.dart';

class AboutMePage extends StatefulWidget {
  const AboutMePage({super.key});

  @override
  State<AboutMePage> createState() => _AboutMePageState();
}

class _AboutMePageState extends State<AboutMePage> {
  late AboutMeController _controller;
  int _currentNavIndex = 1; // About Me 페이지는 인덱스 1
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // AboutMeController 초기화
    _controller = Get.put(AboutMeController());

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
      body: Column(
        children: [
          // 네비게이션 바
          nav.PortfolioNavigationBar(
            currentIndex: _currentNavIndex,
            onItemSelected: _handleNavigationItemSelected,
          ),

          // 스크롤 가능한 콘텐츠
          Expanded(
            child: Obx(() {
              // 데이터 로딩 중
              if (_controller.aboutMeFetching.value) {
                return _LoadingState();
              }

              // 데이터 로드 실패
              if (_controller.aboutMe == null) {
                return _ErrorState(
                  onRetry: () => _controller.onInit(),
                );
              }

              // 정상 화면
              return CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // 헤더 섹션
                  SliverToBoxAdapter(
                    child: AboutMeHeader(),
                  ),

                  // 프로필 섹션
                  SliverToBoxAdapter(
                    child: AboutMeProfileSection(
                      aboutMe: _controller.aboutMe!,
                    ),
                  ),

                  // 강점 섹션
                  SliverToBoxAdapter(
                    child: AboutMeStrengthSection(
                      aboutMe: _controller.aboutMe!,
                    ),
                  ),

                  // 타임라인 섹션 (경력/학력)
                  SliverToBoxAdapter(
                    child: AboutMeTimelineSection(),
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
              );
            }),
          ),
        ],
      ),
    );
  }
}

/// 로딩 상태
class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: constants.defaultIndicatorSize(context),
            height: constants.defaultIndicatorSize(context),
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(height: constants.spacingL),
          Text(
            '프로필을 불러오는 중...',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

/// 에러 상태
class _ErrorState extends StatelessWidget {
  final VoidCallback? onRetry;

  const _ErrorState({this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(constants.largePadding(context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 에러 아이콘
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 40,
                color: theme.colorScheme.error,
              ),
            ),

            SizedBox(height: constants.spacingL),

            Text(
              '프로필을 불러올 수 없습니다',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),

            SizedBox(height: constants.spacingS),

            Text(
              '잠시 후 다시 시도해주세요',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),

            SizedBox(height: constants.spacingXL),

            ElevatedButton(
              onPressed: onRetry,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }
}