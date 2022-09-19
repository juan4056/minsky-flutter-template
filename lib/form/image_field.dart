import 'package:flutter/material.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({
    Key? key,
    required this.label,
    this.nameField,
    this.initialValue,
    this.required = false,
    required this.onChange,
  }) : super(key: key);

  final String label;
  final String? nameField;
  final List<dynamic>? initialValue;
  final bool required;
  final Function(List<dynamic>) onChange;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  @override
  Widget build(BuildContext context) {
    final validators = <String? Function(dynamic)>[];
    if (widget.required) {
      validators.add(FormBuilderValidators.required());
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: LayoutBuilder(builder: (context, constraints) {
        return FormBuilderImagePicker(
          name: widget.nameField ?? widget.label,
          initialValue: widget.initialValue,
          onChanged: (value) => widget.onChange(value ?? List.empty()),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxImages: 1,
          previewHeight: constraints.maxWidth - 50,
          previewWidth: constraints.maxWidth - 40,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(16),
            labelText: widget.label,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            errorMaxLines: 2,
          ),
          validator: FormBuilderValidators.compose(validators),
        );
      }),
    );
  }
}
