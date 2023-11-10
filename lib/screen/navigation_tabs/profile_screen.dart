import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taska/constant/utils.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(title: 'Profile Screen', actions: [
        iconButton(
            icon: const Icon(Icons.logout,color: Colors.black,),
            onTap: () {
              FirebaseAuth.instance.signOut();
            }),
      ]),
    );
  }
}
