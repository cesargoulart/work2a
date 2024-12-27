import 'package:flutter/material.dart';

class SubtaskLabel extends StatefulWidget {
  final String subtaskKey;
  final String parentKey;
  final Function(String) onLabelEdit;

  const SubtaskLabel({
    Key? key,
    required this.subtaskKey,
    required this.parentKey,
    required this.onLabelEdit,
  }) : super(key: key);

  @override
  _SubtaskLabelState createState() => _SubtaskLabelState();
}

class _SubtaskLabelState extends State<SubtaskLabel> {
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.subtaskKey);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isEditing) {
      return TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
        onEditingComplete: () {
          setState(() {
            _isEditing = false;
          });
          widget.onLabelEdit(_controller.text);
        },
        onTapOutside: (event) {
          setState(() {
            _isEditing = false;
          });
        },
      );
    } else {
      return GestureDetector(
        onDoubleTap: () {
          setState(() {
            _isEditing = true;
          });
        },
        child: Text(widget.subtaskKey),
      );
    }
  }
}
