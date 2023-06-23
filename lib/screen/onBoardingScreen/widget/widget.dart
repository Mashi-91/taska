import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../main.dart';

class CustomPageView extends StatelessWidget {
  const CustomPageView(
      {super.key,
      required this.size,
      required this.imgPath,
      required this.title,
      required this.description});

  final Size size;
  final String imgPath;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.09),
      child: Column(
        children: [
          Image.asset('assets/images/$imgPath', width: 280, height: 280),
          SizedBox(height: size.height * 0.07),
          SizedBox(
            width: 278,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 300,
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
