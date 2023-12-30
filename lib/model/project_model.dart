import 'package:cloud_firestore/cloud_firestore.dart';

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

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'cover': cover,
    'backgroundCover': backgroundCover,
    'projectColor': projectColor,
    'projectDeadLine': projectDeadLine,
  };

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
    id: json['id'] as String,
    title: json['title'] as String,
    cover: json['cover'] as String?,
    backgroundCover: json['backgroundCover'] as String?,
    projectColor: json['projectColor'] as String?,
    projectDeadLine: json['projectDeadLine'] as String?,
  );

  factory ProjectModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProjectModel.fromJson(data);
  }

  static List<ProjectModel> fromDocumentSnapshots(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) => ProjectModel.fromDocument(doc)).toList();
  }




}
