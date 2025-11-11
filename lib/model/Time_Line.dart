
import 'package:flutter/cupertino.dart';
import 'package:lucide_icons/lucide_icons.dart';

enum  TimeLineType{
  education('education'),
  career('career'),
  experience('experience');

  const TimeLineType(this.value);

  final String value;

  static TimeLineType toState(String? type){
    switch(type){
      case 'education' : return TimeLineType.education;
      case 'career' : return TimeLineType.career;
      default : return TimeLineType.experience;
    }
  }

  static IconData toIcon(String? type){
    switch(type){
      case 'education' : return LucideIcons.graduationCap;
      case 'career' : return LucideIcons.building;
      default : return LucideIcons.flaskConical;
    }
  }
}

class TimeLine{
  final TimeLineType type;
  final String title;
  final String subTitle;
  final DateTime startDate;
  final DateTime endDate;
  final String description;
  final IconData iconData;

  TimeLine({
    required this.type,
    required this.title,
    required this.subTitle,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.iconData
  });

  factory TimeLine.fromJson(Map<String, dynamic> map){
    return TimeLine(
        type: TimeLineType.toState(map['type']),
        title: map['title'],
        subTitle: map['subTitle'],
        startDate: map['startDate'],
        endDate: map['endDate'],
        description: map['description'],
        iconData: TimeLineType.toIcon(map['type'])
    );
  }
}