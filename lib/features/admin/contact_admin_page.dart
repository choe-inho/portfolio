import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/motion/motion.dart';
import '../../core/responsive/responsive.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/contact.dart';
import '../../data/models/legal_document.dart';
import '../../providers/contact_providers.dart';
import '../../providers/repository_providers.dart';
import '../../router/app_routes.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/loading_state.dart';
import '../../widgets/page_scaffold.dart';
import '../../widgets/pill_button.dart';
import 'legal_editor_section.dart';

class ContactAdminPage extends ConsumerWidget {
  const ContactAdminPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PageScaffold(
      currentPath: AppRoutes.contactAdmin,
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
                  children: [
                    Expanded(
                      child: FadeSlideIn(
                        child: Text(
                          '관리자',
                          style: AppTextStyles.headline.copyWith(fontSize: 32),
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        await ref.read(adminAuthRepositoryProvider).signOut();
                        if (context.mounted) context.go(AppRoutes.contact);
                      },
                      icon: const FaIcon(
                        FontAwesomeIcons.rightFromBracket,
                        size: 16,
                      ),
                      label: const Text('로그아웃'),
                    ),
                  ],
                ),
                SizedBox(height: context.sectionPaddingVertical * 0.5),
                Text('문의 내역', style: AppTextStyles.title),
                const SizedBox(height: 16),
                const _MessagesInbox(),
                SizedBox(height: context.sectionPaddingVertical * 0.6),
                Text('연락처 정보', style: AppTextStyles.title),
                const SizedBox(height: 16),
                const _ContactInfoEditor(),
                SizedBox(height: context.sectionPaddingVertical * 0.6),
                Text('법적 문서', style: AppTextStyles.title),
                const SizedBox(height: 16),
                const LegalEditorSection(
                  docId: LegalDocIds.privacy,
                  label: '개인정보처리방침',
                ),
                const SizedBox(height: 16),
                const LegalEditorSection(
                  docId: LegalDocIds.terms,
                  label: '이용약관',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MessagesInbox extends ConsumerWidget {
  const _MessagesInbox();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesAsync = ref.watch(contactMessagesProvider);
    final dateFormat = DateFormat('yyyy.MM.dd HH:mm');

    return messagesAsync.when(
      loading: () => const LoadingState(),
      error: (e, _) => const ErrorState(message: '문의 내역을 불러올 수 없습니다'),
      data: (messages) {
        if (messages.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Text('아직 문의가 없습니다', style: AppTextStyles.body),
          );
        }
        return Column(
          children: [
            for (final message in messages)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GlassCard(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(top: 6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: message.isRead
                              ? AppColors.textTertiary
                              : AppColors.emerald,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    message.subject,
                                    style: AppTextStyles.title.copyWith(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Text(
                                  dateFormat.format(message.timestamp),
                                  style: AppTextStyles.bodySmall.copyWith(
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${message.name} · ${message.email}',
                              style: AppTextStyles.bodySmall,
                            ),
                            const SizedBox(height: 8),
                            Text(message.message, style: AppTextStyles.body),
                          ],
                        ),
                      ),
                      if (!message.isRead)
                        IconButton(
                          tooltip: '읽음 처리',
                          icon: const FaIcon(FontAwesomeIcons.check, size: 16),
                          onPressed: () => ref
                              .read(contactRepositoryProvider)
                              .markAsRead(message.id),
                        ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ContactInfoEditor extends ConsumerStatefulWidget {
  const _ContactInfoEditor();

  @override
  ConsumerState<_ContactInfoEditor> createState() => _ContactInfoEditorState();
}

class _ContactInfoEditorState extends ConsumerState<_ContactInfoEditor> {
  final _local = TextEditingController();
  final _city = TextEditingController();
  final _phone = TextEditingController();
  final _instagram = TextEditingController();
  bool _loaded = false;
  bool _saving = false;

  @override
  void dispose() {
    _local.dispose();
    _city.dispose();
    _phone.dispose();
    _instagram.dispose();
    super.dispose();
  }

  void _hydrate(Contact? contact) {
    if (_loaded || contact == null) return;
    _loaded = true;
    _local.text = contact.local;
    _city.text = contact.city;
    _phone.text = contact.phone;
    _instagram.text = contact.instagram;
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await ref
          .read(contactRepositoryProvider)
          .updateContactInfo(
            Contact(
              local: _local.text,
              city: _city.text,
              phone: _phone.text,
              instagram: _instagram.text,
            ),
          );
      ref.invalidate(contactInfoProvider);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('저장되었습니다')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('저장 실패: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final contactAsync = ref.watch(contactInfoProvider);

    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: contactAsync.when(
        loading: () => const LoadingState(),
        error: (e, _) =>
            const Text('불러오기 실패', style: TextStyle(color: AppColors.error)),
        data: (contact) {
          _hydrate(contact);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _local,
                      style: _fieldStyle,
                      decoration: const InputDecoration(labelText: '지역(국가)'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _city,
                      style: _fieldStyle,
                      decoration: const InputDecoration(labelText: '도시'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _phone,
                      style: _fieldStyle,
                      decoration: const InputDecoration(labelText: '전화번호'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _instagram,
                      style: _fieldStyle,
                      decoration: const InputDecoration(labelText: '인스타그램'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: PillButton(
                  label: _saving ? '저장 중...' : '저장',
                  icon: FontAwesomeIcons.check,
                  onTap: _saving ? null : _save,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  TextStyle get _fieldStyle =>
      AppTextStyles.body.copyWith(color: AppColors.textPrimary);
}
