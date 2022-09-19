import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class YesOrNotInput extends StatefulWidget {
  const YesOrNotInput({
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
  State<YesOrNotInput> createState() => _YesOrNotInputState();
}

class _YesOrNotInputState extends State<YesOrNotInput> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          widget.label,
          style: TextStyle(color: Colors.black.withOpacity(0.6)),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: FormBuilderRadioGroup<bool>(
              name: widget.nameField ?? widget.label,
              controlAffinity: ControlAffinity.trailing,
              onChanged: (value) => widget.onChange(value ?? false),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                border: InputBorder.none,
                errorMaxLines: 2,
              ),
              options: [
                FormBuilderFieldOption(
                  value: true,
                  child: Text(
                    'Sí',
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                ),
                FormBuilderFieldOption(
                  value: false,
                  child: Text(
                    'No',
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
