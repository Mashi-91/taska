import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taska/constant/color.dart';
import 'package:taska/constant/utils.dart';
import 'package:taska/screen/global_controller.dart';

class NewProject extends StatelessWidget {
  const NewProject({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GlobalController>();
    return Scaffold(
      appBar: customAppbar(
          backgroundColor: lightGrey_2,
          isGoBack: true,
          color: primaryColor,
          actions: [
            iconButton(
              onTap: () {},
              icon: const Icon(
                Icons.search_outlined,
                color: primaryColor,
              ),
            ),
            const SizedBox(width: 20),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: iconButton(
                onTap: () {},
                icon: const Icon(
                  Icons.pending_outlined,
                  color: primaryColor,
                ),
              ),
            ),
          ]),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          Flexible(
            child: Container(
              color: lightGrey_2,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned(
                    bottom: 20,
                    left: 22,
                    child: iconButton(
                      onTap: () {},
                      icon: const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          FluentIcons.edit_16_filled,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Text(controller.items.map((e) => e).toString()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
