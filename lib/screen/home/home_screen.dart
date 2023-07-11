import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taska/constant/color.dart';
import 'package:taska/model/today_task_model.dart';
import 'package:taska/screen/home/widget.dart';

import '../../constant/utils.dart';
import 'controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Scaffold(
      appBar: AppBar(
        title: homeAppBar(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18).copyWith(top: 12),
              child: Column(
                children: [
                  customTextField(
                    controller: controller.searchController,
                    hintText: 'Search',
                    prefixIcon: const Icon(
                      FluentIcons.search_20_filled,
                      color: lightGrey,
                    ),
                    suffixIcon: const Icon(
                      FluentIcons.options_16_regular,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Project',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      InkWell(
                        onTap: () {},
                        child: const Text(
                          'See All',
                          style: TextStyle(
                              color: primaryColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            CarouselSlider.builder(
              itemCount: controller.items.length,
              itemBuilder: (_, i, val) {
                return projectCard(
                    backGroundImg: controller.items[i].homeImg.toString(),
                    title: controller.items[i].title,
                    subTitle: controller.items[i].subTitle,
                    onTapOption: controller.items[i].onPress,
                    progress: controller.items[i].progress.toString());
              },
              options: CarouselOptions(
                height: 320,
                viewportFraction: 0.93,
                enableInfiniteScroll: false,
                enlargeCenterPage: true,
                disableCenter: false,
              ),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Today Task",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      InkWell(
                        onTap: () {},
                        child: const Text(
                          'See All',
                          style: TextStyle(
                              color: primaryColor, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: 1,
                      itemBuilder: (_, i) {
                        return Obx(
                          () => taskTile(
                            taskModel: TodayTaskModel(
                                title: 'title',
                                currentTime: 'getCurrentTime().toString()',
                                onTap: () {
                                  controller.isTaskComplete();
                                }),
                            val: controller.isTaskValueComplete.value,
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
