import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:portfolio/controller/App_Controller.dart';
import 'package:portfolio/controller/Contact_Controller.dart';
import 'package:portfolio/util/animation/Portfolio_Animation.dart';
import 'package:portfolio/util/config/App_Constants.dart';
import 'package:portfolio/util/theme/App_Colors.dart';

class ContactFormSection extends StatelessWidget {
  const ContactFormSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);
    final contactController = Get.find<ContactController>();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: constants.horizontalPadding(context),
        vertical: constants.spacingXXL,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
      ),
      child: Column(
        children: [
          // 섹션 타이틀
          FadeInAnimation(
            delay: const Duration(milliseconds: 300),
            child: _SectionTitle(),
          ),

          SizedBox(height: constants.spacingXL),

          // 폼 컨테이너
          SlideInAnimation(
            delay: const Duration(milliseconds: 500),
            child: _FormContainer(controller: contactController),
          ),
        ],
      ),
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
              LucideIcons.send,
              size: constants.iconSize(context),
              color: theme.colorScheme.primary,
            ),
            SizedBox(width: constants.spacingS),
            Text(
              '메시지 보내기',
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
          '프로젝트 제안, 협업 문의 등 무엇이든 환영합니다',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

/// 폼 컨테이너
class _FormContainer extends StatelessWidget {
  final ContactController controller;

  const _FormContainer({required this.controller});

  Future<void> _handleSubmit(BuildContext context) async {
    final success = await controller.submitMessage();

    if (!context.mounted) return;

    if (success) {
      // 성공 메시지
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                LucideIcons.checkCircle,
                color: Colors.white,
                size: 20.r,
              ),
              SizedBox(width: 8.w),
              const Expanded(
                child: Text(
                  '메시지가 성공적으로 전송되었습니다!\n빠른 시일 내에 답변드리겠습니다.',
                ),
              ),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.success,
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16.r),
        ),
      );
    } else {
      // 실패 메시지
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                LucideIcons.xCircle,
                color: Colors.white,
                size: 20.r,
              ),
              SizedBox(width: 8.w),
              const Expanded(
                child: Text('메시지 전송에 실패했습니다. 다시 시도해주세요.'),
              ),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16.r),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);
    final appController = Get.find<AppController>();

    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: appController.responsive(
            mobile: double.infinity,
            tablet: 700.w,
            web: 800.w,
          ),
        ),
        padding: EdgeInsets.all(constants.spacingXL),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(
            constants.largeBorderRadius(context),
          ),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 이름 & 이메일 (반응형)
              Obx(() {
                final isLoading = controller.isLoading.value;

                if (appController.isMobile) {
                  return Column(
                    children: [
                      _NameField(
                        controller: controller.nameController,
                        enabled: !isLoading,
                      ),
                      SizedBox(height: constants.spacingM),
                      _EmailField(
                        controller: controller.emailController,
                        enabled: !isLoading,
                      ),
                    ],
                  );
                } else {
                  return Row(
                    children: [
                      Expanded(
                        child: _NameField(
                          controller: controller.nameController,
                          enabled: !isLoading,
                        ),
                      ),
                      SizedBox(width: constants.spacingM),
                      Expanded(
                        child: _EmailField(
                          controller: controller.emailController,
                          enabled: !isLoading,
                        ),
                      ),
                    ],
                  );
                }
              }),

              SizedBox(height: constants.spacingM),

              // 제목
              Obx(() => _SubjectField(
                controller: controller.subjectController,
                enabled: !controller.isLoading.value,
              )),

              SizedBox(height: constants.spacingM),

              // 메시지
              Obx(() => _MessageField(
                controller: controller.messageController,
                enabled: !controller.isLoading.value,
              )),

              SizedBox(height: constants.spacingXL),

              // 제출 버튼
              Obx(() => _SubmitButton(
                isLoading: controller.isLoading.value,
                onPressed: () => _handleSubmit(context),
              )),
            ],
          ),
        ),
      ),
    );
  }
}

/// 이름 필드
class _NameField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;

  const _NameField({
    required this.controller,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: '이름 *',
        hintText: '홍길동',
        prefixIcon: Icon(
          LucideIcons.user,
          color: enabled ? null : theme.colorScheme.onSurface.withValues(alpha: 0.38),
        ),
        filled: true,
        fillColor: theme.colorScheme.surfaceVariant.withValues(alpha: 0.5),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '이름을 입력해주세요';
        }
        if (value.trim().length < 2) {
          return '이름은 2자 이상 입력해주세요';
        }
        return null;
      },
    );
  }
}

/// 이메일 필드
class _EmailField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;

  const _EmailField({
    required this.controller,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: '이메일 *',
        hintText: 'example@email.com',
        prefixIcon: Icon(
          LucideIcons.mail,
          color: enabled ? null : theme.colorScheme.onSurface.withValues(alpha: 0.38),
        ),
        filled: true,
        fillColor: theme.colorScheme.surfaceVariant.withValues(alpha: 0.5),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '이메일을 입력해주세요';
        }
        // 이메일 정규식 검증
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value.trim())) {
          return '올바른 이메일 형식이 아닙니다';
        }
        return null;
      },
    );
  }
}

/// 제목 필드
class _SubjectField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;

  const _SubjectField({
    required this.controller,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: '제목 *',
        hintText: '문의 제목을 입력하세요',
        prefixIcon: Icon(
          LucideIcons.fileText,
          color: enabled ? null : theme.colorScheme.onSurface.withValues(alpha: 0.38),
        ),
        filled: true,
        fillColor: theme.colorScheme.surfaceVariant.withValues(alpha: 0.5),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '제목을 입력해주세요';
        }
        if (value.trim().length < 5) {
          return '제목은 5자 이상 입력해주세요';
        }
        return null;
      },
    );
  }
}

/// 메시지 필드
class _MessageField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;

  const _MessageField({
    required this.controller,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      enabled: enabled,
      maxLines: 8,
      maxLength: 1000,
      decoration: InputDecoration(
        labelText: '메시지 *',
        hintText: '문의 내용을 자세히 작성해주세요',
        prefixIcon: Padding(
          padding: EdgeInsets.only(bottom: 120.h),
          child: Icon(
            LucideIcons.messageSquare,
            color: enabled ? null : theme.colorScheme.onSurface.withValues(alpha: 0.38),
          ),
        ),
        filled: true,
        fillColor: theme.colorScheme.surfaceVariant.withValues(alpha: 0.5),
        alignLabelWithHint: true,
        helperText: '최소 10자 이상 입력해주세요',
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '메시지를 입력해주세요';
        }
        if (value.trim().length < 10) {
          return '메시지는 최소 10자 이상 입력해주세요';
        }
        return null;
      },
    );
  }
}

/// 제출 버튼
class _SubmitButton extends StatefulWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _SubmitButton({
    required this.isLoading,
    required this.onPressed,
  });

  @override
  State<_SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<_SubmitButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.isLoading ? SystemMouseCursors.wait : SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: constants.fastAnimation,
        transform: Matrix4.identity()
          ..translate(0.0, _isHovered && !widget.isLoading ? -2.0 : 0.0),
        child: ElevatedButton.icon(
          onPressed: widget.isLoading ? null : widget.onPressed,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: constants.spacingXL,
              vertical: constants.spacingL,
            ),
            elevation: _isHovered && !widget.isLoading ? 8 : 4,
            shadowColor: theme.colorScheme.primary.withValues(alpha: 0.4),
          ),
          icon: widget.isLoading
              ? SizedBox(
            width: 20.r,
            height: 20.r,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.onPrimary,
              ),
            ),
          )
              : Icon(
            LucideIcons.send,
            size: constants.iconSize(context),
          ),
          label: Text(
            widget.isLoading ? '전송 중...' : '메시지 전송',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}