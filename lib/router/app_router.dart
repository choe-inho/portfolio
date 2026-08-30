import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:web/web.dart' as web;

import '../core/motion/motion.dart';
import '../data/models/legal_document.dart';
import '../features/about/about_me_page.dart';
import '../features/admin/contact_admin_page.dart';
import '../features/contact/contact_page.dart';
import '../features/hero/hero_page.dart';
import '../features/legal/legal_page.dart';
import '../features/projects/projects_page.dart';
import '../providers/admin_providers.dart';
import '../providers/repository_providers.dart';
import 'app_routes.dart';

/// Bridges a [Stream] to go_router's [Listenable]-based `refreshListenable`
/// so route redirects re-evaluate whenever Firebase auth state changes.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

void _setTitle(String title) {
  if (kIsWeb) {
    web.document.title = title;
  }
}

/// Fade + gentle scale-up transition between pages — flipping a route no
/// longer just cuts, it feels like the next screen rises into place.
CustomTransitionPage<void> _page(
  GoRouterState state,
  String title,
  Widget child,
) {
  _setTitle(title);
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: AppMotion.slow,
    reverseTransitionDuration: AppMotion.normal,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: AppMotion.spring,
      );
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween(begin: 0.97, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
  );
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final authStream = ref.watch(adminAuthRepositoryProvider).authStateChanges();

  return GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: GoRouterRefreshStream(authStream),
    redirect: (context, state) async {
      if (state.matchedLocation != AppRoutes.contactAdmin) return null;

      final user = ref.read(authStateChangesProvider).value;
      if (user == null) return AppRoutes.contact;

      final isAdmin = await ref.read(isAdminProvider.future);
      return isAdmin ? null : AppRoutes.contact;
    },
    routes: [
      GoRoute(
        path: AppRoutes.home,
        pageBuilder: (context, state) =>
            _page(state, '최인호 포트폴리오', const HeroPage()),
      ),
      GoRoute(
        path: AppRoutes.aboutMe,
        pageBuilder: (context, state) =>
            _page(state, '최인호 포트폴리오 - 소개', const AboutMePage()),
      ),
      GoRoute(
        path: AppRoutes.projects,
        pageBuilder: (context, state) =>
            _page(state, '최인호 포트폴리오 - 프로젝트', const ProjectsPage()),
      ),
      GoRoute(
        path: AppRoutes.contact,
        pageBuilder: (context, state) =>
            _page(state, '최인호 포트폴리오 - 연락처', const ContactPage()),
      ),
      GoRoute(
        path: AppRoutes.contactAdmin,
        pageBuilder: (context, state) =>
            _page(state, '최인호 포트폴리오 - 관리자', const ContactAdminPage()),
      ),
      GoRoute(
        path: AppRoutes.privacy,
        pageBuilder: (context, state) => _page(
          state,
          '개인정보처리방침',
          const LegalPage(docId: LegalDocIds.privacy),
        ),
      ),
      GoRoute(
        path: AppRoutes.terms,
        pageBuilder: (context, state) =>
            _page(state, '이용약관', const LegalPage(docId: LegalDocIds.terms)),
      ),
    ],
  );
});
