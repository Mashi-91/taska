class ProjectModel {
  final String id;
  final String title;
  final String? cover;

  ProjectModel({
    required this.id,
    required this.title,
    this.cover,
  });

  toJson() => {
        'id': id,
        'title': title,
        'cover': cover,
      };
}
