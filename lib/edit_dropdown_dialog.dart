import 'package:flutter/material.dart';

class EditDropdownDialog extends StatefulWidget {
  final List<String> items;
  final Function(List<String>) onSave;

  const EditDropdownDialog({
    Key? key,
    required this.items,
    required this.onSave,
  }) : super(key: key);

  @override
  State<EditDropdownDialog> createState() => _EditDropdownDialogState();
}

class _EditDropdownDialogState extends State<EditDropdownDialog> {
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = widget.items.isEmpty
        ? [TextEditingController()]
        : widget.items
            .map((item) => TextEditingController(text: item))
            .toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

void _addNewItem() {
  setState(() {
    var newController = TextEditingController(text: 'Item ${_controllers.length + 1}');
    _controllers.add(newController);
    print('Added new item. Total items: ${_controllers.length}');
  });
}

void _removeItem(int index) {
  if (_controllers.length > 1) {
    setState(() {
      _controllers[index].dispose();
      _controllers.removeAt(index);
      print('Removed item at index $index. Total items: ${_controllers.length}');
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Dropdown Items'),
      content: SizedBox(
        width: 300, // Set a fixed width
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ..._controllers.asMap().entries.map((entry) {
                int index = entry.key;
                var controller = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          decoration: InputDecoration(
                            labelText: 'Item ${index + 1}',
                          ),
                        ),
                      ),
                      if (_controllers.length > 1)
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () => _removeItem(index),
                          color: Colors.red,
                        ),
                    ],
                  ),
                );
              }).toList(),
              TextButton.icon(
                onPressed: _addNewItem,
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Add Item'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            print(
                'Before saving - Number of controllers: ${_controllers.length}');

            // First, let's print the content of each controller
            for (int i = 0; i < _controllers.length; i++) {
              print('Controller $i value: "${_controllers[i].text}"');
            }

            List<String> newItems = [];
            for (var controller in _controllers) {
              String text = controller.text.trim();
              if (text.isNotEmpty) {
                newItems.add(text);
              }
            }

            print('Final newItems: $newItems');
            print('Final count: ${newItems.length}');

            if (newItems.isNotEmpty) {
              widget.onSave(newItems);
            }
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
