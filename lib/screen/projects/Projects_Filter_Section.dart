import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:portfolio/controller/App_Controller.dart';
import 'package:portfolio/controller/Projects_Controller.dart';
import 'package:portfolio/model/Project.dart';
import 'package:portfolio/util/config/App_Constants.dart';

class ProjectsFilterSection extends StatelessWidget {
  const ProjectsFilterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: constants.horizontalPadding(context),
        vertical: constants.spacingL,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: _FilterButtons(),
    );
  }
}

/// 필터 버튼들
class _FilterButtons extends StatelessWidget {
  const _FilterButtons();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProjectsController>();
    final constants = AppConstants.of(context);

    return Obx(() {
      return Wrap(
        spacing: constants.spacingM,
        runSpacing: constants.spacingM,
        alignment: WrapAlignment.center,
        children: [
          // 전체 버튼
          _FilterButton(
            label: '전체',
            icon: LucideIcons.layoutGrid,
            isSelected: controller.selectedFilter.value == null,
            count: controller.projects?.length ?? 0,
            onTap: () => controller.changeFilter(null),
          ),

          // 개인 프로젝트 버튼
          _FilterButton(
            label: '개인',
            icon: LucideIcons.user,
            isSelected: controller.selectedFilter.value == ProjectVolume.personal,
            count: controller.projects
                ?.where((p) => p.volume == ProjectVolume.personal)
                .length ??
                0,
            onTap: () => controller.changeFilter(ProjectVolume.personal),
          ),

          // 팀 프로젝트 버튼
          _FilterButton(
            label: '팀',
            icon: LucideIcons.users,
            isSelected: controller.selectedFilter.value == ProjectVolume.team,
            count: controller.projects
                ?.where((p) => p.volume == ProjectVolume.team)
                .length ??
                0,
            onTap: () => controller.changeFilter(ProjectVolume.team),
          ),

          // 사내 프로젝트 버튼
          _FilterButton(
            label: '사내',
            icon: LucideIcons.building,
            isSelected: controller.selectedFilter.value == ProjectVolume.company,
            count: controller.projects
                ?.where((p) => p.volume == ProjectVolume.company)
                .length ??
                0,
            onTap: () => controller.changeFilter(ProjectVolume.company),
          ),
        ],
      );
    });
  }
}

/// 필터 버튼
class _FilterButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final int count;
  final VoidCallback onTap;

  const _FilterButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.count,
    required this.onTap,
  });

  @override
  State<_FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<_FilterButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: constants.fastAnimation,
          padding: EdgeInsets.symmetric(
            horizontal: constants.spacingL,
            vertical: constants.spacingM,
          ),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? theme.colorScheme.primaryContainer
                : _isHovered
                ? theme.colorScheme.surfaceVariant
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(
              constants.pillBorderRadius(context),
            ),
            border: Border.all(
              color: widget.isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline.withValues(alpha: 0.3),
              width: widget.isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.isSelected
                    ? theme.colorScheme.primary.withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.05),
                blurRadius: widget.isSelected ? 12 : 6,
                offset: Offset(0, widget.isSelected ? 4 : 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 아이콘
              Icon(
                widget.icon,
                size: 18.r,
                color: widget.isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
              ),

              SizedBox(width: constants.spacingS),

              // 라벨
              Text(
                widget.label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight:
                  widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: widget.isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                ),
              ),

              SizedBox(width: constants.spacingS),

              // 카운트 배지
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: constants.spacingS,
                  vertical: 2.h,
                ),
                decoration: BoxDecoration(
                  color: widget.isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(
                    constants.pillBorderRadius(context),
                  ),
                ),
                child: Text(
                  '${widget.count}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 11.sp,
                    color: widget.isSelected
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}