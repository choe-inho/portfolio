import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/motion/motion.dart';
import '../../core/responsive/responsive.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/legal_providers.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/loading_state.dart';
import '../../widgets/page_scaffold.dart';

/// Public reader for the admin-authored privacy policy / terms of service —
/// new in the rebuild; the legacy app had no such page at all.
class LegalPage extends ConsumerWidget {
  const LegalPage({super.key, required this.docId});

  final String docId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final docAsync = ref.watch(legalDocProvider(docId));

    return PageScaffold(
      currentPath: '/$docId',
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.horizontalPadding,
            vertical: context.sectionPaddingVertical,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: docAsync.when(
              loading: () => const SizedBox(height: 300, child: LoadingState()),
              error: (e, _) => const SizedBox(
                height: 300,
                child: ErrorState(message: '문서를 불러올 수 없습니다'),
              ),
              data: (doc) {
                if (doc == null) {
                  return const SizedBox(
                    height: 200,
                    child: Center(
                      child: Text('아직 등록된 문서가 없습니다', style: AppTextStyles.body),
                    ),
                  );
                }
                return FadeSlideIn(
                  child: GlassCard(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doc.title,
                          style: AppTextStyles.headline.copyWith(fontSize: 30),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '최종 수정일 ${DateFormat('yyyy.MM.dd').format(doc.updatedAt)}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        MarkdownBody(
                          data: doc.content,
                          styleSheet: MarkdownStyleSheet(
                            p: AppTextStyles.body,
                            h1: AppTextStyles.title.copyWith(fontSize: 26),
                            h2: AppTextStyles.title.copyWith(fontSize: 21),
                            h3: AppTextStyles.title.copyWith(fontSize: 18),
                            listBullet: AppTextStyles.body,
                            strong: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                            a: const TextStyle(color: AppColors.emerald),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
