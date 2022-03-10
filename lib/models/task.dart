class Task {
  int? id;
  String? title;
  String? description;
  DateTime? time;

  Task(this.title, this.description, this.time);

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      "title": title,
      "description": description,
      "time": time?.toIso8601String()
    };
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  Task.fromMap(Map<String, Object?> map) {
    id = (map["id"] as int?)!;
    title = (map["title"] as String?)!;
    description = (map["description"] as String?)!;
    time = (map["time"] as DateTime?)!;
  }

  static List<Task> myTasks = [
    Task("task 1", "desc 1", DateTime(1, 1, 1)),
    Task("task 2", "desc 2", DateTime(1, 1, 1)),
    Task("task 3", "desc 3", DateTime(1, 1, 1)),
    Task("task 4", "desc 4", DateTime(1, 1, 1)),
    Task("task 5", "desc 5", DateTime(1, 1, 1)),
  ];
}