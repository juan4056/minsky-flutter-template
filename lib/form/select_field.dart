import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class SelectFormInput extends StatefulWidget {
  const SelectFormInput({
    Key? key,
    required this.label,
    this.nameField,
    this.initialValue,
    required this.items,
    required this.onChange,
    this.isRequired = false,
  }) : super(key: key);

  final String label;
  final String? nameField;
  final String? initialValue;
  final Map<String, String> items;
  final Function(String) onChange;
  final bool isRequired;

  @override
  State<SelectFormInput> createState() => _SelectFormInputState();
}

class _SelectFormInputState extends State<SelectFormInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: FormBuilderDropdown<String>(
        name: widget.nameField ?? widget.label,
        initialValue: widget.initialValue == '' ? null : widget.initialValue,
        items: widget.items.entries
            .map(
              (e) => DropdownMenuItem(
                value: e.key,
                child: Text(e.value),
              ),
            )
            .toList(),
        onChanged: (value) => widget.onChange(value ?? ''),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        isDense: false,
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
