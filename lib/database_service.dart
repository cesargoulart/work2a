// lib/database_service.dart
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'models/task_data.dart';

class DatabaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  Timer? _debounceTimer;

  // Save dropdown items
  Future<void> saveDropdownItems({
    required List<String> items,
    required String dropdownId,
  }) async {
    try {
      await _database.child('dropdowns').child(dropdownId).set(items);
    } catch (e) {
      print('Error saving dropdown items: $e');
      rethrow;
    }
  }

  // Load dropdown items
  Future<List<String>> loadDropdownItems(String dropdownId) async {
    try {
      final snapshot = await _database.child('dropdowns').child(dropdownId).get();
      if (snapshot.exists) {
        final List<dynamic> data = snapshot.value as List<dynamic>;
        return data.map((item) => item.toString()).toList();
      }
      return [];
    } catch (e) {
      print('Error loading dropdown items: $e');
      return [];
    }
  }

  // Save tasks
Future<void> saveTasks(Map<String, TaskData> tasks) async {
  if (_debounceTimer?.isActive ?? false) {
    _debounceTimer?.cancel();
  }

  _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
    print('Saving tasks...');
    try {
      final Map<String, dynamic> tasksMap = {};
      tasks.forEach((key, value) {
        tasksMap[key] = value.toJson();
      });
      await _database.child('tasks').set(tasksMap);
      print('Tasks saved successfully.');
    } catch (e) {
      print('Error saving tasks: $e');
      rethrow;
    }
  });
}

  // Load tasks
  Future<Map<String, TaskData>> loadTasks() async {
    try {
      final snapshot = await _database.child('tasks').get();
      if (snapshot.exists) {
        final Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        final Map<String, TaskData> tasks = {};
        
        data.forEach((key, value) {
          tasks[key.toString()] = TaskData.fromJson(Map<String, dynamic>.from(value));
        });
        return tasks;
      }
      return {};
    } catch (e) {
      print('Error loading tasks: $e');
      return {};
    }
  }

  // Listen to tasks changes
  Stream<Map<String, TaskData>> tasksStream() {
    return _database.child('tasks').onValue.map((event) {
      if (event.snapshot.exists) {
        final Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
        final Map<String, TaskData> tasks = {};
        
        data.forEach((key, value) {
          tasks[key.toString()] = TaskData.fromJson(Map<String, dynamic>.from(value));
        });
        return tasks;
      }
      return {};
    });
  }
}
