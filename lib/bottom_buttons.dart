import 'package:flutter/material.dart';
import 'edit_dropdown_dialog.dart';

class BottomButtons extends StatelessWidget {
  final bool isEnabled;
  final List<String> items1;
  final List<String> items2;  // Add this
  final Function(List<String>) onEditItems1;
  final Function(List<String>) onEditItems2;  // Add this
  final Function() onCreateCheckbox;
  final Function() onDeleteLastCheckbox;

  const BottomButtons({
    Key? key,
    required this.isEnabled,
    required this.items1,
    required this.items2,  // Add this
    required this.onEditItems1,
    required this.onEditItems2,  // Add this
    required this.onCreateCheckbox,
    required this.onDeleteLastCheckbox,
  }) : super(key: key);

  void _showEditDialog1(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EditDropdownDialog(
        items: items1,
        onSave: onEditItems1,
      ),
    );
  }

  void _showEditDialog2(BuildContext context) {  // Add this function
    showDialog(
      context: context,
      builder: (context) => EditDropdownDialog(
        items: items2,
        onSave: onEditItems2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () => _showEditDialog1(context),
            child: const Text('Edit List 1'),
          ),
          ElevatedButton(
            onPressed: () => _showEditDialog2(context),  // Change this
            child: const Text('Edit List 2'),  // Change this
          ),
          ElevatedButton(
            onPressed: isEnabled ? onCreateCheckbox : null,
            child: const Text('Create Checkbox'),
          ),
          ElevatedButton(
            onPressed: onDeleteLastCheckbox,
            child: const Text('Delete Last'),
          ),
        ],
      ),
    );
  }
}