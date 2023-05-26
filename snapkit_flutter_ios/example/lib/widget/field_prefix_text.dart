import 'package:flutter/material.dart';

class FieldPrefixText extends StatelessWidget {
  const FieldPrefixText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: 88,
        child: Text(text, maxLines: 1),
      ),
    );
  }
}
