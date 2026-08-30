import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'repository_providers.dart';

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(adminAuthRepositoryProvider).authStateChanges();
});

/// Resolves the `admin` custom claim for the current user. Defaults to
/// `false` while loading or signed out, which is what route guards want.
final isAdminProvider = FutureProvider<bool>((ref) async {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) return false;
  return ref.watch(adminAuthRepositoryProvider).isAdmin(user);
});

class AdminSignInState {
  const AdminSignInState({this.isLoading = false, this.error});

  final bool isLoading;
  final String? error;

  AdminSignInState copyWith({bool? isLoading, String? error}) {
    return AdminSignInState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AdminSignInController extends Notifier<AdminSignInState> {
  @override
  AdminSignInState build() => const AdminSignInState();

  Future<bool> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final ok = await ref
          .read(adminAuthRepositoryProvider)
          .signInAsAdmin(email, password);
      state = state.copyWith(
        isLoading: false,
        error: ok ? null : '관리자 권한이 없는 계정입니다.',
      );
      return ok;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: '로그인에 실패했습니다: $e');
      return false;
    }
  }

  Future<void> signOut() => ref.read(adminAuthRepositoryProvider).signOut();
}

final adminSignInControllerProvider =
    NotifierProvider<AdminSignInController, AdminSignInState>(
      AdminSignInController.new,
    );
