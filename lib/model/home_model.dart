class HomeModel {
  final String? id;
  final String? homeImg;
  final String title;
  final String subTitle;
  final Function onPress;
  final String? progress;

  HomeModel({
    this.id,
    this.homeImg = 'assets/images/home_1_image.jpg',
    required this.title,
    required this.subTitle,
    required this.onPress,
    this.progress = "80 / 90",
  });

  toJson() => {
        'id': id,
        'homeImg': homeImg,
        'title': title,
        'subTitle': subTitle,
        'onPress': onPress,
        'progress': progress,
      };
}
