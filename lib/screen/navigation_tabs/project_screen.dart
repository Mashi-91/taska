import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import 'home/widget.dart';

class ProjectScreen extends StatelessWidget {
  const ProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: homeAppBar(
        title: 'My Project',
        action: Row(
          children: [
            Icon(FluentIcons.search_20_regular),

          ],
        ),
      ),
    ));
  }
}
