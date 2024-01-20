import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:taska/constant/color.dart';
import 'package:taska/constant/utils.dart';
import 'package:taska/routes/export.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Utils.customAppbarForProjectScreen(title: 'Profile'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Align(
              alignment: Alignment.topCenter,
              child: CircleAvatar(
                radius: 50,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Daniel Austin',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              '@Deaniel',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w100,
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.topLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Utils.buildCustomColumn(title: '27', subTitle: 'Projects'),
                  Container(
                    color: ColorsUtil.lightGrey,
                    height: 50,
                    width: 2,
                  ),
                  Utils.buildCustomColumn(title: '274', subTitle: 'Tasks'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Utils.buildCustomDivider(
                width: Get.width, height: 2, color: ColorsUtil.lightGrey),
            const SizedBox(height: 20),
            Column(
              children: [
                Utils.buildCustomRow(title: 'title', subTitle: 'Edit Profile'),
                Utils.buildCustomRow(title: 'title', subTitle: 'Log Out'),
              ],
            )
          ],
        ),
      ),
    );
  }
}
