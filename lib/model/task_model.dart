import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class TaskModel {
  late String? taskId;
  late String projectId;
  late String? userId;
  late String title;
  late DateTime time;
  late bool isDone;

  TaskModel({
    this.taskId,
    required this.projectId,
    this.userId,
    required this.title,
    required this.time,
    required this.isDone,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': taskId,
      'projectId': projectId,
      'userId': userId,
      'title': title,
      'time': time.toIso8601String(),
      'done': isDone,
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      taskId: json['id'],
      projectId: json['projectId'],
      userId: json['userId'],
      title: json['title'],
      time: DateTime.parse(json['time']),
      isDone: json['done'],
    );
  }

  TaskModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    final data = documentSnapshot.data() ?? {};
    taskId = data['id'];
    projectId = data['projectId'];
    userId = data['userId'];
    title = data['title'];
    time = DateTime.parse(data['time']);
    // Convert 'done' to a boolean
    isDone = data['done'] ?? false; // Replace 'false' with the default value if 'done' is null
  }
}
