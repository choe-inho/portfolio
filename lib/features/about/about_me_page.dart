import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/motion/motion.dart';
import '../../core/responsive/responsive.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/about_me.dart';
import '../../data/models/time_line.dart';
import '../../providers/about_providers.dart';
import '../../router/app_routes.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/loading_state.dart';
import '../../widgets/page_scaffold.dart';

class AboutMePage extends ConsumerWidget {
  const AboutMePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aboutMeAsync = ref.watch(aboutMeProvider);
    final timelineAsync = ref.watch(timelineProvider);

    return PageScaffold(
      currentPath: AppRoutes.aboutMe,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.horizontalPadding,
            vertical: context.sectionPaddingVertical,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: context.maxContentWidth),
            child: aboutMeAsync.when(
              loading: () => const SizedBox(
                height: 300,
                child: LoadingState(message: '프로필을 불러오는 중...'),
              ),
              error: (e, _) => const SizedBox(
                height: 300,
                child: ErrorState(message: '프로필을 불러올 수 없습니다'),
              ),
              data: (aboutMe) {
                if (aboutMe == null) {
                  return const SizedBox(
                    height: 300,
                    child: ErrorState(message: '등록된 프로필이 없습니다'),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const FadeSlideIn(child: EyebrowTag(text: 'About')),
                    const SizedBox(height: 24),
                    _ProfileHeader(aboutMe: aboutMe),
                    SizedBox(height: context.sectionPaddingVertical),
                    _StrengthSection(strengthText: aboutMe.strength),
                    SizedBox(height: context.sectionPaddingVertical),
                    timelineAsync.when(
                      loading: () => const LoadingState(),
                      error: (e, _) =>
                          const ErrorState(message: '연혁을 불러올 수 없습니다'),
                      data: (timeline) => _TimelineSection(items: timeline),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.aboutMe});

  final AboutMe aboutMe;

  @override
  Widget build(BuildContext context) {
    final age = DateTime.now().year - aboutMe.birthDay.year;

    final avatar = ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: CachedNetworkImage(
        imageUrl: aboutMe.profileImage,
        width: context.responsive(mobile: 140, desktop: 200),
        height: context.responsive(mobile: 140, desktop: 200),
        fit: BoxFit.cover,
        errorWidget: (context, url, error) => Container(
          color: AppColors.surfaceElevated,
          alignment: Alignment.center,
          child: const FaIcon(
            FontAwesomeIcons.user,
            size: 48,
            color: AppColors.textTertiary,
          ),
        ),
      ),
    );

    final info = Column(
      crossAxisAlignment: context.isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          '${aboutMe.name} · $age',
          style: AppTextStyles.headline.copyWith(
            fontSize: context.responsive(mobile: 28, desktop: 40),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          aboutMe.produce,
          textAlign: context.isMobile ? TextAlign.center : TextAlign.start,
          style: AppTextStyles.body,
        ),
      ],
    );

    if (context.isMobile) {
      return FadeSlideIn(
        delay: const Duration(milliseconds: 80),
        child: Column(children: [avatar, const SizedBox(height: 24), info]),
      );
    }

    return FadeSlideIn(
      delay: const Duration(milliseconds: 80),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          avatar,
          const SizedBox(width: 40),
          Expanded(child: info),
        ],
      ),
    );
  }
}

class _Strength {
  const _Strength(this.title, this.description);
  final String title;
  final String description;
}

class _StrengthSection extends StatelessWidget {
  const _StrengthSection({required this.strengthText});

  final String strengthText;

  static const _icons = [
    FontAwesomeIcons.peopleGroup,
    FontAwesomeIcons.bullseye,
    FontAwesomeIcons.bolt,
    FontAwesomeIcons.heart,
    FontAwesomeIcons.lightbulb,
    FontAwesomeIcons.shieldHalved,
  ];

  static const _colors = [
    AppColors.emerald,
    AppColors.blue,
    AppColors.purple,
    Color(0xFFF59E0B),
    AppColors.emerald,
    AppColors.blue,
  ];

  List<_Strength> _parse() {
    return strengthText
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .take(6)
        .map((line) {
          final parts = line.split('|');
          return _Strength(
            parts[0].trim(),
            parts.length > 1 ? parts[1].trim() : '',
          );
        })
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final strengths = _parse();
    if (strengths.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('나의 강점', style: AppTextStyles.title),
        const SizedBox(height: 20),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            for (var i = 0; i < strengths.length; i++)
              SizedBox(
                width: context.responsive(
                  mobile: context.screenWidth - context.horizontalPadding * 2,
                  tablet: (context.maxContentWidth - 16) / 2,
                  desktop: (context.maxContentWidth - 32) / 3,
                ),
                child: FadeSlideIn(
                  delay: Duration(milliseconds: 100 * i),
                  child: TiltCard(
                    maxTiltDegrees: 6,
                    child: GlassCard(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _colors[i % _colors.length].withValues(
                              alpha: 0.14,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: FaIcon(
                            _icons[i % _icons.length],
                            color: _colors[i % _colors.length],
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                strengths[i].title,
                                style: AppTextStyles.title.copyWith(
                                  fontSize: 16,
                                ),
                              ),
                              if (strengths[i].description.isNotEmpty)
                                Text(
                                  strengths[i].description,
                                  style: AppTextStyles.bodySmall,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _TimelineSection extends StatelessWidget {
  const _TimelineSection({required this.items});

  final List<TimeLine> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    final dateFormat = DateFormat('yyyy.MM');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('연혁', style: AppTextStyles.title),
        const SizedBox(height: 20),
        for (var i = 0; i < items.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: FadeSlideIn(
              delay: Duration(milliseconds: 80 * i),
              child: GlassCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: AppColors.glassFillStrong,
                        shape: BoxShape.circle,
                      ),
                      child: FaIcon(
                        items[i].iconData,
                        size: 20,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${dateFormat.format(items[i].startDate)} - ${dateFormat.format(items[i].endDate)}',
                            style: AppTextStyles.eyebrow,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            items[i].title,
                            style: AppTextStyles.title.copyWith(fontSize: 18),
                          ),
                          Text(
                            items[i].subTitle,
                            style: AppTextStyles.bodySmall,
                          ),
                          if (items[i].description.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              items[i].description,
                              style: AppTextStyles.body,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
