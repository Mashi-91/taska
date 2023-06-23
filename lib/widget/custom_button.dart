import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taska/constant/color.dart';

class CustomButton extends StatelessWidget {
  CustomButton(
      {super.key,
      required this.buttonText,
      this.isSkip = false,
      this.width = 324,
      this.height = 50,
        this.isDisable = true,
      required this.func});

  final String buttonText;
  bool isSkip;
  bool isDisable;
  double width;
  double height;
  final VoidCallback func;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: func,
      child: Container(
        alignment: Alignment.center,
        width: width,
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: isSkip ? Colors.blue.withOpacity(0.1) : isDisable ? disabledButtonColor : primaryColor
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            color: isSkip ? primaryColor : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
