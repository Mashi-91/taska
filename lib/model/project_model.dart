class ProjectModel {
  final String id;
  final String title;
  final String? cover;
  final String? backgroundCover;
  final String? projectColor;
  final String? projectDeadLine;

  ProjectModel({
    required this.id,
    required this.title,
    this.cover,
    this.backgroundCover,
    this.projectColor,
    this.projectDeadLine,
  });

  toJson() => {
        'id': id,
        'title': title,
        'cover': cover,
        'backgroundCover': backgroundCover,
        'projectColor': projectColor,
        'projectDeadLine': projectDeadLine,
      };
}
