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
  final String title;
  final String description;
  final List<String> skills;
  final String thumbnail;
  final String notion;
  final DateTime startAt;
  final DateTime endAt;
  final ProjectVolume volume;

  Project({
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
      'skills' : skills,
      'thumbnail' : thumbnail,
      'notion' : notion,
      'startAt' : startAt,
      'endAt' : endAt,
      'volume' : volume
    };
  }

  factory Project.fromJson(Map<String, dynamic> map){
      return Project(
          title: map['title'],
          description: map['description'],
          skills: map['skills'],
          thumbnail: map['thumbnail'],
          notion: map['notion'],
          startAt: map['startAt'].toDate(),
          endAt: map['endAt'].toDate(),
          volume: map['volume']
      );
  }
}