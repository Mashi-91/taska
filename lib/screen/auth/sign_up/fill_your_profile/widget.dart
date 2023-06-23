import 'package:flutter/material.dart';
import 'package:taska/constant/color.dart';

Widget circleProfile() {
  return Center(
    child: Stack(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: Colors.grey.withOpacity(0.2)),
        ),
        Positioned(
          bottom: 0,
          right: 5,
          child: Container(
            height: 25,
            width: 25,
            decoration:
                BoxDecoration(shape: BoxShape.rectangle, color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(6)),
            child: Icon(
              Icons.edit_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        )
      ],
    ),
  );
}
