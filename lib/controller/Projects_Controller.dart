import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/model/Project.dart';

class ProjectsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 데이터 로딩 완료 여부 (true면 로딩 완료)
  RxBool isDataLoaded = false.obs;

  // 프로젝트 목록
  List<Project>? projects;

  // 선택된 프로젝트 필터 (전체, 개인, 팀, 사내)
  Rx<ProjectVolume?> selectedFilter = Rx<ProjectVolume?>(null);

  // 디버그 모드 여부
  bool get isDebugMode => kDebugMode;

  @override
  void onInit() {
    super.onInit();
    _initializeProjectsController();
  }

  Future<void> _initializeProjectsController() async {
    await _fetchProjects();
  }

  /// 프로젝트 목록 가져오기
  Future<void> _fetchProjects() async {
    try {
      // 이미 데이터를 불러왔으면 리턴
      if (isDataLoaded.value) {
        debugPrint('[Projects Controller] 이미 프로젝트를 불러왔습니다');
        return;
      }

      debugPrint('[Projects Controller] 프로젝트 목록 불러오기 시작');

      final res = await _firestore
          .collection('projects')
          .orderBy('startAt', descending: true)
          .get();

      final listData = res.docs;

      if (listData.isNotEmpty) {
        debugPrint('[Projects Controller] 프로젝트 ${listData.length}개 불러오기 완료');
        projects = listData
            .map((doc) => Project.fromJson(doc.data(), id: doc.id))
            .toList();
      } else {
        debugPrint('[Projects Controller] 프로젝트 목록이 비어있습니다');
        projects = [];
      }

      // 데이터 로딩 완료
      isDataLoaded.value = true;
      update();
    } catch (e) {
      debugPrint('[Projects Controller] 프로젝트 패치 실패: $e');
      projects = [];
      isDataLoaded.value = true;
      update();
    }
  }

  /// 필터링된 프로젝트 목록 가져오기
  List<Project> get filteredProjects {
    if (projects == null) return [];
    if (selectedFilter.value == null) return projects!;

    return projects!
        .where((project) => project.volume == selectedFilter.value)
        .toList();
  }

  /// 필터 변경
  void changeFilter(ProjectVolume? filter) {
    selectedFilter.value = filter;
    update();
  }

  /// 프로젝트 추가
  Future<bool> addProject(Project project) async {
    try {
      debugPrint('[Projects Controller] 프로젝트 추가 시작');

      await _firestore.collection('projects').add(project.toMap());

      debugPrint('[Projects Controller] 프로젝트 추가 완료');

      // 목록 새로고침
      await refresh();

      return true;
    } catch (e) {
      debugPrint('[Projects Controller] 프로젝트 추가 실패: $e');
      return false;
    }
  }

  /// 프로젝트 수정
  Future<bool> updateProject(String projectId, Project project) async {
    try {
      debugPrint('[Projects Controller] 프로젝트 수정 시작');

      await _firestore
          .collection('projects')
          .doc(projectId)
          .update(project.toMap());

      debugPrint('[Projects Controller] 프로젝트 수정 완료');

      // 목록 새로고침
      await refresh();

      return true;
    } catch (e) {
      debugPrint('[Projects Controller] 프로젝트 수정 실패: $e');
      return false;
    }
  }

  /// 프로젝트 삭제
  Future<bool> deleteProject(String projectId) async {
    try {
      debugPrint('[Projects Controller] 프로젝트 삭제 시작');

      await _firestore.collection('projects').doc(projectId).delete();

      debugPrint('[Projects Controller] 프로젝트 삭제 완료');

      // 목록 새로고침
      await refresh();

      return true;
    } catch (e) {
      debugPrint('[Projects Controller] 프로젝트 삭제 실패: $e');
      return false;
    }
  }

  /// 새로고침
  Future<void> refresh() async {
    isDataLoaded.value = false;
    projects = null;
    await _fetchProjects();
  }
}