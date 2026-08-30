import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/legal_document.dart';
import 'repository_providers.dart';

final legalDocProvider = FutureProvider.family<LegalDocument?, String>((
  ref,
  docId,
) {
  return ref.watch(legalRepositoryProvider).fetch(docId);
});
