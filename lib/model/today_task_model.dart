import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class TodayTaskModel {
  late String? id;
  late String title;
  late bool isDone;

  TodayTaskModel({
    this.id,
    required this.title,
    required this.isDone,
  });

  TodayTaskModel.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    id = documentSnapshot.data()?['uid'];
    title = documentSnapshot.data()?['title'];
    isDone = documentSnapshot.data()?['done'];
  }
}
