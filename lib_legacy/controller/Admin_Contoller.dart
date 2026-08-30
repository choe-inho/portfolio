import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

/// Admin 권한 관리 컨트롤러
///
/// 이 컨트롤러는 현재 사용자가 관리자 권한을 가지고 있는지 확인합니다.
/// Firebase Authentication과 Firestore를 사용하여 보안을 강화합니다.
class AdminController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 관리자 여부
  final RxBool isAdmin = false.obs;

  // 로그인 여부
  final RxBool isLoggedIn = false.obs;

  // 현재 사용자
  User? get currentUser => _auth.currentUser;

  @override
  void onInit() {
    super.onInit();
    _initializeAdminController();
  }

  void _initializeAdminController() {
    debugPrint('🔐 [Admin Controller] 초기화 시작');

    // Auth 상태 변경 리스너
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        debugPrint('✅ [Admin Controller] 사용자 로그인: ${user.email}');
        isLoggedIn.value = true;
        _checkAdminStatus(user);
      } else {
        debugPrint('⚠️ [Admin Controller] 사용자 로그아웃');
        isLoggedIn.value = false;
        isAdmin.value = false;
      }
    });
  }

  /// 관리자 권한 확인
  Future<void> _checkAdminStatus(User user) async {
    try {
      // Custom Claims에서 admin 권한 확인
      final idTokenResult = await user.getIdTokenResult();
      final claims = idTokenResult.claims;

      final isAdminUser = claims?['admin'] == true;

      debugPrint('🔍 [Admin Controller] Admin 권한: $isAdminUser');
      isAdmin.value = isAdminUser;

    } catch (e) {
      debugPrint('❌ [Admin Controller] 권한 확인 실패: $e');
      isAdmin.value = false;
    }
  }

  /// 관리자 로그인
  Future<bool> signInAsAdmin(String email, String password) async {
    try {
      debugPrint('🔑 [Admin Controller] 로그인 시도: $email');

      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await _checkAdminStatus(userCredential.user!);

        if (isAdmin.value) {
          debugPrint('✅ [Admin Controller] 관리자 로그인 성공');
          return true;
        } else {
          debugPrint('⚠️ [Admin Controller] 관리자 권한 없음');
          await signOut();
          return false;
        }
      }

      return false;
    } catch (e) {
      debugPrint('❌ [Admin Controller] 로그인 실패: $e');
      return false;
    }
  }

  /// 로그아웃
  Future<void> signOut() async {
    try {
      debugPrint('👋 [Admin Controller] 로그아웃');
      await _auth.signOut();
      isLoggedIn.value = false;
      isAdmin.value = false;
    } catch (e) {
      debugPrint('❌ [Admin Controller] 로그아웃 실패: $e');
    }
  }

  /// 편의 메서드: 관리자 모드 사용 가능 여부
  bool get canUseAdminFeatures {
    // 프로덕션에서는 무조건 인증 필요
    if (kReleaseMode) {
      return isLoggedIn.value && isAdmin.value;
    }

    return isLoggedIn.value && isAdmin.value;
  }

  @override
  void onClose() {
    debugPrint('👋 [Admin Controller] 종료');
    super.onClose();
  }
}