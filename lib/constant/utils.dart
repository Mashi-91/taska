import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../screen/navigation_tabs/project/project_Detail.dart';
import 'color.dart';

//<<<<<<<<<<<<<<<<<< Get DateTime >>>>>>>>>>>>>>>>>>>

DateFormat getCurrentTime() {
  final time = DateTime.now();
  return DateFormat.jm(time);
}

//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< IconButton >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

Padding iconButton(
    {required Widget icon, required Function onTap, EdgeInsets? margin}) {
  return Padding(
    padding: margin ?? EdgeInsets.zero,
    child: InkWell(
      onTap: () => onTap(),
      child: icon,
    ),
  );
}

//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< LoadingIndicator >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

customLoadingIndicator(BuildContext context,
    {Color color = primaryColor, double size = 50, isShowDialog = false}) {
  showDialog(
    context: context,
    builder: (context) => Center(
        child: LoadingAnimationWidget.stretchedDots(color: color, size: size)),
  );
}

customLoadingIndicator2({Color color = primaryColor, double size = 50}) {
  Center(child: LoadingAnimationWidget.stretchedDots(color: color, size: size));
}

//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< PopMenuItem >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

enum ProjectDetailOptions {
  ChangeCover,
  ChangeLogo,
  ChangeColor,
  EditProject,
  DeleteProject,
}

enum ProjectTitleOptions {
  AddCover,
  AddLogo,
  AddColor,
  EditProject,
  DeleteProject,
}

PopupMenuItem buildPopMenuItem({
  required String title,
  required dynamic value,
  required dynamic iconData,
  Color? color,
  bool isDivider = true,
  bool isSvgIcon = false,
}) {
  return PopupMenuItem(
    value: value,
    padding: EdgeInsets.zero,
    height: 0,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2)
              .copyWith(bottom: !isDivider ? 8 : 0),
          child: Row(
            children: [
              const SizedBox(width: 8),
              isSvgIcon
                  ? SvgToIcon(
                      iconName: iconData,
                      height: 16,
                      padding: const EdgeInsets.only(left: 2),
                    )
                  : Icon(
                      iconData,
                      color: color,
                    ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(fontSize: 14, color: color),
              ),
            ],
          ),
        ),
        isDivider
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.0),
                child: Divider(),
              )
            : Container(),
      ],
    ),
  );
}

//<<<<<<<<<<<<<<<<< PopMenuButton >>>>>>>>>>>>>>>>>>>>>

PopupMenuButton buildPopMenuButton(BuildContext context,
    {required List<PopupMenuItem> popMenuItem,
    Color? color,
    required Function(dynamic) onSelected}) {
  return PopupMenuButton(
    icon: Icon(Icons.pending_outlined, color: color ?? primaryColor),
    padding: const EdgeInsets.only(right: 12),
    onSelected: (val) => onSelected(val),
    position: PopupMenuPosition.under,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12).copyWith(topRight: Radius.zero),
    ),
    itemBuilder: (context) => popMenuItem,
  );
}

//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

AppBar customAppbar(
    {String title = "",
    isGoBack = false,
    Function?  backButton,
    Color? backgroundColor,
    Color? color = Colors.black,
    List<Widget>? actions}) {
  return AppBar(
    elevation: 0,
    backgroundColor: backgroundColor,
    leading: isGoBack
        ? InkWell(
            onTap: () => Get.back(),
            child: Icon(
              Icons.arrow_back,
              color: color,
            ),
          )
        : null,
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
            boxShadow: [
              isEnable
                  ? BoxShadow(
                      offset: const Offset(0, 2),
                      spreadRadius: 0.1,
                      blurRadius: 12,
                      color: isSkip
                          ? Colors.transparent
                          : Colors.blueAccent.withOpacity(0.7))
                  : const BoxShadow(color: transparent)
            ],
            color: isSkip
                ? transparent
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
      this.addIcon = true,
      required this.func,
      this.borderWidth});

  final String buttonText;
  final bool isEnable;
  final bool addIcon;
  final double width;
  final double height;
  final double? borderWidth;
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
            border: Border.all(color: primaryColor, width: borderWidth ?? 3)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            addIcon
                ? const Icon(FluentIcons.add_square_16_regular)
                : Container(),
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
  SvgToIcon(
      {super.key,
      required this.iconName,
      this.color,
      this.padding,
      this.height});

  final String iconName;
  EdgeInsets? padding;
  final Color? color;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: SvgPicture.asset(
        "assets/icons/$iconName.svg",
        color: color,
        height: height ?? 20,
      ),
    );
  }
}

//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

class CustomFloatingButton extends StatelessWidget {
  const CustomFloatingButton(
      {super.key,
      required this.onTap,
      this.height,
      this.width,
      this.bottom,
      this.right});

  final Function onTap;
  final double? height;
  final double? width;
  final double? bottom;
  final double? right;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        height: height ?? 44,
        width: width ?? 44,
        alignment: Alignment.center,
        margin:
            EdgeInsets.only(top: 58, bottom: bottom ?? 0, right: right ?? 0),
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
  CustomDivider({super.key, this.height = 4, this.width = 46, this.color});

  final double height;
  final double width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color ?? Colors.grey.withOpacity(0.7),
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
}

//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

class CustomDateTimePicker extends StatelessWidget {
  const CustomDateTimePicker(
      {super.key,
      this.color,
      this.startDate,
      this.currentDate,
      this.lastDate,
      required this.onDateChanged,
      this.setDate});

  final Color? color;
  final DateTime? startDate;
  final DateTime? currentDate;
  final DateTime? lastDate;
  final DateTime? setDate;
  final Function(DateTime) onDateChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: color ?? Colors.blue.shade50.withOpacity(0.7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: CalendarDatePicker(
        initialDate: startDate ?? DateTime.now(),
        firstDate: currentDate ?? DateTime.now(),
        lastDate: lastDate ?? DateTime(2100),
        onDateChanged: (val) => onDateChanged(val),
        initialCalendarMode: DatePickerMode.day,
        currentDate: setDate,
      ),
    );
  }
}
