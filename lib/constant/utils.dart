import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'color.dart';

class Utils {
  //<<<<<<<<<<<<<<<<<< Get DateTime >>>>>>>>>>>>>>>>>>>

  static DateFormat getCurrentTime() {
    final time = DateTime.now();
    return DateFormat.jm(time);
  }

//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< IconButton >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  static Padding iconButton(
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

  static customLoadingIndicator(BuildContext context,
      {Color color = ColorsUtil.primaryColor,
      double size = 50,
      isShowDialog = false}) {
    showDialog(
      context: context,
      builder: (context) => Center(
          child:
              LoadingAnimationWidget.stretchedDots(color: color, size: size)),
    );
  }

  static customLoadingIndicator2(
      {Color color = ColorsUtil.primaryColor, double size = 50}) {
    Center(
        child: LoadingAnimationWidget.stretchedDots(color: color, size: size));
  }

//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< PopMenuItem >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  static PopupMenuItem buildPopMenuItem({
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
                    ? buildSvgToIcon(
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

  static PopupMenuButton buildPopMenuButton(BuildContext context,
      {required List<PopupMenuItem> popMenuItem,
      Color? color,
      required Function(dynamic) onSelected}) {
    return PopupMenuButton(
      icon:
          Icon(Icons.pending_outlined, color: color ?? ColorsUtil.primaryColor),
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

  static AppBar customAppbar(
      {String title = "",
      isGoBack = false,
      Function? backButton,
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

  static AppBar customAppbarForProjectScreen(
      {String title = "",
      Function? backButton,
      Color? backgroundColor,
      Color? color = Colors.black,
      PreferredSizeWidget? bottom,
      List<Widget>? actions}) {
    return AppBar(
      leadingWidth: Get.width * 0.12,
      leading: Container(
        width: 40,
        height: 40,
        margin: EdgeInsets.only(left: Get.width * 0.04),
        child: SvgPicture.asset(
          "assets/icons/app-logo.svg",
        ),
      ),
      title: Text(
        title,
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
      actions: actions,
      bottom: bottom,
    );
  }

  //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  static Widget buildCustomButton({
    required String buttonText,
    bool isSkip = false,
    bool isEnable = false,
    double width = 324,
    double height = 50,
    required VoidCallback func,
  }) {
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
                : const BoxShadow(color: ColorsUtil.transparent)
          ],
          color: isSkip
              ? ColorsUtil.transparent
              : isEnable
                  ? ColorsUtil.primaryColor
                  : ColorsUtil.disabledButtonColor,
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            color: isSkip ? ColorsUtil.primaryColor : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  static Widget buildCustomOutlineButton({
    required String buttonText,
    bool isEnable = false,
    bool addIcon = true,
    double width = 324,
    double height = 50,
    required VoidCallback func,
    double? borderWidth,
  }) {
    return InkWell(
      onTap: isEnable ? func : null,
      child: Container(
        alignment: Alignment.center,
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
              color: ColorsUtil.primaryColor, width: borderWidth ?? 3),
        ),
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
                color: ColorsUtil.primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildCustomTextField({
    Key? key,
    required TextEditingController controller,
    required String hintText,
    bool obsecure = false,
    Widget? prefixIcon,
    Widget? suffixIcon,
    double? verticalPadding,
    double? horizontalPadding,
    Color? color,
    /*Function(String)? onChanged,*/
  }) {
    return TextFormField(
      key: key,
      controller: controller,
      obscureText: obsecure,
      cursorColor: Colors.grey.withOpacity(0.1),
      /*onChanged: onChanged,*/
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

  static Widget buildSvgToIcon({
    Key? key,
    required String iconName,
    Color? color,
    EdgeInsets? padding,
    double? height,
  }) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: SvgPicture.asset(
        "assets/icons/$iconName.svg",
        color: color,
        height: height ?? 20,
      ),
    );
  }

  static double calculateLinePercentage(int completedTasks, int totalTasks) {
    if (totalTasks == 0) {
      return 0.0; // To avoid division by zero
    }
    return completedTasks / totalTasks;
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  static Widget buildCustomFloatingButton({
    Key? key,
    required VoidCallback onTap,
    double? height,
    double? width,
    double? bottom,
    double? right,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height ?? 44,
        width: width ?? 44,
        alignment: Alignment.center,
        margin:
            EdgeInsets.only(bottom: bottom ?? 0, right: right ?? 0),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: ColorsUtil.primaryColor,
        ),
        child: const Icon(
          FluentIcons.add_48_filled,
          size: 20,
          color: Colors.white,
        ),
      ),
    );
  }

  static Future setCustomToken({required String tokenKey, required String tokenValue}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(tokenKey, tokenValue);
  }

  static String formatTaskTime(DateTime time) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(const Duration(days: 1));

    if (time.isAfter(today)) {
      return 'Today ${DateFormat.jmz().format(time)}';
    } else if (time.isAfter(yesterday)) {
      return 'Yesterday ${DateFormat.jmz().format(time)}';
    } else {
      return DateFormat.yMd().add_jm().format(time);
    }
  }

  static Widget buildCustomDivider({
    Key? key,
    double height = 4,
    double width = 46,
    Color? color,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color ?? Colors.grey.withOpacity(0.7),
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }

  static Widget buildCustomDateTimePicker({
    Key? key,
    Color? color,
    DateTime? startDate,
    DateTime? currentDate,
    DateTime? lastDate,
    required Function(DateTime) onDateChanged,
    DateTime? setDate,
  }) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: color ?? Colors.blue.shade50.withOpacity(0.7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: CalendarDatePicker(
        key: key,
        initialDate: startDate ?? DateTime.now(),
        firstDate: currentDate ?? DateTime.now(),
        lastDate: lastDate ?? DateTime(2100),
        onDateChanged: onDateChanged,
        initialCalendarMode: DatePickerMode.day,
        currentDate: setDate,
      ),
    );
  }

  static snackBarMsg(
      {
      Widget? titleWidget,
      required String msg,
      bool isError = false,
      SnackPosition? snackPosition = SnackPosition.BOTTOM}) {
    return Get.rawSnackbar(
        messageText: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(msg,
              style: const TextStyle(color: Colors.white, fontSize: 18)),
        ),
        isDismissible: false,
        duration: const Duration(seconds: 3),
        backgroundColor: ColorsUtil.primaryColor,
        icon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: titleWidget ??
              const Icon(
                Icons.error,
                color: Colors.white,
                size: 30,
              ),
        ),
        margin: EdgeInsets.zero,
        snackStyle: SnackStyle.GROUNDED);
  }

  static customCheckBox() {
    return Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
        color: ColorsUtil.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Icon(
        FontAwesomeIcons.check,
        color: ColorsUtil.primaryColor,
        size: 12,
      ),
    );
  }

  static int calculateDaysLeftUntilDeadline(String deadlineDateString) {
    DateTime deadlineDate = DateFormat('MMM d yyyy').parse(deadlineDateString);
    DateTime now = DateTime.now();

    Duration difference = deadlineDate.difference(now);
    int daysDifference = difference.inDays;

    return daysDifference;
  }

  static final List<Color> staticColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.indigo,
    Colors.pink,
    Colors.amber,
    Colors.cyan,
    Colors.deepPurple,
    Colors.lime,
    Colors.lightBlue,
  ];
}
