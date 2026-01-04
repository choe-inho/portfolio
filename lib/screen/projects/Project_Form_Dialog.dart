// lib/screen/project/Project_Form_Dialog.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:portfolio/controller/Projects_Controller.dart';
import 'package:portfolio/model/Project.dart';
import 'package:portfolio/service/Image_Upload_Service.dart';
import 'package:portfolio/util/config/App_Constants.dart';
import 'package:portfolio/util/animation/Portfolio_Indicator.dart';

class ProjectFormDialog extends StatefulWidget {
  final Project? project; // null이면 추가 모드, 있으면 수정 모드

  const ProjectFormDialog({
    super.key,
    this.project,
  });

  @override
  State<ProjectFormDialog> createState() => _ProjectFormDialogState();
}

class _ProjectFormDialogState extends State<ProjectFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final ImageUploadService _imageService = ImageUploadService();

  // 컨트롤러
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _skillsController;
  late TextEditingController _notionController;

  // 상태
  ProjectVolume _selectedVolume = ProjectVolume.personal;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  bool _isLoading = false;

  // 이미지 관련
  String? _thumbnailUrl; // 기존 또는 새로 업로드된 URL
  Uint8List? _selectedImageBytes; // 새로 선택한 이미지 (미리보기용)
  String? _selectedImageExtension;
  int? _selectedImageSize;
  bool _isImageChanged = false; // 이미지가 변경되었는지

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.project != null) {
      // 수정 모드
      _titleController = TextEditingController(text: widget.project!.title);
      _descriptionController = TextEditingController(text: widget.project!.description);
      _skillsController = TextEditingController(text: widget.project!.skills.join(', '));
      _notionController = TextEditingController(text: widget.project!.notion);
      _selectedVolume = widget.project!.volume;
      _startDate = widget.project!.startAt;
      _endDate = widget.project!.endAt;
      _thumbnailUrl = widget.project!.thumbnail;
    } else {
      // 추가 모드
      _titleController = TextEditingController();
      _descriptionController = TextEditingController();
      _skillsController = TextEditingController();
      _notionController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _skillsController.dispose();
    _notionController.dispose();
    super.dispose();
  }

  /// 이미지 선택
  Future<void> _selectImage() async {
    try {
      final imageData = await _imageService.pickImage();

      if (imageData != null) {
        setState(() {
          _selectedImageBytes = imageData['bytes'] as Uint8List;
          _selectedImageExtension = imageData['extension'] as String;
          _selectedImageSize = imageData['fileSize'] as int;
          _isImageChanged = true;
        });

        debugPrint('✅ 이미지 선택 완료: ${imageData['fileName']}');
      }
    } catch (e) {
      _showErrorDialog('이미지 선택 실패', e.toString());
    }
  }

  /// 이미지 제거
  void _removeImage() {
    setState(() {
      _selectedImageBytes = null;
      _selectedImageExtension = null;
      _selectedImageSize = null;
      _isImageChanged = true;
      if (widget.project != null) {
        _thumbnailUrl = null; // 기존 이미지도 제거
      }
    });
  }

  /// 프로젝트 저장
  Future<void> _saveProject() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // 이미지 필수 확인
    if (_selectedImageBytes == null && _thumbnailUrl == null) {
      _showErrorDialog('썸네일 필수', '프로젝트 썸네일 이미지를 선택해주세요.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      String finalThumbnailUrl = _thumbnailUrl ?? '';

      // 새 이미지가 선택되었다면 업로드
      if (_isImageChanged && _selectedImageBytes != null) {
        debugPrint('🚀 새 이미지 업로드 시작...');

        // 기존 이미지 삭제 (수정 모드에서)
        if (widget.project != null && widget.project!.thumbnail.isNotEmpty) {
          await _imageService.deleteImage(widget.project!.thumbnail);
        }

        // 새 이미지 업로드
        finalThumbnailUrl = await _imageService.uploadImage(
          bytes: _selectedImageBytes!,
          extension: _selectedImageExtension!,
        );

        debugPrint('✅ 이미지 업로드 완료: $finalThumbnailUrl');
      }

      // 스킬 파싱
      final skills = _skillsController.text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      // 프로젝트 객체 생성
      final project = Project(
        id: widget.project?.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        skills: skills,
        thumbnail: finalThumbnailUrl,
        notion: _notionController.text.trim(),
        startAt: _startDate,
        endAt: _endDate,
        volume: _selectedVolume,
      );

      // 저장
      final controller = Get.find<ProjectsController>();
      bool success;

      if (widget.project == null) {
        // 추가
        success = await controller.addProject(project);
      } else {
        // 수정
        success = await controller.updateProject(widget.project!.id!, project);
      }

      if (success) {
        Navigator.pop(context);
        _showSuccessSnackBar(
          widget.project == null ? '프로젝트가 추가되었습니다.' : '프로젝트가 수정되었습니다.',
        );
      } else {
        throw Exception('저장 실패');
      }
    } catch (e) {
      debugPrint('❌ 프로젝트 저장 실패: $e');
      _showErrorDialog('저장 실패', e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// 프로젝트 삭제
  Future<void> _deleteProject() async {
    if (widget.project == null) return;

    final confirmed = await _showDeleteConfirmDialog();
    if (!confirmed) return;

    setState(() => _isLoading = true);

    try {
      final controller = Get.find<ProjectsController>();

      // Firebase Storage 이미지 삭제
      if (widget.project!.thumbnail.isNotEmpty) {
        await _imageService.deleteImage(widget.project!.thumbnail);
      }

      // Firestore 문서 삭제
      final success = await controller.deleteProject(widget.project!.id!);

      if (success) {
        Navigator.pop(context);
        _showSuccessSnackBar('프로젝트가 삭제되었습니다.');
      } else {
        throw Exception('삭제 실패');
      }
    } catch (e) {
      debugPrint('❌ 프로젝트 삭제 실패: $e');
      _showErrorDialog('삭제 실패', e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);

    return Dialog(
      child: Container(
        width: constants.dialogMaxWidth(context),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 헤더
            _buildHeader(theme, constants),

            // 콘텐츠 (스크롤 가능)
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(constants.spacingL),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 썸네일 이미지 업로드
                      _buildThumbnailSection(theme, constants),

                      SizedBox(height: constants.spacingL),

                      // 제목
                      _buildTextField(
                        controller: _titleController,
                        label: '프로젝트 제목',
                        hint: '예: 포트폴리오 웹사이트',
                        icon: LucideIcons.fileText,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return '제목을 입력해주세요';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: constants.spacingM),

                      // 설명
                      _buildTextField(
                        controller: _descriptionController,
                        label: '프로젝트 설명',
                        hint: '프로젝트에 대한 간단한 설명을 입력하세요',
                        icon: LucideIcons.alignLeft,
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return '설명을 입력해주세요';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: constants.spacingM),

                      // 기술 스택
                      _buildTextField(
                        controller: _skillsController,
                        label: '기술 스택',
                        hint: '예: Flutter, Firebase, Node.js (쉼표로 구분)',
                        icon: LucideIcons.code,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return '기술 스택을 입력해주세요';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: constants.spacingM),

                      // Notion URL 또는 메시지 (수정됨!)
                      _buildNotionField(theme, constants),

                      SizedBox(height: constants.spacingL),

                      // 프로젝트 타입
                      _buildVolumeSelector(theme, constants),

                      SizedBox(height: constants.spacingL),

                      // 날짜 선택
                      _buildDateSelectors(theme, constants),
                    ],
                  ),
                ),
              ),
            ),

            // 하단 버튼
            _buildBottomButtons(theme, constants),
          ],
        ),
      ),
    );
  }

  /// 헤더
  Widget _buildHeader(ThemeData theme, AppConstants constants) {
    return Container(
      padding: EdgeInsets.all(constants.spacingL),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(constants.largeBorderRadius(context)),
          topRight: Radius.circular(constants.largeBorderRadius(context)),
        ),
      ),
      child: Row(
        children: [
          Icon(
            widget.project == null ? LucideIcons.plus : LucideIcons.edit,
            color: theme.colorScheme.primary,
            size: constants.iconSize(context),
          ),
          SizedBox(width: constants.spacingM),
          Text(
            widget.project == null ? '프로젝트 추가' : '프로젝트 수정',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              LucideIcons.x,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  /// 썸네일 섹션
  Widget _buildThumbnailSection(ThemeData theme, AppConstants constants) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              LucideIcons.image,
              size: constants.smallIconSize(context),
              color: theme.colorScheme.primary,
            ),
            SizedBox(width: constants.spacingS),
            Text(
              '썸네일 이미지 *',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: constants.spacingS),
        Text(
          '• 권장 크기: 1280 x 720px (16:9 비율)\n'
              '• 최대 파일 크기: ${ImageUploadService.maxFileSizeText}\n'
              '• 지원 형식: ${ImageUploadService.allowedFormatsText}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        SizedBox(height: constants.spacingM),

        // 이미지 미리보기 또는 업로드 버튼
        _selectedImageBytes != null || _thumbnailUrl != null
            ? _buildImagePreview(theme, constants)
            : _buildUploadButton(theme, constants),
      ],
    );
  }

  /// 이미지 미리보기
  Widget _buildImagePreview(ThemeData theme, AppConstants constants) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 200.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(constants.borderRadius(context)),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(constants.borderRadius(context)),
            child: _selectedImageBytes != null
                ? Image.memory(
              _selectedImageBytes!,
              fit: BoxFit.cover,
            )
                : Image.network(
              _thumbnailUrl!,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: PortfolioLoadingIndicator(
                    style: IndicatorStyle.codingAnimation,
                    size: constants.smallIndicatorSize(context),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Icon(
                    LucideIcons.imageOff,
                    size: 48.r,
                    color: theme.colorScheme.error,
                  ),
                );
              },
            ),
          ),
        ),

        // 파일 정보 (새로 선택한 경우만)
        if (_selectedImageSize != null)
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: constants.spacingM,
                vertical: constants.spacingS,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(constants.pillBorderRadius(context)),
              ),
              child: Text(
                _formatFileSize(_selectedImageSize!),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

        // 제거 버튼
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            onPressed: _removeImage,
            style: IconButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
            ),
            icon: Icon(LucideIcons.trash2, size: 18.r),
          ),
        ),

        // 변경 버튼
        Positioned(
          top: 8,
          right: 56,
          child: IconButton(
            onPressed: _selectImage,
            style: IconButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
            ),
            icon: Icon(LucideIcons.edit, size: 18.r),
          ),
        ),
      ],
    );
  }

  /// 업로드 버튼
  Widget _buildUploadButton(ThemeData theme, AppConstants constants) {
    return InkWell(
      onTap: _selectImage,
      borderRadius: BorderRadius.circular(constants.borderRadius(context)),
      child: Container(
        width: double.infinity,
        height: 200.h,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(constants.borderRadius(context)),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.upload,
              size: 48.r,
              color: theme.colorScheme.primary,
            ),
            SizedBox(height: constants.spacingM),
            Text(
              '이미지 선택',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: constants.spacingS),
            Text(
              '클릭하여 이미지를 선택하세요',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Notion URL 또는 메시지 필드 (수정됨!)
  Widget _buildNotionField(ThemeData theme, AppConstants constants) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              LucideIcons.link,
              size: constants.smallIconSize(context),
              color: theme.colorScheme.primary,
            ),
            SizedBox(width: constants.spacingS),
            Text(
              'Notion URL 또는 안내 메시지',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: constants.spacingS),
        TextFormField(
          controller: _notionController,
          decoration: InputDecoration(
            hintText: 'URL 또는 안내 메시지를 입력하세요',
            helperText: '• URL: https://notion.so/page\n'
                '• 메시지: 현재 개발 중입니다',
            helperMaxLines: 2,
            filled: true,
            fillColor: theme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
          ),
          maxLines: 3, // 여러 줄 입력 가능
          validator: (value) {
            // ✅ URL 검증 제거! 비어있지만 않으면 OK
            if (value == null || value.trim().isEmpty) {
              return 'URL 또는 메시지를 입력해주세요';
            }
            return null;
          },
          enabled: !_isLoading,
        ),
        SizedBox(height: constants.spacingS),
        // 입력 가이드
        Container(
          padding: EdgeInsets.all(constants.spacingM),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(constants.borderRadius(context)),
          ),
          child: Row(
            children: [
              Icon(
                LucideIcons.info,
                size: 16.r,
                color: theme.colorScheme.primary,
              ),
              SizedBox(width: constants.spacingS),
              Expanded(
                child: Text(
                  'URL 입력 시 브라우저로 열리고, 메시지 입력 시 다이얼로그로 표시됩니다',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 텍스트 필드
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: constants.smallIconSize(context),
              color: theme.colorScheme.primary,
            ),
            SizedBox(width: constants.spacingS),
            Text(
              label,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: constants.spacingS),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: theme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
          ),
          maxLines: maxLines,
          validator: validator,
          enabled: !_isLoading,
        ),
      ],
    );
  }

  /// 프로젝트 타입 선택
  Widget _buildVolumeSelector(ThemeData theme, AppConstants constants) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              LucideIcons.users,
              size: constants.smallIconSize(context),
              color: theme.colorScheme.primary,
            ),
            SizedBox(width: constants.spacingS),
            Text(
              '프로젝트 타입',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: constants.spacingM),
        Wrap(
          spacing: constants.spacingM,
          children: ProjectVolume.values.map((volume) {
            final isSelected = _selectedVolume == volume;
            return ChoiceChip(
              label: Text(ProjectVolume.stateToText(volume)),
              selected: isSelected,
              onSelected: _isLoading
                  ? null
                  : (selected) {
                if (selected) {
                  setState(() => _selectedVolume = volume);
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  /// 날짜 선택
  Widget _buildDateSelectors(ThemeData theme, AppConstants constants) {
    return Row(
      children: [
        Expanded(
          child: _buildDateSelector(
            theme: theme,
            constants: constants,
            label: '시작일',
            date: _startDate,
            icon: LucideIcons.calendarDays,
            onTap: () => _selectDate(isStart: true),
          ),
        ),
        SizedBox(width: constants.spacingM),
        Expanded(
          child: _buildDateSelector(
            theme: theme,
            constants: constants,
            label: '종료일',
            date: _endDate,
            icon: LucideIcons.calendarCheck,
            onTap: () => _selectDate(isStart: false),
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector({
    required ThemeData theme,
    required AppConstants constants,
    required String label,
    required DateTime date,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: constants.smallIconSize(context),
              color: theme.colorScheme.primary,
            ),
            SizedBox(width: constants.spacingS),
            Text(
              label,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: constants.spacingS),
        InkWell(
          onTap: _isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(constants.borderRadius(context)),
          child: Container(
            padding: EdgeInsets.all(constants.spacingM),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(constants.borderRadius(context)),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${date.year}.${date.month.toString().padLeft(2, '0')}',
                  style: theme.textTheme.bodyLarge,
                ),
                Icon(
                  LucideIcons.chevronDown,
                  size: constants.smallIconSize(context),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 하단 버튼
  Widget _buildBottomButtons(ThemeData theme, AppConstants constants) {
    return Container(
      padding: EdgeInsets.all(constants.spacingL),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          // 삭제 버튼 (수정 모드에서만)
          if (widget.project != null) ...[
            TextButton.icon(
              onPressed: _isLoading ? null : _deleteProject,
              icon: Icon(LucideIcons.trash2, size: 18.r),
              label: const Text('삭제'),
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
              ),
            ),
            const Spacer(),
          ] else
            const Spacer(),

          // 취소 버튼
          TextButton(
            onPressed: _isLoading ? null : () => Navigator.pop(context),
            child: const Text('취소'),
          ),

          SizedBox(width: constants.spacingM),

          // 저장 버튼
          ElevatedButton.icon(
            onPressed: _isLoading ? null : _saveProject,
            icon: _isLoading
                ? SizedBox(
              width: 16.r,
              height: 16.r,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: theme.colorScheme.onPrimary,
              ),
            )
                : Icon(LucideIcons.check, size: 18.r),
            label: Text(_isLoading ? '저장 중..' : '저장'),
          ),
        ],
      ),
    );
  }

  // ============================================
  // Helper 메서드
  // ============================================

  Future<void> _selectDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_startDate.isAfter(_endDate)) {
            _endDate = _startDate;
          }
        } else {
          _endDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _startDate = _endDate;
          }
        }
      });
    }
  }

  Future<bool> _showDeleteConfirmDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final constants = AppConstants.of(context);

        return AlertDialog(
          title: Row(
            children: [
              Icon(
                LucideIcons.alertTriangle,
                color: theme.colorScheme.error,
              ),
              SizedBox(width: constants.spacingM),
              const Text('프로젝트 삭제'),
            ],
          ),
          content: const Text('정말로 이 프로젝트를 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
              ),
              child: const Text('삭제'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final constants = AppConstants.of(context);

        return AlertDialog(
          title: Row(
            children: [
              Icon(
                LucideIcons.xCircle,
                color: theme.colorScheme.error,
              ),
              SizedBox(width: constants.spacingM),
              Text(title),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              LucideIcons.checkCircle,
              color: Colors.white,
              size: 20.r,
            ),
            SizedBox(width: AppConstants.of(context).spacingM),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }
}