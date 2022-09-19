import 'package:flutter/material.dart';

class ExpansionForm extends StatefulWidget {
  const ExpansionForm({
    Key? key,
    required this.title,
    required this.children,
    this.initiallyExpanded = false,
    this.titleWidget,
    this.onExpansionChanged,
  }) : super(key: key);

  final String title;
  final List<Widget> children;
  final bool initiallyExpanded;
  final void Function(bool)? onExpansionChanged;
  final Widget? titleWidget;

  @override
  State<ExpansionForm> createState() => _ExpansionFormState();
}

class _ExpansionFormState extends State<ExpansionForm> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: widget.initiallyExpanded,
      onExpansionChanged: widget.onExpansionChanged,
      maintainState: true,
      title: widget.titleWidget ??
          Text(
            widget.title,
            style: TextStyle(color: Colors.black.withOpacity(0.6)),
          ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: widget.children,
          ),
        )
      ],
    );
  }
}
