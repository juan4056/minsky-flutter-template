import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class TextInput extends StatefulWidget {
  const TextInput({
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
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          labelText: widget.label,
          hintText: 'Text Input',
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
      ),
    );
  }
}

class PhoneInput extends StatefulWidget {
  const PhoneInput({
    Key? key,
    required this.label,
    this.nameField,
    this.initialValue,
    this.required = false,
    required this.onChange,
  }) : super(key: key);

  final String label;
  final String? nameField;
  final String? initialValue;
  final bool required;
  final Function(String) onChange;

  @override
  State<PhoneInput> createState() => _PhoneInputState();
}

class _PhoneInputState extends State<PhoneInput> {
  @override
  Widget build(BuildContext context) {
    final validators = <String? Function(String?)>[];
    if (widget.required) {
      validators.add(FormBuilderValidators.required());
    }
    validators.add(FormBuilderValidators.minLength(
      4,
      errorText: 'Ingrese un número de teléfono válido.',
    ));
    validators.add(FormBuilderValidators.maxLength(
      9,
      errorText: 'Ingrese un número de teléfono válido.',
    ));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: FormBuilderTextField(
        name: widget.nameField ?? widget.label,
        initialValue: widget.initialValue == '' ? null : widget.initialValue,
        autocorrect: false,
        keyboardType: TextInputType.phone,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) => widget.onChange(value ?? ''),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          labelText: widget.label,
          hintText: 'Phone Input',
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
      ),
    );
  }
}
