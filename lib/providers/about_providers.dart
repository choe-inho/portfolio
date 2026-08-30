import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/about_me.dart';
import '../data/models/time_line.dart';
import 'repository_providers.dart';

final aboutMeProvider = FutureProvider<AboutMe?>((ref) {
  return ref.watch(aboutRepositoryProvider).fetchAboutMe();
});

final timelineProvider = FutureProvider<List<TimeLine>>((ref) {
  return ref.watch(aboutRepositoryProvider).fetchTimeline();
});
