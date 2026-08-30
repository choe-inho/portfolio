import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/motion/motion.dart';
import '../../core/responsive/responsive.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/contact.dart';
import '../../providers/admin_providers.dart';
import '../../providers/contact_providers.dart';
import '../../providers/repository_providers.dart';
import '../../router/app_routes.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/loading_state.dart';
import '../../widgets/page_scaffold.dart';
import '../../widgets/pill_button.dart';
import '../admin/admin_login_dialog.dart';

class ContactPage extends ConsumerWidget {
  const ContactPage({super.key});

  Future<void> _handleAdminEntry(BuildContext context, WidgetRef ref) async {
    final isAdmin = await ref.read(isAdminProvider.future);
    if (!context.mounted) return;
    if (!isAdmin) {
      final loggedIn = await showAdminLoginDialog(context);
      if (loggedIn != true) return;
    }
    if (context.mounted) context.go(AppRoutes.contactAdmin);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactAsync = ref.watch(contactInfoProvider);
    final isAdminAsync = ref.watch(isAdminProvider);
    final isAdmin = isAdminAsync.value ?? false;

    return PageScaffold(
      currentPath: AppRoutes.contact,
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
                          const FadeSlideIn(child: EyebrowTag(text: 'Contact')),
                          const SizedBox(height: 16),
                          FadeSlideIn(
                            delay: const Duration(milliseconds: 80),
                            child: Text(
                              '언제든 편하게 연락주세요',
                              style: AppTextStyles.headline.copyWith(
                                fontSize: context.responsive(
                                  mobile: 28,
                                  desktop: 42,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    PillButton(
                      label: isAdmin ? '문의함' : '관리자',
                      icon: isAdmin
                          ? FontAwesomeIcons.envelopeOpen
                          : FontAwesomeIcons.shieldHalved,
                      filled: false,
                      onTap: () => _handleAdminEntry(context, ref),
                    ),
                  ],
                ),
                SizedBox(height: context.sectionPaddingVertical * 0.5),
                contactAsync.when(
                  loading: () =>
                      const SizedBox(height: 200, child: LoadingState()),
                  error: (e, _) => const SizedBox(
                    height: 200,
                    child: ErrorState(message: '연락처 정보를 불러올 수 없습니다'),
                  ),
                  data: (contact) => _ContactInfoGrid(contact: contact),
                ),
                SizedBox(height: context.sectionPaddingVertical),
                const _MessageForm(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ContactInfoGrid extends StatelessWidget {
  const _ContactInfoGrid({required this.contact});

  final Contact? contact;

  Future<void> _launch(String url, {bool external = false}) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: external
            ? LaunchMode.externalApplication
            : LaunchMode.platformDefault,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        icon: FontAwesomeIcons.envelope,
        title: 'Email',
        value: 'iconoding.dev@gmail.com',
        color: AppColors.emerald,
        onTap: () => _launch('mailto:iconoding.dev@gmail.com'),
      ),
      (
        icon: FontAwesomeIcons.github,
        title: 'GitHub',
        value: 'github.com/choe-inho',
        color: AppColors.blue,
        onTap: () => _launch('https://github.com/choe-inho', external: true),
      ),
      (
        icon: FontAwesomeIcons.link,
        title: 'Blog',
        value: 'iconoding.tistory.com',
        color: AppColors.purple,
        onTap: () => _launch('https://iconoding.tistory.com/', external: true),
      ),
      if (contact != null) ...[
        (
          icon: FontAwesomeIcons.phone,
          title: 'Phone',
          value: contact!.phone,
          color: AppColors.emerald,
          onTap: () => _launch('tel:${contact!.phone}'),
        ),
        (
          icon: FontAwesomeIcons.instagram,
          title: 'Instagram',
          value: contact!.instagram,
          color: const Color(0xFFE4405F),
          onTap: () => _launch(
            'https://instagram.com/${contact!.instagram.replaceAll('@', '')}',
            external: true,
          ),
        ),
        (
          icon: FontAwesomeIcons.locationDot,
          title: 'Location',
          value: '${contact!.city}, ${contact!.local}',
          color: AppColors.blue,
          onTap: () => _launch(
            'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent('${contact!.city}, ${contact!.local}')}',
            external: true,
          ),
        ),
      ],
    ];

    final columns = context.bentoColumns;
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        for (var i = 0; i < items.length; i++)
          SizedBox(
            width: (context.maxContentWidth - (columns - 1) * 16) / columns,
            child: FadeSlideIn(
              delay: Duration(milliseconds: 60 * i),
              child: TiltCard(
                maxTiltDegrees: 6,
                child: GlassCard(
                onTap: items[i].onTap,
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: items[i].color.withValues(alpha: 0.14),
                        shape: BoxShape.circle,
                      ),
                      child: FaIcon(
                        items[i].icon,
                        color: items[i].color,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(items[i].title, style: AppTextStyles.eyebrow),
                          const SizedBox(height: 4),
                          Text(
                            items[i].value,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textPrimary,
                            ),
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
    );
  }
}

class _MessageForm extends ConsumerStatefulWidget {
  const _MessageForm();

  @override
  ConsumerState<_MessageForm> createState() => _MessageFormState();
}

class _MessageFormState extends ConsumerState<_MessageForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _subject = TextEditingController();
  final _message = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _subject.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _submitting = true);
    try {
      await ref
          .read(contactRepositoryProvider)
          .submitMessage(
            name: _name.text,
            email: _email.text,
            subject: _subject.text,
            message: _message.text,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('메시지가 전송되었습니다. 감사합니다!')));
      _formKey.currentState?.reset();
      _name.clear();
      _email.clear();
      _subject.clear();
      _message.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('전송에 실패했습니다. 잠시 후 다시 시도해주세요.')),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  InputDecoration _decoration(String label) =>
      InputDecoration(labelText: label);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(28),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('메시지 남기기', style: AppTextStyles.title),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _name,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    decoration: _decoration('이름'),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? '이름을 입력해주세요' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _email,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    decoration: _decoration('이메일'),
                    validator: (v) => (v == null || !v.contains('@'))
                        ? '올바른 이메일을 입력해주세요'
                        : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _subject,
              style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
              decoration: _decoration('제목'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? '제목을 입력해주세요' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _message,
              style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
              decoration: _decoration('내용'),
              maxLines: 5,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? '내용을 입력해주세요' : null,
            ),
            const SizedBox(height: 24),
            PillButton(
              label: _submitting ? '전송 중...' : '메시지 보내기',
              icon: FontAwesomeIcons.paperPlane,
              onTap: _submitting ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }
}
