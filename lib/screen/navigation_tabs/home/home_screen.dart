import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:taska/constant/color.dart';
import 'package:taska/routes/appRoutes.dart';
import 'package:taska/screen/navigation_tabs/home/widget.dart';

import '../../../constant/utils.dart';
import 'homeController.dart';
import '../project/widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Scaffold(
      appBar: AppBar(
        title: homeAppBar(
          action: const Icon(
            FluentIcons.alert_12_filled,
            color: ColorsUtil.primaryColor,
          ),
        ),
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
                  Utils.buildCustomTextField(
                    controller: controller.searchController,
                    hintText: 'Search',
                    prefixIcon: const Icon(
                      FluentIcons.search_20_filled,
                      color: ColorsUtil.lightGrey,
                    ),
                    suffixIcon: const Icon(
                      FluentIcons.options_16_regular,
                      color: ColorsUtil.primaryColor,
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
                        onTap: () => Get.toNamed(AppRoutes.seeAllScreen),
                        child: const Text(
                          'See All',
                          style: TextStyle(
                              color: ColorsUtil.primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 280,
              child: StreamBuilder(
                  stream: controller.getAllProjects(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: LoadingAnimationWidget.stretchedDots(
                            color: ColorsUtil.primaryColor, size: 20),
                      );
                    } else if (snapshot.hasData) {
                      final List<QueryDocumentSnapshot>? project =
                          snapshot.data?.docs;
                      return project == null || project.isEmpty
                          ? SvgPicture.asset('assets/images/Empty-img.svg')
                          : CarouselSlider.builder(
                              itemCount: project.take(2).length,
                              itemBuilder: (_, i, val) {
                                return projectCardWithImg(
                                  imageProvider: project[i]['cover'] != ''
                                      ? CachedNetworkImageProvider(
                                          Uri.parse(project[i]['cover'])
                                              .toString())
                                      : AssetImage(
                                          project[i]['backgroundCover']),
                                  title: project[i]['title'] ?? '',
                                  subTitle: 'subTitle',
                                  onTapOption: () {
                                    Get.toNamed(AppRoutes.projectDetail,
                                        arguments: project[i].data());
                                  },
                                  leftTask: '1',
                                  totalTask: '',
                                  dateLeft: '',
                                  timeLeft: '',
                                );
                              },
                              options: CarouselOptions(
                                height: Get.height * 0.34,
                                viewportFraction: 0.93,
                                enableInfiniteScroll: false,
                                enlargeCenterPage: true,
                                disableCenter: false,
                              ),
                            );
                    }
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }),
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
                              color: ColorsUtil.primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 200,
                    child: /*GetX<GlobalController>(
                      init: Get.put(GlobalController()),
                      builder: (GlobalController globalController) {
                        return ListView.builder(itemBuilder: (_, i) {
                          return taskTile(
                              taskModel: TodayTaskModel(
                                  title: globalController.taskData[i].title,
                                  id:
                                      globalController.taskData[i].dateCreated,
                                  isDone:
                                      globalController.taskData[i].isDone));
                        });
                      },
                    )*/
                        SvgPicture.asset('assets/images/Empty-img.svg'),
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
