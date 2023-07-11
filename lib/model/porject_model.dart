class ProjectModel {
  final String id;
  final String title;
  final String options;
  final List<String>? members;

  ProjectModel(
      {required this.id,
      required this.title,
      required this.options,
      this.members});

  toJson() => {
        'id': id,
        'title': title,
        'options': options,
        'members': members,
      };
}
