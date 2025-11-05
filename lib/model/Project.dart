class Project{
  final String title;
  final String description;
  final List<String> skills;
  final List<String> functions;
  final String thumbnail;
  final List<String> images;
  final String github;
  final DateTime startAt;
  final DateTime endAt;
  final String position;

  Project({
    required this.title,
    required this.description,
    required this.skills,
    required this.functions,
    required this.thumbnail,
    required this.images,
    required this.github,
    required this.startAt,
    required this.endAt,
    required this.position
  });
}