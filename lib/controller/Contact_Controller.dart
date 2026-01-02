import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Contact Model
class Contact {
  final String local;
  final String city;
  final String phone;
  final String instagram;

  Contact({
    required this.local,
    required this.city,
    required this.phone,
    required this.instagram,
  });

  factory Contact.fromJson(Map<String, dynamic> map) {
    return Contact(
      local: map['local'] ?? '',
      city: map['city'] ?? '',
      phone: map['phone'] ?? '',
      instagram: map['instagram'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'local': local,
      'city': city,
      'phone': phone,
      'instagram': instagram,
    };
  }
}

/// Contact Controller
/// Contact 정보 및 문의 폼 관리
class ContactController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Contact 정보 ID (고정)
  static const String contactDocId = 'MfbG8A8QTzkVCx8qSz92';

  // Contact 정보
  final Rx<Contact?> contactInfo = Rx<Contact?>(null);

  // 폼 컨트롤러
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final subjectController = TextEditingController();
  final messageController = TextEditingController();

  // 폼 키
  final formKey = GlobalKey<FormState>();

  // 로딩 상태
  final fetching = false.obs; // Contact 정보 로딩
  final isLoading = false.obs; // 폼 전송 로딩

  // 전송 성공 여부
  final isSubmitted = false.obs;

  @override
  void onInit() {
    super.onInit();
    debugPrint('📧 [Contact Controller] 초기화');
    _fetchContactInfo();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    subjectController.dispose();
    messageController.dispose();
    debugPrint('👋 [Contact Controller] onClose');
    super.onClose();
  }

  /// Contact 정보 가져오기
  Future<void> _fetchContactInfo() async {
    try {
      fetching.value = false;
      debugPrint('📥 [Contact Controller] Contact 정보 가져오기 시작');

      final doc = await _firestore
          .collection('contact')
          .doc(contactDocId)
          .get();

      if (doc.exists) {
        contactInfo.value = Contact.fromJson(doc.data()!);
        debugPrint('✅ [Contact Controller] Contact 정보 로드 완료');
      } else {
        debugPrint('❌ [Contact Controller] Contact 문서가 존재하지 않음');
        contactInfo.value = null;
      }
    } catch (e) {
      debugPrint('❌ [Contact Controller] Contact 정보 가져오기 실패: $e');
      contactInfo.value = null;
    } finally {
      fetching.value = true;
    }
  }

  /// Contact 정보 새로고침
  Future<void> refreshContactInfo() async {
    debugPrint('🔄 [Contact Controller] Contact 정보 새로고침');
    await _fetchContactInfo();
  }

  /// 폼 유효성 검사
  bool validateForm() {
    if (!formKey.currentState!.validate()) {
      debugPrint('❌ [Contact Controller] 폼 유효성 검사 실패');
      return false;
    }
    debugPrint('✅ [Contact Controller] 폼 유효성 검사 통과');
    return true;
  }

  /// 메시지 전송
  Future<bool> submitMessage() async {
    if (!validateForm()) {
      return false;
    }

    try {
      isLoading.value = true;
      debugPrint('📤 [Contact Controller] 메시지 전송 시작');

      // Firestore에 문의 내역 저장
      final contactData = {
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'subject': subjectController.text.trim(),
        'message': messageController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
        'status': 'pending', // pending, replied, archived
      };

      await _firestore.collection('contacts').add(contactData);

      debugPrint('✅ [Contact Controller] Firestore 저장 완료');

      // TODO: 실제 이메일 전송 로직
      await _sendEmail(contactData);

      // 성공 상태 업데이트
      isSubmitted.value = true;
      clearForm();

      debugPrint('✅ [Contact Controller] 메시지 전송 완료');
      return true;
    } catch (e) {
      debugPrint('❌ [Contact Controller] 메시지 전송 실패: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// 이메일 전송 (실제 구현 필요)
  Future<void> _sendEmail(Map<String, dynamic> data) async {
    // TODO: 실제 이메일 전송 로직 구현

    // 옵션 1: EmailJS
    // 옵션 2: Firebase Functions
    // 옵션 3: Node.js 백엔드

    // 임시: 2초 지연
    await Future.delayed(const Duration(seconds: 2));
    debugPrint('📧 [Contact Controller] 이메일 전송 완료 (시뮬레이션)');
  }

  /// 폼 초기화
  void clearForm() {
    formKey.currentState?.reset();
    nameController.clear();
    emailController.clear();
    subjectController.clear();
    messageController.clear();
    debugPrint('🔄 [Contact Controller] 폼 초기화 완료');
  }

  /// 문의 내역 조회 (관리자용)
  Stream<List<ContactMessage>> getContactMessages() {
    debugPrint('📋 [Contact Controller] 문의 내역 조회 시작');

    return _firestore
        .collection('contacts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ContactMessage.fromFirestore(doc);
      }).toList();
    });
  }

  /// 문의 읽음 처리 (관리자용)
  Future<void> markAsRead(String messageId) async {
    try {
      await _firestore.collection('contacts').doc(messageId).update({
        'isRead': true,
        'readAt': FieldValue.serverTimestamp(),
      });
      debugPrint('✅ [Contact Controller] 읽음 처리 완료: $messageId');
    } catch (e) {
      debugPrint('❌ [Contact Controller] 읽음 처리 실패: $e');
    }
  }

  /// 문의 상태 변경 (관리자용)
  Future<void> updateStatus(String messageId, String status) async {
    try {
      await _firestore.collection('contacts').doc(messageId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      debugPrint('✅ [Contact Controller] 상태 변경 완료: $messageId -> $status');
    } catch (e) {
      debugPrint('❌ [Contact Controller] 상태 변경 실패: $e');
    }
  }

  /// Contact 정보 업데이트 (관리자용)
  Future<bool> updateContactInfo(Contact newContact) async {
    try {
      debugPrint('📝 [Contact Controller] Contact 정보 업데이트 시작');

      await _firestore
          .collection('contact')
          .doc(contactDocId)
          .update(newContact.toJson());

      // 로컬 상태 업데이트
      contactInfo.value = newContact;

      debugPrint('✅ [Contact Controller] Contact 정보 업데이트 완료');
      return true;
    } catch (e) {
      debugPrint('❌ [Contact Controller] Contact 정보 업데이트 실패: $e');
      return false;
    }
  }
}

/// Contact 메시지 모델 (문의 내역)
class ContactMessage {
  final String id;
  final String name;
  final String email;
  final String subject;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final String status;

  ContactMessage({
    required this.id,
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
    required this.timestamp,
    required this.isRead,
    required this.status,
  });

  /// Firestore에서 데이터 가져오기
  factory ContactMessage.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ContactMessage(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      subject: data['subject'] ?? '',
      message: data['message'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: data['isRead'] ?? false,
      status: data['status'] ?? 'pending',
    );
  }

  /// Firestore에 저장할 Map으로 변환
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'subject': subject,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': isRead,
      'status': status,
    };
  }
}