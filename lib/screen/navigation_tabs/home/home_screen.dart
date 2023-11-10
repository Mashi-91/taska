import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:taska/constant/color.dart';
import 'package:taska/constant/routes.dart';
import 'package:taska/screen/navigation_tabs/home/widget.dart';

import '../../../constant/utils.dart';
import '../controller.dart';
import '../project/widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
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
                        onTap: () => Get.toNamed(seeAllScreen),
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
            SizedBox(
              height: 280,
              child: StreamBuilder(
                  stream: controller.projectSnapshot,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: LoadingAnimationWidget.stretchedDots(
                            color: primaryColor, size: 20),
                      );
                    } else if (snapshot.hasData) {
                      final project = snapshot.data?.docs;
                      return CarouselSlider.builder(
                        itemCount: project?.take(2).length,
                        itemBuilder: (_, i, val) {
                          return project!.isNotEmpty
                              ? projectCardWithImg(
                                  backGroundImg: project[i]['cover'] ??
                                      Uri.https(
                                          'https://armysportsinstitute.com/wp-content/themes/armysports/images/noimg.png'),
                                  title: project[i]['title'] ?? '',
                                  subTitle: 'subTitle',
                                  onTapOption: () {
                                    Get.toNamed(projectDetail,
                                        arguments: project[i].data());
                                  },
                                  leftTask: '1',
                                  totalTask: '',
                                  dateLeft: '',
                                  timeLeft: '',
                                )
                              : SvgPicture.asset('assets/images/Empty-img.svg');
                        },
                        options: CarouselOptions(
                          height: 320,
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
                              color: primaryColor, fontWeight: FontWeight.bold),
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
