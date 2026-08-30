import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Firestore contract: `timeline` collection documents.
enum TimeLineType {
  education('education'),
  career('career'),
  experience('experience');

  const TimeLineType(this.value);
  final String value;

  static TimeLineType toState(String? type) {
    switch (type) {
      case 'education':
        return TimeLineType.education;
      case 'career':
        return TimeLineType.career;
      default:
        return TimeLineType.experience;
    }
  }

  static FaIconData toIcon(String? type) {
    switch (type) {
      case 'education':
        return FontAwesomeIcons.graduationCap;
      case 'career':
        return FontAwesomeIcons.building;
      default:
        return FontAwesomeIcons.flask;
    }
  }
}

class TimeLine {
  final TimeLineType type;
  final String title;
  final String subTitle;
  final DateTime startDate;
  final DateTime endDate;
  final String description;
  final FaIconData iconData;

  const TimeLine({
    required this.type,
    required this.title,
    required this.subTitle,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.iconData,
  });

  factory TimeLine.fromJson(Map<String, dynamic> map) {
    return TimeLine(
      type: TimeLineType.toState(map['type']),
      title: map['title'] ?? '',
      subTitle: map['subTitle'] ?? '',
      startDate: map['startDate']?.toDate() ?? DateTime.now(),
      endDate: map['endDate']?.toDate() ?? DateTime.now(),
      description: map['description'] ?? '',
      iconData: TimeLineType.toIcon(map['type']),
    );
  }
}
