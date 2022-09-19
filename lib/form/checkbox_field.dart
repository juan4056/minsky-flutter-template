import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CheckboxInput extends StatefulWidget {
  const CheckboxInput({
    Key? key,
    required this.label,
    this.nameField,
    this.initialValue,
    required this.onChange,
  }) : super(key: key);

  final String label;
  final String? nameField;
  final bool? initialValue;
  final Function(bool) onChange;

  @override
  State<CheckboxInput> createState() => _CheckboxInputState();
}

class _CheckboxInputState extends State<CheckboxInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: FormBuilderCheckbox(
        name: widget.nameField ?? widget.label,
        initialValue: widget.initialValue,
        controlAffinity: ListTileControlAffinity.trailing,
        onChanged: (value) => widget.onChange(value ?? false),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        title: Text(
          widget.label,
          style: TextStyle(
            color: Colors.black.withOpacity(0.6),
            fontSize: 16,
          ),
        ),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          border: InputBorder.none,
          errorMaxLines: 2,
        ),
      ),
    );
  }
}
