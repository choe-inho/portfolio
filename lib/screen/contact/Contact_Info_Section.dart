import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:portfolio/controller/App_Controller.dart';
import 'package:portfolio/controller/Contact_Controller.dart';
import 'package:portfolio/screen/common/Loading_State.dart';
import 'package:portfolio/util/animation/Portfolio_Animation.dart';
import 'package:portfolio/util/config/App_Constants.dart';
import 'package:portfolio/util/theme/App_Colors.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactInfoSection extends StatelessWidget {
  const ContactInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final constants = AppConstants.of(context);
    final appController = Get.find<AppController>();
    final contactController = Get.find<ContactController>();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: constants.horizontalPadding(context),
        vertical: constants.spacingXXL,
      ),
      child: Obx(() {

        if(!contactController.fetching.value){
          return LoadingState(loading: '연락처 불러오는 중...');
        }

        return Column(
          children: [
            // 섹션 타이틀
            FadeInAnimation(
              delay: const Duration(milliseconds: 300),
              child: _SectionTitle(),
            ),

            SizedBox(height: constants.spacingXL),

            // 연락처 카드 그리드
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: appController.responsive(
                  mobile: 1,
                  tablet: 2,
                  web: 3,
                ),
                crossAxisSpacing: constants.spacingL,
                mainAxisSpacing: constants.spacingL,
                childAspectRatio: appController.responsive(
                  mobile: 1.8,
                  tablet: 1.3,
                  web: 1.1,
                ),
              ),
              itemCount: _contactData.length,
              itemBuilder: (context, index) {
                final data = _contactData[index];
                return SlideInAnimation(
                  delay: Duration(milliseconds: 500 + (index * 150)),
                  child: _ContactCard(
                    icon: data['icon'] as IconData,
                    title: data['title'] as String,
                    value: data['value'] as String,
                    description: data['description'] as String,
                    color: data['color'] as Color Function(BuildContext),
                    onTap: data['onTap'] as Future<void> Function(),
                    canCopy: data['canCopy'] as bool,
                  ),
                );
              },
            ),
          ],
        );
      }),
    );
  }
}

/// 섹션 타이틀
class _SectionTitle extends StatelessWidget {
  const _SectionTitle();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.messageCircle,
              size: constants.iconSize(context),
              color: theme.colorScheme.success,
            ),
            SizedBox(width: constants.spacingS),
            Text(
              '연락처 정보',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        SizedBox(height: constants.spacingS),
        Text(
          '아래 방법으로 언제든지 연락주세요',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

/// 연락처 카드
class _ContactCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String value;
  final String description;
  final Color Function(BuildContext) color;
  final Future<void> Function() onTap;
  final bool canCopy;

  const _ContactCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.description,
    required this.color,
    required this.onTap,
    required this.canCopy,
  });

  @override
  State<_ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<_ContactCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onHoverChanged(bool isHovered) {
    setState(() => _isHovered = isHovered);
    if (isHovered) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  Future<void> _copyToClipboard() async {
    if (widget.canCopy) {
      await Clipboard.setData(ClipboardData(text: widget.value));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  LucideIcons.check,
                  color: Colors.white,
                  size: 20.r,
                ),
                SizedBox(width: 8.w),
                Text('${widget.title} 복사 완료!'),
              ],
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: Theme.of(context).colorScheme.success,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);
    final cardColor = widget.color(context);

    return MouseRegion(
      onEnter: (_) => _onHoverChanged(true),
      onExit: (_) => _onHoverChanged(false),
      cursor: SystemMouseCursors.click,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: constants.fastAnimation,
            padding: EdgeInsets.all(constants.spacingL),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(
                constants.largeBorderRadius(context),
              ),
              border: Border.all(
                color: _isHovered
                    ? cardColor.withValues(alpha: 0.5)
                    : theme.colorScheme.outline.withValues(alpha: 0.2),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: _isHovered
                      ? cardColor.withValues(alpha: 0.2)
                      : Colors.black.withValues(alpha: 0.05),
                  blurRadius: _isHovered ? 20 : 10,
                  offset: Offset(0, _isHovered ? 8 : 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 아이콘
                _CardIcon(
                  icon: widget.icon,
                  color: cardColor,
                  isHovered: _isHovered,
                ),

                SizedBox(height: constants.spacingM),

                // 타이틀
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),

                SizedBox(height: constants.spacingS),

                // 값 (클릭 가능)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        widget.value,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: cardColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (widget.canCopy) ...[
                      SizedBox(width: constants.spacingS),
                      GestureDetector(
                        onTap: _copyToClipboard,
                        child: Icon(
                          LucideIcons.copy,
                          size: 16.r,
                          color: cardColor,
                        ),
                      ),
                    ],
                  ],
                ),

                SizedBox(height: constants.spacingS),

                // 설명
                Text(
                  widget.description,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),

                SizedBox(height: constants.spacingM),

                // 액션 버튼
                AnimatedRotation(
                  turns: _isHovered ? 0.125 : 0,
                  duration: constants.fastAnimation,
                  child: Icon(
                    LucideIcons.arrowRight,
                    size: constants.iconSize(context),
                    color: cardColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 카드 아이콘
class _CardIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final bool isHovered;

  const _CardIcon({
    required this.icon,
    required this.color,
    required this.isHovered,
  });

  @override
  Widget build(BuildContext context) {
    final constants = AppConstants.of(context);
    final appController = Get.find<AppController>();

    return AnimatedContainer(
      duration: constants.fastAnimation,
      width: appController.responsive(
        mobile: 64.r,
        tablet: 72.r,
        web: 80.r,
      ),
      height: appController.responsive(
        mobile: 64.r,
        tablet: 72.r,
        web: 80.r,
      ),
      decoration: BoxDecoration(
        color: isHovered ? color.withValues(alpha: 0.2) : color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          icon,
          size: appController.responsive(
            mobile: 32.r,
            tablet: 36.r,
            web: 40.r,
          ),
          color: color,
        ),
      ),
    );
  }
}