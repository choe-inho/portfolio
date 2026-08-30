import '../../data/models/skill.dart';

/// Static tech-stack list rendered on the hero page. Ported as-is from the
/// legacy `SkillsConfig` — these are hand-curated, not Firestore-backed.
class SkillsConfig {
  SkillsConfig._();

  static const List<Skill> skills = [
    Skill(
      name: 'Flutter',
      icon: 'assets/skill/flutter.png',
      color: 0xff00569e,
      proficiency: 3,
    ),
    Skill(
      name: 'Node',
      icon: 'assets/skill/node.png',
      color: 0xff6cdb4d,
      proficiency: 3,
    ),
    Skill(
      name: 'Python',
      icon: 'assets/skill/python.png',
      color: 0xff8257f1,
      proficiency: 2,
    ),
    Skill(
      name: 'AWS',
      icon: 'assets/skill/aws.png',
      color: 0xffff9900,
      proficiency: 2,
    ),
    Skill(
      name: 'Firebase',
      icon: 'assets/skill/firebase.png',
      color: 0xffffca28,
      proficiency: 3,
    ),
    Skill(
      name: 'RESTApi',
      icon: 'assets/skill/api.png',
      color: 0xffe76f51,
      proficiency: 2,
    ),
  ];
}
