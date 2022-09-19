import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class MultiSelectInput extends StatefulWidget {
  const MultiSelectInput({
    Key? key,
    required this.label,
    this.nameField,
    this.initialValue,
    required this.options,
    this.nullOptions,
    this.required = false,
    required this.onChange,
  }) : super(key: key);

  final String label;
  final String? nameField;
  final List<String>? initialValue;
  final Map<String, String> options;
  final List<String>? nullOptions;
  final bool required;
  final Function(List<String>) onChange;

  @override
  State<MultiSelectInput> createState() => _MultiSelectInputState();
}

class _MultiSelectInputState extends State<MultiSelectInput> {
  @override
  Widget build(BuildContext context) {
    final validators = <String? Function(List<String>?)>[];
    if (widget.required) {
      validators.add(FormBuilderValidators.required());
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: _MyChoiceChip<String>(
        name: widget.nameField ?? widget.label,
        initialValue: widget.initialValue,
        options: widget.options.entries
            .map((e) => FormBuilderChipOption<String>(
                  value: e.key,
                  child: Text(e.value),
                ))
            .toList(),
        nullOptions: widget.nullOptions ?? List<String>.empty(),
        onChanged: (value) => widget.onChange(value ?? List.empty()),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          labelText: widget.label,
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

class _MyChoiceChip<T> extends FormBuilderField<List<T>> {
  final List<FormBuilderChipOption<T>> options;
  final List<T> nullOptions;

  final bool showCheckmark;
  final ShapeBorder avatarBorder;

  _MyChoiceChip({
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
    FormFieldValidator<List<T>>? validator,
    InputDecoration decoration = const InputDecoration(),
    Key? key,
    List<T>? initialValue,
    required String name,
    required this.options,
    this.nullOptions = const [],
    ValueChanged<List<T>?>? onChanged,
    this.showCheckmark = true,
    this.avatarBorder = const CircleBorder(),
  }) : super(
            key: key,
            initialValue: initialValue,
            name: name,
            validator: validator,
            autovalidateMode: autovalidateMode,
            decoration: decoration,
            onChanged: onChanged,
            builder: (FormFieldState<List<T>?> field) {
              final state = field as _MyChoiceChipState<T>;
              final fieldValue = field.value ?? [];

              return InputDecorator(
                decoration: state.decoration,
                child: Wrap(
                  children: <Widget>[
                    for (FormBuilderChipOption<T> option in options)
                      FilterChip(
                        label: option,
                        selected: fieldValue.contains(option.value),
                        onSelected: state.enabled
                            ? (selected) {
                                final currentValue = [...fieldValue];
                                if (selected) {
                                  if (nullOptions.contains(option.value)) {
                                    currentValue.clear();
                                  } else {
                                    for (var nullVal in nullOptions) {
                                      if (currentValue.contains(nullVal)) {
                                        currentValue.clear();
                                        break;
                                      }
                                    }
                                  }
                                  currentValue.add(option.value);
                                } else {
                                  currentValue.remove(option.value);
                                }
                                field.didChange(currentValue);
                              }
                            : null,
                        avatar: option.avatar,
                        showCheckmark: showCheckmark,
                        avatarBorder: avatarBorder,
                      ),
                  ],
                ),
              );
            });

  @override
  FormBuilderFieldState<_MyChoiceChip<T>, List<T>> createState() =>
      _MyChoiceChipState<T>();
}

class _MyChoiceChipState<T>
    extends FormBuilderFieldState<_MyChoiceChip<T>, List<T>> {}
