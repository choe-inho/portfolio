import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/contact.dart';
import 'repository_providers.dart';

final contactInfoProvider = FutureProvider<Contact?>((ref) {
  return ref.watch(contactRepositoryProvider).fetchContactInfo();
});

/// Admin-only: live inbox of contact-form submissions.
final contactMessagesProvider = StreamProvider<List<ContactMessage>>((ref) {
  return ref.watch(contactRepositoryProvider).watchMessages();
});
