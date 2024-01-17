import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:taska/constant/color.dart';
import 'package:taska/constant/utils.dart';
import 'package:taska/routes/appRoutes.dart';
import 'package:taska/screen/navigation_tabs/project/widget.dart';
import 'package:taska/screen/navigation_tabs/projectScreen/projectScreenController.dart';

class ProjectScreen extends StatelessWidget {
  const ProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProjectScreenController());
    return Obx(
      () => DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: Utils.customAppbarForProjectScreen(
            title: 'My Project',
            actions: [
              InkWell(
                splashColor: Colors.transparent,
                onTap: () => controller.isCoverFunc(),
                child: const Icon(
                  FluentIcons.search_32_regular,
                  size: 23,
                ),
              ),
              SizedBox(
                width: Get.width * 0.03,
              ),
              InkWell(
                splashColor: Colors.transparent,
                onTap: () => controller.isCoverFunc(),
                child: controller.isCover.value
                    ? const Icon(
                        FluentIcons.image_16_regular,
                        size: 26,
                      )
                    : const Icon(
                        FluentIcons.image_16_filled,
                        size: 26,
                        color: ColorsUtil.primaryColor,
                      ),
              ),
              InkWell(
                splashColor: Colors.transparent,
                onTap: () => controller.isCoverFunc(),
                child: !controller.isCover.value
                    ? Utils.buildSvgToIcon(
                        iconName: 'project-regular-icon',
                        color: Colors.black,
                        height: 18,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      )
                    : Utils.buildSvgToIcon(
                        iconName: 'project-filled-icon',
                        height: 18,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: ButtonsTabBar(
                backgroundColor: ColorsUtil.primaryColor,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: Get.width * 0.06),
                onTap: (val) {},
                unselectedBorderColor: ColorsUtil.primaryColor,
                borderColor: ColorsUtil.primaryColor,
                borderWidth: 2,
                radius: 20,
                unselectedBackgroundColor: Colors.transparent,
                unselectedLabelStyle:
                    const TextStyle(color: ColorsUtil.primaryColor),
                labelStyle: const TextStyle(color: ColorsUtil.white),
                tabs: const [
                  Tab(
                    text: 'To-Do',
                  ),
                  Tab(
                    text: 'In Progress',
                  ),
                  Tab(
                    text: 'Completed',
                  ),
                  Tab(
                    text: 'Archived',
                  ),
                ],
                // controller: _tabController,
              ),
            ),
          ),
          body: StreamBuilder(
            stream: controller.getAllProjects(),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: LoadingAnimationWidget.stretchedDots(
                      color: ColorsUtil.primaryColor, size: 40),
                );
              }
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: data?.length ?? 0,
                  itemBuilder: (context, i) {
                    if (data == null || data.isEmpty) {
                      return const Center(child: Text('No Data Found'));
                    }

                    final projects = data?[i].data();
                    if (projects == null) {
                      return const SizedBox
                          .shrink(); // or handle the case when projects is null
                    }

                    final title = projects['title'] ?? '';
                    final tag = title;

                    return controller.isCover.value
                        ? Material(
                            child: Hero(
                              tag: tag,
                              child: projectCardWithoutImg(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                title: title,
                                subTitle: 'subTitle',
                                onTapOption: () => Get.toNamed(
                                    AppRoutes.projectDetail,
                                    arguments: data[i].data()),
                                timeLeft: '1',
                                totalTask: data!.length.toString(),
                                dateLeft: '',
                                leftTask: '',
                              ),
                            ),
                          )
                        : Material(
                            child: Hero(
                              tag: tag,
                              child: projectCardWithImg(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                imageProvider: projects['cover'] != ''
                                    ? CachedNetworkImageProvider(
                                        Uri.parse(projects['cover']).toString())
                                    : AssetImage(projects['backgroundCover']),
                                title: title,
                                subTitle: 'subTitle',
                                onTapOption: () => Get.toNamed(
                                    AppRoutes.projectDetail,
                                    arguments: data[i].data()),
                                leftTask: '1',
                                totalTask: '1',
                                deadLine: '',
                              ),
                            ),
                          );
                  },
                );
              }
              return const Center(child: Text('No Data Found'));
            },
          ),
        ),
      ),
    );
  }

// Widget bodySection(){
//   return
// }
}
