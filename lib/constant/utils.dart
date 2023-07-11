import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'color.dart';

//<<<<<<<<<<<<<<<<<< Get DateTime >>>>>>>>>>>>>>>>>>>

DateFormat getCurrentTime() {
  final time = DateTime.now();
  return DateFormat.jm(time);
}

//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< IconButton >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

InkWell iconButton({required Widget icon, required Function onTap}) {
  return InkWell(
    onTap: () => onTap(),
    child: icon,
  );
}

//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

AppBar customAppbar(
    {String title = "",
    isGoBack = false,
    Color? backgroundColor,
    color = Colors.black,
    List<Widget>? actions}) {
  return AppBar(
    elevation: 0,
    backgroundColor: backgroundColor,
    leading: InkWell(
      onTap: isGoBack ? () => Get.back() : null,
      child: isGoBack
          ? Icon(
              Icons.arrow_back,
              color: color,
            )
          : null,
    ),
    titleTextStyle: const TextStyle(
        fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
    title: Text(title),
    actions: actions,
  );
}
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.buttonText,
      this.isSkip = false,
      this.width = 324,
      this.height = 50,
      this.isEnable = false,
      required this.func});

  final String buttonText;
  final bool isSkip;
  final bool isEnable;
  final double width;
  final double height;
  final VoidCallback func;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isEnable ? func : null,
      child: Container(
        alignment: Alignment.center,
        width: width,
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: isSkip
                ? Colors.blue.withOpacity(0.1)
                : isEnable
                    ? primaryColor
                    : disabledButtonColor),
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

//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

class CustomOutlineButton extends StatelessWidget {
  const CustomOutlineButton(
      {super.key,
      required this.buttonText,
      this.width = 324,
      this.height = 50,
      this.isEnable = false,
      required this.func});

  final String buttonText;
  final bool isEnable;
  final double width;
  final double height;
  final VoidCallback func;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isEnable ? func : null,
      child: Container(
        alignment: Alignment.center,
        width: width,
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: primaryColor, width: 3)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(FluentIcons.add_square_16_regular),
            const SizedBox(width: 8),
            Text(
              buttonText,
              style: const TextStyle(
                color: primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
class customTextField extends StatelessWidget {
  customTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obsecure = false,
    this.prefixIcon,
    this.suffixIcon,
    this.verticalPadding,
    this.horizontalPadding,
    this.color,
    /*this.onChanged*/
  });

  final TextEditingController controller;
  bool obsecure;
  final String hintText;
  Widget? suffixIcon;
  Widget? prefixIcon;
  double? verticalPadding;
  double? horizontalPadding;
  Color? color;

  // final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obsecure,
      cursorColor: Colors.grey.withOpacity(0.1),
      // onChanged: (val) => onChanged!(val),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
            vertical: verticalPadding ?? 12,
            horizontal: horizontalPadding ?? 0),
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintStyle: TextStyle(color: Colors.grey.withOpacity(0.7)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
        filled: true,
        fillColor: color ?? Colors.grey.withOpacity(0.1),
      ),
    );
  }
}

//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

class SvgToIcon extends StatelessWidget {
  const SvgToIcon({super.key, required this.icon, this.color});

  final String icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      "assets/icons/$icon.svg",
      color: color,
      height: 20,
    );
  }
}

//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

class taskButton extends StatelessWidget {
  const taskButton({super.key, required this.onTap});

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        height: 44,
        width: 44,
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 58),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: primaryColor,
        ),
        child: const Icon(
          FluentIcons.add_48_filled,
          size: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}

//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

class CustomDivider extends StatelessWidget {
  const CustomDivider(
      {super.key, this.height = 4, this.width = 46, this.color = Colors.grey});

  final double height;
  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
}
