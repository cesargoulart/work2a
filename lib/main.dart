import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dropdown_widget.dart';
import 'custom_checkbox.dart';
import 'bottom_buttons.dart';
import 'firebase_config.dart';
import 'database_service.dart';
import 'models/task_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfig.initializeFirebase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DatabaseService _databaseService = DatabaseService();
  List<String> items1 = ['Item 1', 'Item 2', 'Item 3'];
  List<String> items2 = ['Option A', 'Option B', 'Option C'];
  String? selectedItem1;
  String? selectedItem2;
  Map<String, TaskData> tasks = {};

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final dropdownItems1 =
          await _databaseService.loadDropdownItems('dropdown1');
      final dropdownItems2 =
          await _databaseService.loadDropdownItems('dropdown2');
      final savedTasks = await _databaseService.loadTasks();

      setState(() {
        if (dropdownItems1.isNotEmpty) items1 = dropdownItems1;
        if (dropdownItems2.isNotEmpty) items2 = dropdownItems2;
        if (savedTasks.isNotEmpty) tasks = savedTasks;
      });

      _databaseService.tasksStream().listen((updatedTasks) {
        setState(() {
          tasks = updatedTasks;
        });
      });
    } catch (e) {
      print('Error loading initial data: $e');
    }
  }

  void createCheckbox() async {
    if (selectedItem1 != null && selectedItem2 != null) {
      final taskKey = '$selectedItem1 - $selectedItem2';
      print('Creating checkbox with key: $taskKey');
      if (!tasks.containsKey(taskKey)) {
        setState(() {
          tasks[taskKey] = TaskData(
            isChecked: false,
            subtasks: {},
          );
        });

        try {
          await _databaseService.saveTasks(tasks);
          print('Checkbox saved successfully.');
        } catch (e) {
          print('Error saving new checkbox: $e');
        }
      } else {
        print('Task already exists: $taskKey');
      }
    } else {
      print('Selected items are null. Cannot create checkbox.');
    }
  }

  void toggleSubtasksVisibility(String taskKey) async {
    if (tasks.containsKey(taskKey)) {
      setState(() {
        tasks[taskKey]!.areSubtasksVisible =
            !tasks[taskKey]!.areSubtasksVisible;
      });

      try {
        await _databaseService.saveTasks(tasks);
      } catch (e) {
        print('Error saving subtask visibility: $e');
      }
    } else {
      print('Task key not found: $taskKey');
    }
  }

  void addSubtask(String parentKey) async {
    setState(() {
      final subtaskKey =
          '$parentKey-Subtask ${tasks[parentKey]!.subtasks.length + 1}';
      tasks[parentKey]!.subtasks[subtaskKey] = false;
    });

    try {
      await _databaseService.saveTasks(tasks);
    } catch (e) {
      print('Error saving new subtask: $e');
    }
  }

  void deleteTask(String taskKey) async {
    setState(() {
      tasks.remove(taskKey);
    });

    try {
      await _databaseService.saveTasks(tasks);
    } catch (e) {
      print('Error deleting task: $e');
    }
  }

  void updateItems1(List<String> newItems) async {
    try {
      await _databaseService.saveDropdownItems(
        items: newItems,
        dropdownId: 'dropdown1',
      );

      setState(() {
        items1 = List<String>.from(newItems);
        if (selectedItem1 != null && !newItems.contains(selectedItem1)) {
          selectedItem1 = null;
        }

        tasks.removeWhere((key, value) {
          String taskItem1 = key.split(' - ')[0];
          return !newItems.contains(taskItem1);
        });
      });

      await _databaseService.saveTasks(tasks);
    } catch (e) {
      print('Error updating items1: $e');
    }
  }

  void updateItems2(List<String> newItems) async {
    try {
      await _databaseService.saveDropdownItems(
        items: newItems,
        dropdownId: 'dropdown2',
      );

      setState(() {
        items2 = List<String>.from(newItems);
        if (selectedItem2 != null && !newItems.contains(selectedItem2)) {
          selectedItem2 = null;
        }

        tasks.removeWhere((key, value) {
          String taskItem2 = key.split(' - ')[1];
          return !newItems.contains(taskItem2);
        });
      });

      await _databaseService.saveTasks(tasks);
    } catch (e) {
      print('Error updating items2: $e');
    }
  }

  void deleteLastCheckbox() async {
    if (tasks.isNotEmpty) {
      setState(() {
        String lastKey = tasks.keys.last;
        tasks.remove(lastKey);
      });

      try {
        await _databaseService.saveTasks(tasks);
      } catch (e) {
        print('Error deleting last checkbox: $e');
      }
    }
  }

  void editTaskLabel(String oldKey, String newLabel) async {
    setState(() {
      TaskData? taskData = tasks[oldKey];
      if (taskData != null) {
        tasks.remove(oldKey);
        tasks[newLabel] = taskData;
      }
    });

    try {
      await _databaseService.saveTasks(tasks);
    } catch (e) {
      print('Error editing task label: $e');
    }
  }

  void editSubtaskLabel(
      String parentKey, String oldKey, String newLabel) async {
    setState(() {
      bool? value = tasks[parentKey]?.subtasks[oldKey];
      if (value != null) {
        tasks[parentKey]?.subtasks.remove(oldKey);
        tasks[parentKey]?.subtasks[newLabel] = value;
      }
    });

    try {
      await _databaseService.saveTasks(tasks);
    } catch (e) {
      print('Error editing subtask label: $e');
    }
  }

  List<MapEntry<String, TaskData>> _filteredTasks() {
    if (selectedItem1 == null || selectedItem2 == null) {
      return [];
    }
    return tasks.entries.where((entry) {
      final taskKeyParts = entry.key.split(' - ');
      return taskKeyParts.length == 2 &&
          taskKeyParts[0] == selectedItem1 &&
          taskKeyParts[1] == selectedItem2;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dropdown Example'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: CustomDropdownWidget(
                          items: items1,
                          label: 'First Dropdown',
                          initialValue: selectedItem1,
                          onChanged: (value) {
                            setState(() {
                              selectedItem1 = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: CustomDropdownWidget(
                          items: items2,
                          label: 'Second Dropdown',
                          initialValue: selectedItem2,
                          onChanged: (value) {
                            setState(() {
                              selectedItem2 = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ..._filteredTasks().map((entry) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomCheckbox(
                          label: entry.key,
                          value: entry.value.isChecked,
                          hasSubtasks: entry.value.subtasks.isNotEmpty,
                          areSubtasksVisible: entry.value.areSubtasksVisible,
                          onChanged: (bool? newValue) async {
                            setState(() {
                              tasks[entry.key]!.isChecked = newValue ?? false;
                            });
                            try {
                              await _databaseService.saveTasks(tasks);
                            } catch (e) {
                              print('Error saving checkbox state: $e');
                            }
                          },
                          onAddSubtask: () => addSubtask(entry.key),
                          onDelete: () => deleteTask(entry.key),
                          onToggleSubtasks: () =>
                              toggleSubtasksVisibility(entry.key),
                          onLabelEdit: (newLabel) =>
                              editTaskLabel(entry.key, newLabel),
                        ),
                        if (entry.value.areSubtasksVisible)
                          ...entry.value.subtasks.entries.map((subtask) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 120.0),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: subtask.value,
                                    onChanged: (bool? newValue) async {
                                      setState(() {
                                        entry.value.subtasks[subtask.key] =
                                            newValue ?? false;
                                      });
                                      try {
                                        await _databaseService.saveTasks(tasks);
                                      } catch (e) {
                                        print('Error saving subtask state: $e');
                                      }
                                    },
                                  ),
                                  Expanded(
                                    child: Text(subtask.key),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          BottomButtons(
            isEnabled: selectedItem1 != null && selectedItem2 != null,
            items1: items1,
            items2: items2,
            onEditItems1: updateItems1,
            onEditItems2: updateItems2,
            onCreateCheckbox: createCheckbox,
            onDeleteLastCheckbox: deleteLastCheckbox,
          ),
        ],
      ),
    );
  }
}
