import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:portfolio/controller/App_Controller.dart';
import 'package:portfolio/controller/Projects_Controller.dart';
import 'package:portfolio/util/animation/Portfolio_Animation.dart';
import 'package:portfolio/util/animation/Portfolio_Indicator.dart';
import 'package:portfolio/util/config/App_Constants.dart';

import 'Projects_Card.dart';

class ProjectsGridSection extends StatelessWidget {
  const ProjectsGridSection({super.key});

  @override
  Widget build(BuildContext context) {
    final constants = AppConstants.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: constants.horizontalPadding(context),
        vertical: constants.spacingXXL,
      ),
      child: Obx(() {
        final controller = Get.find<ProjectsController>();

        // 로딩 중
        if (!controller.isDataLoaded.value) {
          return _LoadingState();
        }

        // 데이터 없음
        if (controller.filteredProjects.isEmpty) {
          return _EmptyState();
        }

        // 정상 상태 - 프로젝트 그리드
        return _ProjectsGrid(
          projects: controller.filteredProjects,
        );
      }),
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
      child: Padding(
        padding: EdgeInsets.all(constants.largePadding(context) * 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PortfolioLoadingIndicator(
              style: IndicatorStyle.codingAnimation,
              size: constants.defaultIndicatorSize(context),
            ),
            SizedBox(height: constants.spacingL),
            Text(
              '프로젝트를 불러오는 중...',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 빈 상태
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(constants.largePadding(context) * 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.inbox,
              size: 64,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            SizedBox(height: constants.spacingL),
            Text(
              '프로젝트가 없습니다',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: constants.spacingS),
            Text(
              '곧 새로운 프로젝트가 추가될 예정입니다',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 프로젝트 그리드
class _ProjectsGrid extends StatelessWidget {
  final List projects;

  const _ProjectsGrid({required this.projects});

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    final constants = AppConstants.of(context);

    return Obx(() {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: appController.responsive(
            mobile: 2,
            tablet: 2,
            web: 3,
          ),
          crossAxisSpacing: constants.spacingL,
          mainAxisSpacing: constants.spacingL,
          childAspectRatio: appController.responsive(
            mobile: 0.82,
            tablet: 1.15,
            web: 0.95,
          ),
        ),
        itemCount: projects.length,
        itemBuilder: (context, index) {
          return SlideInAnimation(
            delay: Duration(milliseconds: 300 + (index * 100)),
            child: ProjectCard(
              project: projects[index],
            ),
          );
        },
      );
    });
  }
}