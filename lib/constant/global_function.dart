//<<<<<<<<<<<<<< GlobalFunction >>>>>>>>>>>>>>>>>>>>>>>>>>>>>

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class GlobalFunction {
  static phoneFormat(String enterPhoneNumber) {
    return enterPhoneNumber.replaceRange(3, 9, "****");
  }

  static emailFormat(String enterEmail) {
    return enterEmail.replaceRange(
        0, "example@gmail.com".indexOf("@") - 3, "****");
  }

// Function to convert Color to Hexadecimal String
  static String convertColorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  // Function to convert Hexadecimal String to Color
  static Color convertHexToColor(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  // Function to convert Hexadecimal String to MaterialColor
  static MaterialColor? convertHexToMaterialColor(String? hexColor) {
    if (hexColor == null || hexColor.isEmpty) {
      return null;
    }

    hexColor = hexColor.toUpperCase().replaceAll('#', '');

    if (hexColor.length != 6) {
      return null; // Invalid hex color
    }

    int parsedColor = int.tryParse('FF$hexColor', radix: 16) ?? 0xFFFFFFFF;
    return MaterialColor(parsedColor, {
      50: Color(parsedColor).withOpacity(0.1),
      100: Color(parsedColor).withOpacity(0.2),
      200: Color(parsedColor).withOpacity(0.3),
      300: Color(parsedColor).withOpacity(0.4),
      400: Color(parsedColor).withOpacity(0.5),
      500: Color(parsedColor).withOpacity(0.6),
      600: Color(parsedColor).withOpacity(0.7),
      700: Color(parsedColor).withOpacity(0.8),
      800: Color(parsedColor).withOpacity(0.9),
      900: Color(parsedColor).withOpacity(1),
    });
  }

  // Function to convert MaterialColor to Hexadecimal String
  static String convertMaterialColorToHex(MaterialColor color) {
    int primaryColorValue = color[500]!.value;
    return '#${primaryColorValue.toRadixString(16).padLeft(8, '0').substring(2)}'
        .toLowerCase();
  }

  static String formatDeadline(String deadLine) {
    try {
      if (deadLine.isNotEmpty) {
        DateTime originalDeadline = DateFormat('yyyy-MM-dd').parse(deadLine);
        return DateFormat('MMM dd yyyy').format(originalDeadline);
      } else {
        log('Empty deadline string');
        return 'Empty deadline string';
      }
    } catch (e) {
      log('Error parsing deadline: $e');
      return 'Error parsing deadline';
    }
  }

  static String calculateTimeLeft(String deadLine) {
    DateTime deadlineDate;

    try {
      if (deadLine.isNotEmpty) {
        deadlineDate =
            DateFormat('yyyy-MM-dd HH:mm:ss').parse('$deadLine 23:59:59');
        DateTime now = DateTime.now();
        if (deadlineDate.isAfter(now)) {
          Duration difference = deadlineDate.difference(now);

          if (deadlineDate.day == now.day) {
            // If the deadline is today, show hours instead of days
            int hoursLeft = difference.inHours;
            return '$hoursLeft hours left';
          } else {
            int daysLeft = difference.inDays;
            return '$daysLeft days left';
          }
        } else {
          log('Deadline has passed');
          return 'Deadline has passed';
        }
      } else {
        return 'Empty deadline string';
      }
    } catch (e) {
      Logger().e('Error parsing deadline: $e');
      return 'Error parsing deadline';
    }
  }

  static String splashScreenPage1Description =
      'Organizing tasks and projects is essential for maintaining productivity, meeting deadlines, and reducing stress.';

  static String dummyPhoneNumber = "+918178030005";
  static String dummyEmail = "mashi@gmail.com";
}

enum ProjectDetailOptions {
  ChangeCover,
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
