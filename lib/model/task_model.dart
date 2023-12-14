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

  TaskModel.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    taskId = documentSnapshot.data()?['id'];
    projectId = documentSnapshot.data()?['projectId'];
    userId = documentSnapshot.data()?['userId'];
    title = documentSnapshot.data()?['title'];
    time = DateTime.parse(documentSnapshot.data()?['time']);
    isDone = documentSnapshot.data()?['done'];
  }
}
