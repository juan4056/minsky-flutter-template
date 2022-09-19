import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class SelectNumberInput extends StatefulWidget {
  const SelectNumberInput({
    Key? key,
    required this.label,
    this.nameField,
    this.initialValue,
    required this.onChange,
    this.isRequired = false,
    required this.start,
    required this.end,
  }) : super(key: key);

  final String label;
  final String? nameField;
  final int? initialValue;
  final int start;
  final int end;
  final Function(int) onChange;
  final bool isRequired;

  @override
  State<SelectNumberInput> createState() => _SelectNumberInputState();
}

class _SelectNumberInputState extends State<SelectNumberInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: FormBuilderDropdown<int>(
        name: widget.nameField ?? widget.label,
        initialValue: widget.initialValue == -1 ? null : widget.initialValue,
        items: [for (var i = widget.start; i < widget.end; i += 1) i]
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e.toString()),
                ))
            .toList(),
        onChanged: (value) => widget.onChange(value ?? -1),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          labelText: widget.label,
          hintText: 'Select',
          hintStyle: TextStyle(color: Colors.grey[400]),
          filled: true,
          fillColor: Colors.white70,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          errorMaxLines: 2,
        ),
        validator: widget.isRequired
            ? FormBuilderValidators.compose([FormBuilderValidators.required()])
            : null,
      ),
    );
  }
}
