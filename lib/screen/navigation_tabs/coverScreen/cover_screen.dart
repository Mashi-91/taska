import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:taska/constant/color.dart';
import 'package:taska/constant/utils.dart';
import 'package:taska/routes/appRoutes.dart';
import 'package:taska/screen/navigation_tabs/project/widget.dart';
import 'package:taska/screen/navigation_tabs/projectScreen/projectScreenController.dart';

class CoverScreen extends StatelessWidget {
  const CoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProjectScreenController());
    return Scaffold(
      appBar: Utils.customAppbarForProjectScreen(
        title: 'Cover',
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

                return Material(
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
                      onTapOption: () => Get.toNamed(AppRoutes.projectDetail,
                          arguments: data[i].data()),
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
    );
  }

// Widget bodySection(){
//   return
// }
}
