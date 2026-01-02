import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:portfolio/model/Project.dart';

class ProjectsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 데이터 로딩 완료 여부 (true면 로딩 완료)
  final RxBool isDataLoaded = false.obs;

  // 프로젝트 목록
  List<Project>? projects;

  // 선택된 프로젝트 필터 (전체, 개인, 팀, 사내)
  final Rx<ProjectVolume?> selectedFilter = Rx<ProjectVolume?>(null);

  // 디버그 모드 여부
  bool get isDebugMode => kDebugMode;

  @override
  void onInit() {
    super.onInit();
    debugPrint('🎮 [Projects Controller] onInit 시작');
    _initializeProjectsController();
  }

  Future<void> _initializeProjectsController() async {
    debugPrint('🚀 [Projects Controller] 초기화 시작');
    await _fetchProjects();
    debugPrint('✅ [Projects Controller] 초기화 완료');
  }

  /// 프로젝트 목록 가져오기
  Future<void> _fetchProjects() async {
    try {
      // 이미 데이터를 불러왔으면 리턴
      if (isDataLoaded.value) {
        debugPrint('⏭️ [Projects Controller] 이미 프로젝트를 불러왔습니다');
        return;
      }

      debugPrint('📥 [Projects Controller] 프로젝트 목록 불러오기 시작');

      final res = await _firestore
          .collection('projects')
          .orderBy('startAt', descending: true)
          .get();

      final listData = res.docs;

      debugPrint('📊 [Projects Controller] 받아온 문서 개수: ${listData.length}');

      if (listData.isNotEmpty) {
        debugPrint('✅ [Projects Controller] 프로젝트 ${listData.length}개 불러오기 완료');
        projects = listData
            .map((doc) {
          debugPrint('📄 [Projects Controller] 문서 ID: ${doc.id}');
          return Project.fromJson(doc.data(), id: doc.id);
        })
            .toList();
      } else {
        debugPrint('⚠️ [Projects Controller] 프로젝트 목록이 비어있습니다');
        projects = [];
      }

      // 데이터 로딩 완료
      isDataLoaded.value = true;
      debugPrint('🎯 [Projects Controller] isDataLoaded = true 설정 완료');

    } catch (e, stackTrace) {
      debugPrint('❌ [Projects Controller] 프로젝트 패치 실패: $e');
      debugPrint('Stack trace: $stackTrace');
      projects = [];
      isDataLoaded.value = true;
    }
  }

  /// 필터링된 프로젝트 목록 가져오기
  List<Project> get filteredProjects {
    debugPrint('🔍 [Projects Controller] filteredProjects 호출 - 필터: ${selectedFilter.value}');

    if (projects == null) {
      debugPrint('⚠️ [Projects Controller] projects가 null입니다');
      return [];
    }

    if (selectedFilter.value == null) {
      debugPrint('📋 [Projects Controller] 전체 프로젝트 반환: ${projects!.length}개');
      return projects!;
    }

    final filtered = projects!
        .where((project) => project.volume == selectedFilter.value)
        .toList();

    debugPrint('📋 [Projects Controller] 필터링된 프로젝트: ${filtered.length}개');
    return filtered;
  }

  /// 필터 변경
  void changeFilter(ProjectVolume? filter) {
    debugPrint('🔄 [Projects Controller] 필터 변경: $filter');
    selectedFilter.value = filter;
  }

  /// 프로젝트 추가
  Future<bool> addProject(Project project) async {
    try {
      debugPrint('➕ [Projects Controller] 프로젝트 추가 시작');

      await _firestore.collection('projects').add(project.toMap());

      debugPrint('✅ [Projects Controller] 프로젝트 추가 완료');

      // 목록 새로고침
      await refresh();

      return true;
    } catch (e) {
      debugPrint('❌ [Projects Controller] 프로젝트 추가 실패: $e');
      return false;
    }
  }

  /// 프로젝트 수정
  Future<bool> updateProject(String projectId, Project project) async {
    try {
      debugPrint('✏️ [Projects Controller] 프로젝트 수정 시작');

      await _firestore
          .collection('projects')
          .doc(projectId)
          .update(project.toMap());

      debugPrint('✅ [Projects Controller] 프로젝트 수정 완료');

      // 목록 새로고침
      await refresh();

      return true;
    } catch (e) {
      debugPrint('❌ [Projects Controller] 프로젝트 수정 실패: $e');
      return false;
    }
  }

  /// 프로젝트 삭제
  Future<bool> deleteProject(String projectId) async {
    try {
      debugPrint('🗑️ [Projects Controller] 프로젝트 삭제 시작');

      await _firestore.collection('projects').doc(projectId).delete();

      debugPrint('✅ [Projects Controller] 프로젝트 삭제 완료');

      // 목록 새로고침
      await refresh();

      return true;
    } catch (e) {
      debugPrint('❌ [Projects Controller] 프로젝트 삭제 실패: $e');
      return false;
    }
  }

  /// 새로고침
  Future<void> refresh() async {
    debugPrint('🔄 [Projects Controller] 새로고침 시작');
    isDataLoaded.value = false;
    projects = null;
    await _fetchProjects();
  }

  @override
  void onClose() {
    debugPrint('👋 [Projects Controller] onClose');
    super.onClose();
  }
}