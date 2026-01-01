import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:portfolio/controller/Projects_Controller.dart';
import 'package:portfolio/util/config/App_Constants.dart';
import 'package:portfolio/util/route/App_Routes.dart';
import '../common/Portfoil_Footer.dart';
import '../common/Portfolio_Navigation_Bar.dart' as nav;
import 'Projects_Filter_Section.dart';
import 'Projects_Grid_Section.dart';
import 'Projects_Header.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  late ProjectsController _controller;
  int _currentNavIndex = 2; // Projects 페이지는 인덱스 2
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = Get.put(ProjectsController());

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
      // 디버그 모드일 때만 FAB 표시
      floatingActionButton: kDebugMode ? _AddProjectFAB() : null,
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
                  child: ProjectsHeader(),
                ),

                // 필터 섹션
                const SliverToBoxAdapter(
                  child: ProjectsFilterSection(),
                ),

                // 프로젝트 그리드 섹션
                const SliverToBoxAdapter(
                  child: ProjectsGridSection(),
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

/// 프로젝트 추가 FAB (디버그 모드 전용)
class _AddProjectFAB extends StatelessWidget {
  const _AddProjectFAB();

  void _showAddProjectDialog(BuildContext context) {
    // TODO: 프로젝트 추가/수정 다이얼로그 표시
    showDialog(
      context: context,
      builder: (context) => _ProjectFormDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);

    return FloatingActionButton.extended(
      onPressed: () => _showAddProjectDialog(context),
      backgroundColor: theme.colorScheme.primary,
      icon: Icon(
        LucideIcons.plus,
        color: theme.colorScheme.onPrimary,
      ),
      label: Text(
        '프로젝트 추가',
        style: TextStyle(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// 프로젝트 추가/수정 다이얼로그
class _ProjectFormDialog extends StatelessWidget {
  const _ProjectFormDialog();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);

    return AlertDialog(
      title: Row(
        children: [
          Icon(
            LucideIcons.folderPlus,
            color: theme.colorScheme.primary,
          ),
          SizedBox(width: constants.spacingS),
          Text('프로젝트 추가'),
        ],
      ),
      content: SizedBox(
        width: constants.dialogMaxWidth(context),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Firebase Console에서 직접 프로젝트를 추가하세요',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              SizedBox(height: constants.spacingL),
              _InfoRow(
                icon: LucideIcons.database,
                label: 'Collection',
                value: 'projects',
              ),
              SizedBox(height: constants.spacingM),
              Text(
                '필수 필드:',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: constants.spacingS),
              _FieldInfo(field: 'title', type: 'string', description: '프로젝트 제목'),
              _FieldInfo(
                  field: 'description',
                  type: 'string',
                  description: '프로젝트 설명'),
              _FieldInfo(
                  field: 'skills',
                  type: 'array',
                  description: '사용 기술 (예: ["Flutter", "Node"])'),
              _FieldInfo(
                  field: 'thumbnail',
                  type: 'string',
                  description: '썸네일 이미지 URL'),
              _FieldInfo(
                  field: 'notion', type: 'string', description: 'Notion 페이지 URL'),
              _FieldInfo(
                  field: 'startAt', type: 'timestamp', description: '시작 날짜'),
              _FieldInfo(field: 'endAt', type: 'timestamp', description: '종료 날짜'),
              _FieldInfo(
                  field: 'volume',
                  type: 'string',
                  description:
                  '프로젝트 타입 (personal/team/company)'),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('닫기'),
        ),
      ],
    );
  }
}

/// 정보 행
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);

    return Container(
      padding: EdgeInsets.all(constants.spacingM),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(constants.borderRadius(context)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          SizedBox(width: constants.spacingS),
          Text(
            '$label: ',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 필드 정보
class _FieldInfo extends StatelessWidget {
  final String field;
  final String type;
  final String description;

  const _FieldInfo({
    required this.field,
    required this.type,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: constants.spacingS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: constants.spacingS,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius:
              BorderRadius.circular(constants.pillBorderRadius(context)),
            ),
            child: Text(
              type,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
            ),
          ),
          SizedBox(width: constants.spacingS),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: theme.textTheme.bodySmall,
                children: [
                  TextSpan(
                    text: '$field: ',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text: description,
                    style: TextStyle(
                      color:
                      theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}