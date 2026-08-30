import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/motion/motion.dart';
import '../../core/responsive/responsive.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/project.dart';
import '../../providers/admin_providers.dart';
import '../../providers/projects_providers.dart';
import '../../router/app_routes.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/loading_state.dart';
import '../../widgets/page_scaffold.dart';
import '../../widgets/pill_button.dart';
import '../admin/admin_login_dialog.dart';
import '../admin/project_form_dialog.dart';

class ProjectsPage extends ConsumerWidget {
  const ProjectsPage({super.key});

  Future<void> _handleAdminAction(BuildContext context, WidgetRef ref) async {
    final isAdmin = await ref.read(isAdminProvider.future);
    if (!context.mounted) return;
    if (!isAdmin) {
      final loggedIn = await showAdminLoginDialog(context);
      if (loggedIn != true) return;
    }
    if (context.mounted) await showProjectFormDialog(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(filteredProjectsProvider);
    final isAdminAsync = ref.watch(isAdminProvider);
    final isAdmin = isAdminAsync.value ?? false;

    return PageScaffold(
      currentPath: AppRoutes.projects,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.horizontalPadding,
            vertical: context.sectionPaddingVertical,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: context.maxContentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const FadeSlideIn(
                            child: EyebrowTag(text: 'Projects'),
                          ),
                          const SizedBox(height: 16),
                          FadeSlideIn(
                            delay: const Duration(milliseconds: 80),
                            child: Text(
                              '진행한 프로젝트들',
                              style: AppTextStyles.headline.copyWith(
                                fontSize: context.responsive(
                                  mobile: 30,
                                  desktop: 44,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    PillButton(
                      label: isAdmin ? '프로젝트 추가' : '관리자',
                      icon: isAdmin
                          ? FontAwesomeIcons.plus
                          : FontAwesomeIcons.shieldHalved,
                      filled: false,
                      onTap: () => _handleAdminAction(context, ref),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                const _FilterChips(),
                const SizedBox(height: 36),
                projectsAsync.when(
                  loading: () =>
                      const SizedBox(height: 300, child: LoadingState()),
                  error: (e, _) => const SizedBox(
                    height: 300,
                    child: ErrorState(message: '프로젝트를 불러올 수 없습니다'),
                  ),
                  data: (projects) {
                    if (projects.isEmpty) {
                      return const SizedBox(
                        height: 200,
                        child: Center(
                          child: Text(
                            '등록된 프로젝트가 없습니다',
                            style: AppTextStyles.body,
                          ),
                        ),
                      );
                    }
                    return _ProjectsGrid(projects: projects, isAdmin: isAdmin);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterChips extends ConsumerWidget {
  const _FilterChips();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(projectsFilterProvider);

    Widget chip(String label, ProjectVolume? value) {
      final active = selected == value;
      return Padding(
        padding: const EdgeInsets.only(right: 10),
        child: GestureDetector(
          onTap: () => ref.read(projectsFilterProvider.notifier).set(value),
          child: AnimatedContainer(
            duration: AppMotion.fast,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: active ? AppColors.textPrimary : AppColors.glassFill,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: active ? AppColors.textPrimary : AppColors.glassBorder,
              ),
            ),
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: active ? Colors.black : AppColors.textSecondary,
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ),
      );
    }

    return Wrap(
      children: [
        chip('전체', null),
        chip('개인', ProjectVolume.personal),
        chip('팀', ProjectVolume.team),
        chip('사내', ProjectVolume.company),
      ],
    );
  }
}

class _ProjectsGrid extends StatelessWidget {
  const _ProjectsGrid({required this.projects, required this.isAdmin});

  final List<Project> projects;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    final columns = context.bentoColumns;
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: [
        for (var i = 0; i < projects.length; i++)
          SizedBox(
            width: (context.maxContentWidth - (columns - 1) * 20) / columns,
            child: FadeSlideIn(
              delay: Duration(milliseconds: 60 * i),
              child: _ProjectCard(project: projects[i], isAdmin: isAdmin),
            ),
          ),
      ],
    );
  }
}

class _ProjectCard extends ConsumerWidget {
  const _ProjectCard({required this.project, required this.isAdmin});

  final Project project;
  final bool isAdmin;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('프로젝트 삭제'),
        content: Text('"${project.title}"을(를) 삭제할까요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(projectsProvider.notifier).deleteProject(project.id!);
    }
  }

  Future<void> _openNotion(BuildContext context) async {
    final uri = Uri.tryParse(project.notion);
    if (uri == null || !await canLaunchUrl(uri)) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('링크를 열 수 없습니다')));
      }
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = DateFormat('yyyy.MM');
    return Stack(
      children: [
        TiltCard(
          maxTiltDegrees: 6,
          child: GlassCard(
          padding: EdgeInsets.zero,
          onTap: () => _openNotion(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(26),
                ),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CachedNetworkImage(
                    imageUrl: project.thumbnail,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.surfaceElevated,
                      alignment: Alignment.center,
                      child: const FaIcon(
                        FontAwesomeIcons.image,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            project.title,
                            style: AppTextStyles.title.copyWith(fontSize: 19),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: project.volume.color.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            project.volume.label,
                            style: AppTextStyles.eyebrow.copyWith(
                              color: project.volume.color,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      project.description,
                      style: AppTextStyles.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final skill in project.skills)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.glassFill,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(color: AppColors.glassBorder),
                            ),
                            child: Text(
                              skill,
                              style: AppTextStyles.bodySmall.copyWith(
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      '${dateFormat.format(project.startAt)} - ${dateFormat.format(project.endAt)}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          ),
        ),
        if (isAdmin)
          Positioned(
            top: 12,
            right: 12,
            child: Row(
              children: [
                _AdminIconButton(
                  icon: FontAwesomeIcons.pencil,
                  onTap: () => showProjectFormDialog(context, project: project),
                ),
                const SizedBox(width: 8),
                _AdminIconButton(
                  icon: FontAwesomeIcons.trash,
                  onTap: () => _delete(context, ref),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _AdminIconButton extends StatelessWidget {
  const _AdminIconButton({required this.icon, required this.onTap});

  final FaIconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.55),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.glassBorderStrong),
        ),
        child: FaIcon(icon, size: 15, color: Colors.white),
      ),
    );
  }
}
