class TaskModel {
  int? id;
  String title;
  String deadline;
  double progress;
  String status;
  int color;

  TaskModel({
    this.id,
    required this.title,
    required this.deadline,
    required this.progress,
    required this.status,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "deadline": deadline,
      "progress": progress,
      "status": status,
      "color": color,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map["id"],
      title: map["title"],
      deadline: map["deadline"],
      progress: map["progress"],
      status: map["status"],
      color: map["color"],
    );
  }
}