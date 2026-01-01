import 'package:flutter/material.dart';

enum ProjectVolume{
  personal('personal'),
  team('team'),
  company('company'); //개인, 팀, 회사

  const ProjectVolume(this.value);
  final String value;

  static ProjectVolume toState(String? type){
    switch(type){
      case 'team' :
        return ProjectVolume.team;
      case 'company' :
        return ProjectVolume.company;
      default :
        return ProjectVolume.personal;
    }
  }


  static String stateToText(ProjectVolume state){
    switch(state){
      case ProjectVolume.personal : return '개인';
      case ProjectVolume.team : return '팀';
      case ProjectVolume.company : return '사내';
    }
  }

  static Color stateToTextColor(ProjectVolume state, BuildContext context){
    final theme = Theme.of(context);

    switch(state){
      case ProjectVolume.personal : return theme.colorScheme.primary;
      case ProjectVolume.team : return theme.colorScheme.secondary;
      case ProjectVolume.company : return theme.colorScheme.tertiary;
    }
  }
}

class Project{
  final String? id;
  final String title;
  final String description;
  final List<String> skills;
  final String thumbnail;
  final String notion;
  final DateTime startAt;
  final DateTime endAt;
  final ProjectVolume volume;

  Project({
    this.id,
    required this.title,
    required this.description,
    required this.skills,
    required this.thumbnail,
    required this.notion,
    required this.startAt,
    required this.endAt,
    required this.volume
  });


  Map<String, dynamic> toMap(){
    return {
      'title' : title,
      'description' : description,
      'skills' : List<String>.from(skills),
      'thumbnail' : thumbnail,
      'notion' : notion,
      'startAt' : startAt,
      'endAt' : endAt,
      'volume' : volume.value,
    };
  }

  factory Project.fromJson(Map<String, dynamic> map, {String? id}){
    return Project(
        id: id,
        title: map['title'] ?? '',
        description: map['description'] ?? '',
        skills: List<String>.from(map['skills'] ?? []),
        thumbnail: map['thumbnail'] ?? '',
        notion: map['notion'] ?? '',
        startAt: map['startAt']?.toDate() ?? DateTime.now(),
        endAt: map['endAt']?.toDate() ?? DateTime.now(),
        volume: ProjectVolume.toState(map['volume'])
    );
  }

  // copyWith 메서드 추가 (수정 시 유용)
  Project copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? skills,
    String? thumbnail,
    String? notion,
    DateTime? startAt,
    DateTime? endAt,
    ProjectVolume? volume,
  }) {
    return Project(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      skills: skills ?? this.skills,
      thumbnail: thumbnail ?? this.thumbnail,
      notion: notion ?? this.notion,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      volume: volume ?? this.volume,
    );
  }
}