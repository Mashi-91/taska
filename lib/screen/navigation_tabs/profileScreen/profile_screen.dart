import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:taska/constant/color.dart';
import 'package:taska/constant/utils.dart';
import 'package:taska/routes/export.dart';
import 'package:taska/screen/navigation_tabs/home/homeController.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final currentUser = controller.currentUser;

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
            Text(
              currentUser!.displayName.toString(),
              style: const TextStyle(
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
            const SizedBox(height: 30),
            Column(
              children: [
                Utils.buildCustomRow(
                  iconData: Icons.person_2_outlined,
                  iconColor: ColorsUtil.lightGrey,
                  subTitle: 'Edit Profile',
                  textColor: ColorsUtil.lightBlack,
                ),
                const SizedBox(height: 18),
                Utils.buildCustomRow(
                  iconData: Icons.notifications_none,
                  iconColor: ColorsUtil.lightGrey,
                  subTitle: 'Notifications',
                  textColor: ColorsUtil.lightBlack,
                ),const SizedBox(height: 18),
                Utils.buildCustomRow(
                  iconData: Icons.security_outlined,
                  iconColor: ColorsUtil.lightGrey,
                  subTitle: 'Security',
                  textColor: ColorsUtil.lightBlack,
                ),
                const SizedBox(height: 18),
                Utils.buildCustomRow(
                  iconData: Icons.info_outline,
                  iconColor: ColorsUtil.lightGrey,
                  subTitle: 'Help',
                  textColor: ColorsUtil.lightBlack,
                ),
                const SizedBox(height: 18),
                Utils.buildCustomRow(
                  iconData: Icons.logout_rounded,
                  iconColor: Colors.red,
                  subTitle: 'Log Out',
                  textColor: Colors.red,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
