class FillProfileModel {
  final String id;
  final String fullName;
  final String userName;
  final String imgUrl;
  final String emailAddress;
  final String? dob;
  final String? phoneNumber;
  final String? role;

  FillProfileModel({
    required this.id,
    required this.fullName,
    required this.userName,
    required this.imgUrl,
    required this.emailAddress,
    required this.dob,
    required this.phoneNumber,
    required this.role,
  });

  toJson() => {
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
