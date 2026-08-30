import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/project.dart';
import 'repository_providers.dart';

class ProjectsNotifier extends AsyncNotifier<List<Project>> {
  @override
  Future<List<Project>> build() {
    return ref.watch(projectsRepositoryProvider).fetchProjects();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(projectsRepositoryProvider).fetchProjects(),
    );
  }

  Future<bool> addProject(Project project) async {
    try {
      await ref.read(projectsRepositoryProvider).addProject(project);
      await refresh();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateProject(String id, Project project) async {
    try {
      await ref.read(projectsRepositoryProvider).updateProject(id, project);
      await refresh();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteProject(String id) async {
    try {
      await ref.read(projectsRepositoryProvider).deleteProject(id);
      await refresh();
      return true;
    } catch (_) {
      return false;
    }
  }
}

final projectsProvider = AsyncNotifierProvider<ProjectsNotifier, List<Project>>(
  ProjectsNotifier.new,
);

/// `null` means "all" — mirrors the legacy filter semantics.
class ProjectsFilterNotifier extends Notifier<ProjectVolume?> {
  @override
  ProjectVolume? build() => null;

  void set(ProjectVolume? filter) => state = filter;
}

final projectsFilterProvider =
    NotifierProvider<ProjectsFilterNotifier, ProjectVolume?>(
      ProjectsFilterNotifier.new,
    );

final filteredProjectsProvider = Provider<AsyncValue<List<Project>>>((ref) {
  final projects = ref.watch(projectsProvider);
  final filter = ref.watch(projectsFilterProvider);
  return projects.whenData((list) {
    if (filter == null) return list;
    return list.where((p) => p.volume == filter).toList();
  });
});
