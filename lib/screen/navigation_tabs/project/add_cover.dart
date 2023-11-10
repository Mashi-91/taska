import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import '../../../constant/utils.dart';

class AddCover extends StatelessWidget {
  const AddCover({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(title: 'Add Cover', isGoBack: true, actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(FluentIcons.edit_48_regular),
        )
      ]),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                        image: AssetImage('assets/images/home_1_image.jpg'),
                        fit: BoxFit.cover)),
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              buttonText: 'Add Cover',
              func: () {},
              width: double.infinity,
            )
          ],
        ),
      ),
    );
  }
}
