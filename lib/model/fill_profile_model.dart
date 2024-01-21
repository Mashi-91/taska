import 'package:cloud_firestore/cloud_firestore.dart';

class FillProfileModel {
  final String? id;
  final String? fullName;
  final String? userName;
  final String? imgUrl;
  final String? emailAddress;
  final String? dob;
  final String? phoneNumber;
  final String? role;

  FillProfileModel({
    this.id,
    this.fullName,
    this.userName,
    this.imgUrl,
    this.emailAddress,
    this.dob,
    this.phoneNumber,
    this.role,
  });

  // Named constructor for creating an instance from a DocumentSnapshot
  FillProfileModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> document)
      : id = document['id'] as String?,
        fullName = document['fullName'] as String?,
        userName = document['userName'] as String?,
        imgUrl = document['imgUrl'] as String?,
        emailAddress = document['emailAddress'] as String?,
        dob = document['dateOfBirth'] as String?,
        phoneNumber = document['phoneNumber'] as String?,
        role = document['role'] as String?;

  // Named constructor for creating an instance from a Map
  FillProfileModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        fullName = json['fullName'],
        userName = json['userName'],
        imgUrl = json['imgUrl'],
        emailAddress = json['emailAddress'],
        dob = json['dateOfBirth'],
        phoneNumber = json['phoneNumber'],
        role = json['role'];

  // toJson method to convert the instance to a Map
  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'userName': userName,
    'imgUrl': imgUrl,
    'emailAddress': emailAddress,
    'dateOfBirth': dob,
    'phoneNumber': phoneNumber,
    'role': role,
  };
}
