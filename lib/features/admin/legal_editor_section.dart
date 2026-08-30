import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/legal_document.dart';
import '../../providers/legal_providers.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/pill_button.dart';

/// Admin-only Markdown editor for the privacy policy / terms of service —
/// this is the write side of the new in-app legal-document feature.
class LegalEditorSection extends ConsumerStatefulWidget {
  const LegalEditorSection({
    super.key,
    required this.docId,
    required this.label,
  });

  final String docId;
  final String label;

  @override
  ConsumerState<LegalEditorSection> createState() => _LegalEditorSectionState();
}

class _LegalEditorSectionState extends ConsumerState<LegalEditorSection> {
  final _title = TextEditingController();
  final _content = TextEditingController();
  bool _loaded = false;
  bool _saving = false;

  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    super.dispose();
  }

  void _hydrate(LegalDocument? doc) {
    if (_loaded) return;
    _loaded = true;
    _title.text = doc?.title ?? widget.label;
    _content.text = doc?.content ?? '';
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await ref
          .read(legalRepositoryProvider)
          .update(
            widget.docId,
            title: _title.text.trim(),
            content: _content.text,
          );
      ref.invalidate(legalDocProvider(widget.docId));
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
    final docAsync = ref.watch(legalDocProvider(widget.docId));

    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(widget.label, style: AppTextStyles.title.copyWith(fontSize: 18)),
          const SizedBox(height: 16),
          docAsync.when(
            loading: () =>
                const LinearProgressIndicator(color: AppColors.emerald),
            error: (e, _) =>
                const Text('불러오기 실패', style: TextStyle(color: AppColors.error)),
            data: (doc) {
              _hydrate(doc);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _title,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    decoration: const InputDecoration(labelText: '문서 제목'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _content,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textPrimary,
                      fontFamily: 'monospace',
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Markdown 본문',
                      alignLabelWithHint: true,
                    ),
                    maxLines: 10,
                  ),
                  const SizedBox(height: 12),
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
        ],
      ),
    );
  }
}
