import 'package:flutter/material.dart';

class CustomDropdownWidget extends StatefulWidget {
  final List<String> items;
  final String label;
  final Function(String) onChanged;
  final String? initialValue;

  const CustomDropdownWidget({
    Key? key,
    required this.items,
    required this.label,
    required this.onChanged,
    this.initialValue,
  }) : super(key: key);

  @override
  State<CustomDropdownWidget> createState() => _CustomDropdownWidgetState();
}

class _CustomDropdownWidgetState extends State<CustomDropdownWidget> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  void didUpdateWidget(CustomDropdownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset selection if the selected value is no longer in the items list
    if (selectedValue != null && !widget.items.contains(selectedValue)) {
      selectedValue = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      decoration: InputDecoration(
        labelText: widget.label,
        border: const OutlineInputBorder(),
      ),
      items: widget.items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedValue = newValue;
          widget.onChanged(newValue!);
        });
      },
    );
  }
}