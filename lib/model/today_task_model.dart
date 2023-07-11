class TodayTaskModel {
  final String? id;
  final String title;
  final String currentTime;
  final Function onTap;

  TodayTaskModel({
    this.id,
    required this.title,
    required this.currentTime,
    required this.onTap,
  });

  toJson() => {
        'id': id,
        'title': title,
        'currentTime': currentTime,
        'onTap': onTap,
      };
}
