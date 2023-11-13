import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class TodayTaskModel {
  late String? id;
  late String title;
  late DateTime time;
  late bool isDone;

  TodayTaskModel({
    this.id,
    required this.title,
    required this.time,
    required this.isDone,
  });

  TodayTaskModel.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    id = documentSnapshot.data()?['uid'];
    title = documentSnapshot.data()?['title'];
    time = documentSnapshot.data()?['time'];
    isDone = documentSnapshot.data()?['done'];
  }
}
