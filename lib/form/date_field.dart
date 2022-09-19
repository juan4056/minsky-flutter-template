import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class DateInput extends StatefulWidget {
  const DateInput({
    Key? key,
    required this.label,
    this.nameField,
    this.initialValue,
    this.minDate,
    this.maxDate,
    this.required = false,
    required this.onChange,
  }) : super(key: key);

  final String label;
  final String? nameField;
  final DateTime? initialValue;
  final DateTime? minDate;
  final DateTime? maxDate;
  final bool required;
  final Function(DateTime) onChange;

  @override
  State<DateInput> createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  @override
  Widget build(BuildContext context) {
    final validators = <String? Function(DateTime?)>[];
    if (widget.required) {
      validators.add(FormBuilderValidators.required());
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: FormBuilderDateTimePicker(
        name: widget.nameField ?? widget.label,
        initialValue: widget.initialValue,
        inputType: InputType.date,
        resetIcon: null,
        autocorrect: false,
        onChanged: (value) => widget.onChange(value ?? DateTime.now()),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          labelText: widget.label,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          errorMaxLines: 2,
        ),
        firstDate: widget.minDate ?? DateTime(2019, 8),
        lastDate: widget.maxDate ?? DateTime.now(),
        validator: FormBuilderValidators.compose(validators),
      ),
    );
  }
}
