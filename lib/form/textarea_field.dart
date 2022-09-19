import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class TextAreaInput extends StatefulWidget {
  const TextAreaInput({
    Key? key,
    required this.label,
    this.nameField,
    this.initialValue,
    this.minLength,
    this.maxLength,
    this.required = false,
    required this.onChange,
  }) : super(key: key);

  final String label;
  final String? nameField;
  final String? initialValue;
  final int? minLength;
  final int? maxLength;
  final bool required;
  final Function(String) onChange;

  @override
  State<TextAreaInput> createState() => _TextAreaInputState();
}

class _TextAreaInputState extends State<TextAreaInput> {
  @override
  Widget build(BuildContext context) {
    final validators = <String? Function(String?)>[];
    if (widget.required) {
      validators.add(FormBuilderValidators.required());
    }
    if (widget.minLength != null) {
      validators.add(FormBuilderValidators.minLength((widget.minLength) ?? 0));
    }
    if (widget.maxLength != null) {
      validators
          .add(FormBuilderValidators.maxLength((widget.maxLength) ?? 100));
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: FormBuilderTextField(
        name: widget.nameField ?? widget.label,
        initialValue: widget.initialValue == '' ? null : widget.initialValue,
        autocorrect: false,
        onChanged: (value) => widget.onChange(value ?? ''),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16),
          labelText: widget.label,
          hintText: 'Text Area',
          hintStyle: TextStyle(color: Colors.grey[400]),
          filled: true,
          fillColor: Colors.white70,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          errorMaxLines: 2,
        ),
        validator: FormBuilderValidators.compose(validators),
        maxLines: 5,
      ),
    );
  }
}
