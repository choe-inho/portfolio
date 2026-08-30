import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/project.dart';
import '../../providers/projects_providers.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/pill_button.dart';

Future<void> showProjectFormDialog(BuildContext context, {Project? project}) {
  return showDialog(
    context: context,
    builder: (context) => ProjectFormDialog(project: project),
  );
}

class ProjectFormDialog extends ConsumerStatefulWidget {
  const ProjectFormDialog({super.key, this.project});

  final Project? project;

  @override
  ConsumerState<ProjectFormDialog> createState() => _ProjectFormDialogState();
}

class _ProjectFormDialogState extends ConsumerState<ProjectFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _description;
  late final TextEditingController _notion;
  late final TextEditingController _skills;

  late DateTime _startAt;
  late DateTime _endAt;
  late ProjectVolume _volume;
  String? _thumbnail;

  bool _uploading = false;
  bool _saving = false;

  bool get _isEdit => widget.project != null;

  @override
  void initState() {
    super.initState();
    final project = widget.project;
    _title = TextEditingController(text: project?.title);
    _description = TextEditingController(text: project?.description);
    _notion = TextEditingController(text: project?.notion);
    _skills = TextEditingController(text: project?.skills.join(', '));
    _startAt = project?.startAt ?? DateTime.now();
    _endAt = project?.endAt ?? DateTime.now();
    _volume = project?.volume ?? ProjectVolume.personal;
    _thumbnail = project?.thumbnail;
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _notion.dispose();
    _skills.dispose();
    super.dispose();
  }

  Future<void> _pickThumbnail() async {
    setState(() => _uploading = true);
    try {
      final url = await ref
          .read(imageUploadRepositoryProvider)
          .pickAndUploadImage();
      if (url != null) setState(() => _thumbnail = url);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startAt : _endAt,
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    setState(() => isStart ? _startAt = picked : _endAt = picked);
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_thumbnail == null || _thumbnail!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('썸네일 이미지를 업로드해주세요')));
      return;
    }

    setState(() => _saving = true);
    final project = Project(
      id: widget.project?.id,
      title: _title.text.trim(),
      description: _description.text.trim(),
      skills: _skills.text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList(),
      thumbnail: _thumbnail!,
      notion: _notion.text.trim(),
      startAt: _startAt,
      endAt: _endAt,
      volume: _volume,
    );

    final notifier = ref.read(projectsProvider.notifier);
    final ok = _isEdit
        ? await notifier.updateProject(widget.project!.id!, project)
        : await notifier.addProject(project);

    if (!mounted) return;
    setState(() => _saving = false);
    if (ok) {
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('저장에 실패했습니다')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 640),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _isEdit ? '프로젝트 수정' : '프로젝트 추가',
                  style: AppTextStyles.title,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _thumbnailPreview(),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _title,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textPrimary,
                          ),
                          decoration: const InputDecoration(labelText: '제목'),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? '제목을 입력해주세요'
                              : null,
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _description,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textPrimary,
                          ),
                          decoration: const InputDecoration(labelText: '설명'),
                          maxLines: 3,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? '설명을 입력해주세요'
                              : null,
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _skills,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textPrimary,
                          ),
                          decoration: const InputDecoration(
                            labelText: '기술 스택 (쉼표로 구분)',
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _notion,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textPrimary,
                          ),
                          decoration: const InputDecoration(
                            labelText: '노션/외부 링크',
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? '링크를 입력해주세요'
                              : null,
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: _dateField(
                                '시작일',
                                _startAt,
                                () => _pickDate(isStart: true),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _dateField(
                                '종료일',
                                _endAt,
                                () => _pickDate(isStart: false),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        _volumeSelector(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _saving
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: const Text('취소'),
                    ),
                    const SizedBox(width: 8),
                    PillButton(
                      label: _saving ? '저장 중...' : '저장',
                      icon: FontAwesomeIcons.check,
                      onTap: _saving ? null : _save,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _thumbnailPreview() {
    return GestureDetector(
      onTap: _uploading ? null : _pickThumbnail,
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: AppColors.glassFill,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.glassBorder),
          image: _thumbnail != null && _thumbnail!.isNotEmpty
              ? DecorationImage(
                  image: NetworkImage(_thumbnail!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: _uploading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.emerald),
              )
            : (_thumbnail == null || _thumbnail!.isEmpty)
            ? const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.upload,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(height: 8),
                    Text('썸네일 업로드 (최대 500KB)', style: AppTextStyles.bodySmall),
                  ],
                ),
              )
            : Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      '변경',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _dateField(String label, DateTime value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(labelText: label),
        child: Text(
          '${value.year}.${value.month.toString().padLeft(2, '0')}',
          style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
        ),
      ),
    );
  }

  Widget _volumeSelector() {
    return Wrap(
      spacing: 8,
      children: [
        for (final v in ProjectVolume.values)
          ChoiceChip(
            label: Text(v.label),
            selected: _volume == v,
            onSelected: (_) => setState(() => _volume = v),
          ),
      ],
    );
  }
}
