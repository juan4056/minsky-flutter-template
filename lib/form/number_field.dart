import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class NumberInput extends StatefulWidget {
  const NumberInput({
    Key? key,
    required this.label,
    this.nameField,
    this.initialValue,
    this.required = false,
    required this.onChange,
  }) : super(key: key);

  final String label;
  final String? nameField;
  final int? initialValue;
  final bool required;
  final Function(int) onChange;

  @override
  State<NumberInput> createState() => _NumberInputState();
}

class _NumberInputState extends State<NumberInput> {
  @override
  Widget build(BuildContext context) {
    final validators = <String? Function(String?)>[];
    if (widget.required) {
      validators.add(FormBuilderValidators.required());
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: FormBuilderTextField(
        name: widget.nameField ?? widget.label,
        initialValue: (widget.initialValue == -1 || widget.initialValue == null)
            ? null
            : widget.initialValue.toString(),
        autocorrect: false,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        onChanged: (value) => widget.onChange(int.tryParse(value!) ?? -1),
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
