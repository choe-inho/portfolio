import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/project.dart';

class ProjectsRepository {
  ProjectsRepository(this._firestore);

  final FirebaseFirestore _firestore;

  Future<List<Project>> fetchProjects() async {
    final res = await _firestore
        .collection('projects')
        .orderBy('startAt', descending: true)
        .get();
    return res.docs
        .map((doc) => Project.fromJson(doc.data(), id: doc.id))
        .toList();
  }

  Future<void> addProject(Project project) {
    return _firestore.collection('projects').add(project.toMap());
  }

  Future<void> updateProject(String projectId, Project project) {
    return _firestore
        .collection('projects')
        .doc(projectId)
        .update(project.toMap());
  }

  Future<void> deleteProject(String projectId) {
    return _firestore.collection('projects').doc(projectId).delete();
  }
}
