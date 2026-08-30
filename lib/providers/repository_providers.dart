import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/about_repository.dart';
import '../data/repositories/admin_auth_repository.dart';
import '../data/repositories/contact_repository.dart';
import '../data/repositories/image_upload_repository.dart';
import '../data/repositories/legal_repository.dart';
import '../data/repositories/projects_repository.dart';
import 'firebase_providers.dart';

final aboutRepositoryProvider = Provider<AboutRepository>(
  (ref) => AboutRepository(ref.watch(firestoreProvider)),
);

final projectsRepositoryProvider = Provider<ProjectsRepository>(
  (ref) => ProjectsRepository(ref.watch(firestoreProvider)),
);

final contactRepositoryProvider = Provider<ContactRepository>(
  (ref) => ContactRepository(ref.watch(firestoreProvider)),
);

final adminAuthRepositoryProvider = Provider<AdminAuthRepository>(
  (ref) => AdminAuthRepository(ref.watch(firebaseAuthProvider)),
);

final imageUploadRepositoryProvider = Provider<ImageUploadRepository>(
  (ref) => ImageUploadRepository(ref.watch(firebaseStorageProvider)),
);

final legalRepositoryProvider = Provider<LegalRepository>(
  (ref) => LegalRepository(ref.watch(firestoreProvider)),
);
