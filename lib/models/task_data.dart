// lib/models/task_data.dart
class TaskData {
  bool isChecked;
  Map<String, bool> subtasks;
  bool areSubtasksVisible;

  TaskData({
    required this.isChecked,
    required this.subtasks,
    this.areSubtasksVisible = true,
  });

  // Add these methods to help with Firebase
  Map<String, dynamic> toJson() {
    return {
      'isChecked': isChecked,
      'subtasks': subtasks,
      'areSubtasksVisible': areSubtasksVisible,
    };
  }

  static TaskData fromJson(Map<String, dynamic> json) {
    return TaskData(
      isChecked: json['isChecked'] ?? false,
      subtasks: Map<String, bool>.from(json['subtasks'] ?? {}),
      areSubtasksVisible: json['areSubtasksVisible'] ?? true,
    );
  }
}