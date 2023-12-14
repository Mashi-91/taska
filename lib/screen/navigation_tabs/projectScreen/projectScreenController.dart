import 'package:get/get.dart';
import 'package:taska/screen/global_controller.dart';

class ProjectScreenController extends GlobalController {
  RxBool isCover = false.obs;

  void isCoverFunc() {
    isCover.value = !isCover.value;
  }
}
