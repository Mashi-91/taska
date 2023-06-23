import 'package:flutter/material.dart';
import 'package:taska/screen/auth/sign_up/fill_your_profile/widget.dart';

class FillYourProfile extends StatelessWidget {
  const FillYourProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleTextStyle: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.black),
        title: const Text('Fill Your Profile'),
      ),
      body: Column(
        children: [
          circleProfile()
        ],
      ),
    );
  }
}
