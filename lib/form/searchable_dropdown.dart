import 'package:flutter/material.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class SearchableSelectInput<T> extends StatefulWidget {
  const SearchableSelectInput({
    Key? key,
    required this.label,
    this.nameField,
    this.initialValue,
    this.required = false,
    required this.onChange,
    required this.query,
    required this.textWidget,
    required this.textValue,
  }) : super(key: key);

  final String label;
  final String? nameField;
  final T? initialValue;
  final bool required;
  final void Function(T?) onChange;
  final Future<Iterable<T>> Function(String) query;
  final String Function(T) textWidget;
  final String Function(T) textValue;

  @override
  State<SearchableSelectInput<T>> createState() =>
      _SearchableSelectInputState<T>();
}

class _SearchableSelectInputState<T> extends State<SearchableSelectInput<T>> {
  @override
  Widget build(BuildContext context) {
    final validators = <String? Function(T?)>[];
    if (widget.required) {
      validators.add(FormBuilderValidators.required());
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: FormBuilderTypeAhead<T>(
        name: widget.nameField ?? widget.label,
        itemBuilder: (context, value) {
          final text = widget.textWidget(value);
          return ListTile(title: Text(text));
        },
        suggestionsCallback: widget.query,
        initialValue: widget.initialValue,
        onChanged: (val) => widget.onChange(val),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          labelText: widget.label,
          hintText: 'Search',
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
        selectionToTextTransformer: widget.textValue,
      ),
    );
  }
}
