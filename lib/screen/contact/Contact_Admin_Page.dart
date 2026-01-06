import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:portfolio/controller/Contact_Controller.dart';
import 'package:portfolio/util/config/App_Constants.dart';
import 'package:intl/intl.dart';
import 'package:portfolio/util/theme/App_Colors.dart';

import '../../controller/Admin_Contoller.dart';
import '../../util/config/Font_Sizes.dart';

/// 관리자용 Contact 관리 페이지
/// 문의 내역 확인, 상태 변경, 답변 처리
class ContactAdminPage extends StatelessWidget {
  const ContactAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    final adminController = Get.find<AdminController>();
    final contactController = Get.find<ContactController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('문의 관리'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.refreshCw),
            onPressed: () {
              // 새로고침
              Get.forceAppUpdate();
            },
            tooltip: '새로고침',
          ),
        ],
      ),
      body: Obx(() {
        // 관리자 권한 확인
        if (!adminController.isAdmin.value) {
          return _NoPermissionView();
        }

        return StreamBuilder<List<ContactMessage>>(
          stream: contactController.getContactMessages(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return _ErrorView(error: snapshot.error.toString());
            }

            final messages = snapshot.data ?? [];

            if (messages.isEmpty) {
              return _EmptyView();
            }

            return _MessageList(messages: messages);
          },
        );
      }),
    );
  }
}

/// 권한 없음 뷰
class _NoPermissionView extends StatelessWidget {
  const _NoPermissionView();

  @override
  Widget build(BuildContext context) {
    final fontSizes = FontSizes.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.shieldOff,
            size: 64.r,
            color: Theme.of(context).colorScheme.error,
          ),
          SizedBox(height: 16.h),
          Text(
            '관리자 권한이 필요합니다',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: fontSizes.headlineSmall(context)
            ),
            
          ),
        ],
      ),
    );
  }
}

/// 에러 뷰
class _ErrorView extends StatelessWidget {
  final String error;

  const _ErrorView({required this.error});

  @override
  Widget build(BuildContext context) {
    final fontSizes = FontSizes.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.alertCircle,
            size: 64.r,
            color: Theme.of(context).colorScheme.error,
          ),
          SizedBox(height: 16.h),
          Text(
            '오류가 발생했습니다',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: fontSizes.headlineSmall(context)
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            error,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: fontSizes.bodyMedium(context)
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// 빈 목록 뷰
class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    final fontSizes = FontSizes.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.inbox,
            size: 64.r,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          SizedBox(height: 16.h),
          Text(
            '문의 내역이 없습니다',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: fontSizes.headlineSmall(context)
            ),
          ),
        ],
      ),
    );
  }
}

/// 메시지 목록
class _MessageList extends StatelessWidget {
  final List<ContactMessage> messages;

  const _MessageList({required this.messages});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16.r),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return _MessageCard(message: messages[index]);
      },
    );
  }
}

/// 메시지 카드
class _MessageCard extends StatelessWidget {
  final ContactMessage message;

  const _MessageCard({required this.message});

  void _showDetailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _MessageDetailDialog(message: message),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);
    final dateFormat = DateFormat('yyyy.MM.dd HH:mm');
    final fontSizes = FontSizes.of(context);
    
    return Card(
      margin: EdgeInsets.only(bottom: constants.spacingM),
      child: InkWell(
        onTap: () => _showDetailDialog(context),
        borderRadius: BorderRadius.circular(
          constants.borderRadius(context),
        ),
        child: Padding(
          padding: EdgeInsets.all(constants.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더 (이름, 날짜, 상태)
              Row(
                children: [
                  // 읽음 표시
                  Container(
                    width: 8.r,
                    height: 8.r,
                    decoration: BoxDecoration(
                      color: message.isRead
                          ? theme.colorScheme.outline
                          : theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: constants.spacingS),
                  // 이름
                  Expanded(
                    child: Text(
                      message.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight:
                        message.isRead ? FontWeight.w500 : FontWeight.w700,
                        fontSize: fontSizes.titleMedium(context)
                      ),
                    ),
                  ),
                  // 날짜
                  Text(
                    dateFormat.format(message.timestamp),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      fontSize: fontSizes.bodySmall(context)
                    ),
                  ),
                ],
              ),

              SizedBox(height: constants.spacingS),

              // 이메일
              Row(
                children: [
                  Icon(
                    LucideIcons.mail,
                    size: 14.r,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  SizedBox(width: constants.spacingXS),
                  Text(
                    message.email,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      fontSize: fontSizes.bodySmall(context)
                    ),
                  ),
                ],
              ),

              SizedBox(height: constants.spacingS),

              // 제목
              Text(
                message.subject,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: fontSizes.bodyMedium(context)
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: constants.spacingS),

              // 메시지 미리보기
              Text(
                message.message,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: fontSizes.bodySmall(context)
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: constants.spacingS),

              // 상태 칩
              _StatusChip(status: message.status),
            ],
          ),
        ),
      ),
    );
  }
}

/// 상태 칩
class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color color;
    String label;

    switch (status) {
      case 'pending':
        color = theme.colorScheme.primary;
        label = '대기중';
        break;
      case 'replied':
        color = theme.colorScheme.success;
        label = '답변완료';
        break;
      case 'archived':
        color = theme.colorScheme.outline;
        label = '보관됨';
        break;
      default:
        color = theme.colorScheme.outline;
        label = '알 수 없음';
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 4.h,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

/// 메시지 상세 다이얼로그
class _MessageDetailDialog extends StatelessWidget {
  final ContactMessage message;

  const _MessageDetailDialog({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);
    final contactController = Get.find<ContactController>();
    final dateFormat = DateFormat('yyyy년 MM월 dd일 HH:mm');
    final fontSizes = FontSizes.of(context);
    
    return Dialog(
      child: Container(
        constraints: BoxConstraints(maxWidth: 600.w),
        padding: EdgeInsets.all(constants.spacingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Row(
              children: [
                Expanded(
                  child: Text(
                    '문의 상세',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontSize: fontSizes.headlineSmall(context)
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.x),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),

            Divider(height: constants.spacingL),

            // 정보
            _InfoRow(
              icon: LucideIcons.user,
              label: '이름',
              value: message.name,
            ),
            SizedBox(height: constants.spacingS),
            _InfoRow(
              icon: LucideIcons.mail,
              label: '이메일',
              value: message.email,
            ),
            SizedBox(height: constants.spacingS),
            _InfoRow(
              icon: LucideIcons.calendar,
              label: '날짜',
              value: dateFormat.format(message.timestamp),
            ),

            SizedBox(height: constants.spacingL),

            // 제목
            Text(
              '제목',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: fontSizes.titleSmall(context)
              ),
            ),
            SizedBox(height: constants.spacingS),
            Text(
              message.subject,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: fontSizes.bodyMedium(context)
              ),
            ),

            SizedBox(height: constants.spacingL),

            // 메시지
            Text(
              '메시지',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: fontSizes.titleSmall(context)
              ),
            ),
            SizedBox(height: constants.spacingS),
            Container(
              padding: EdgeInsets.all(constants.spacingM),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(
                  constants.borderRadius(context),
                ),
              ),
              child: Text(
                message.message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: fontSizes.bodyMedium(context)
                ),
              ),
            ),

            SizedBox(height: constants.spacingL),

            // 액션 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // 읽음 처리
                if (!message.isRead)
                  TextButton.icon(
                    onPressed: () {
                      contactController.markAsRead(message.id);
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(LucideIcons.check),
                    label: const Text('읽음 처리'),
                  ),
                SizedBox(width: constants.spacingS),
                // 상태 변경
                PopupMenuButton<String>(
                  icon: const Icon(LucideIcons.moreVertical),
                  onSelected: (status) {
                    contactController.updateStatus(message.id, status);
                    Navigator.of(context).pop();
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'pending',
                      child: Text('대기중으로 변경'),
                    ),
                    const PopupMenuItem(
                      value: 'replied',
                      child: Text('답변완료로 변경'),
                    ),
                    const PopupMenuItem(
                      value: 'archived',
                      child: Text('보관하기'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 정보 행
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontSizes = FontSizes.of(context);
    
    return Row(
      children: [
        Icon(
          icon,
          size: 16.r,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        SizedBox(width: 8.w),
        Text(
          '$label: ',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: fontSizes.bodyMedium(context)
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: fontSizes.bodyMedium(context)
            ),
          ),
        ),
      ],
    );
  }
}