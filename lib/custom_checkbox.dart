import 'package:flutter/material.dart';

class CustomCheckbox extends StatefulWidget {
  final String label;
  final bool value;
  final bool hasSubtasks;
  final bool areSubtasksVisible;
  final Function(bool?) onChanged;
  final Function() onAddSubtask;
  final Function() onDelete;
  final Function() onToggleSubtasks;
  final Function(String) onLabelEdit;

  const CustomCheckbox({
    Key? key,
    required this.label,
    required this.value,
    required this.hasSubtasks,
    required this.areSubtasksVisible,
    required this.onChanged,
    required this.onAddSubtask,
    required this.onDelete,
    required this.onToggleSubtasks,
    required this.onLabelEdit,
  }) : super(key: key);

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool isEditing = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.label);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            widget.hasSubtasks 
              ? (widget.areSubtasksVisible ? Icons.visibility : Icons.visibility_off)
              : Icons.visibility_off,
          ),
          onPressed: widget.hasSubtasks ? widget.onToggleSubtasks : null,
          color: widget.hasSubtasks ? null : Colors.grey,
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: widget.onAddSubtask,
          tooltip: 'Add Subtask',
        ),
        Checkbox(
          value: widget.value,
          onChanged: widget.onChanged,
        ),
        Expanded(
          child: GestureDetector(
            onDoubleTap: () {
              setState(() {
                isEditing = true;
                _controller.text = widget.label;
              });
            },
            child: isEditing
              ? TextField(
                  controller: _controller,
                  autofocus: true,
                  onSubmitted: (value) {
                    widget.onLabelEdit(value);
                    setState(() {
                      isEditing = false;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                )
              : Text(widget.label),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: widget.onDelete,
          tooltip: 'Delete Task',
        ),
      ],
    );
  }
}