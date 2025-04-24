import 'package:flutter/material.dart';

class DividerWithText extends StatelessWidget {
  final String text;
  final double thickness;
  final double indent;
  final Color? color;

  const DividerWithText({
    super.key,
    required this.text,
    this.thickness = 1,
    this.indent = 20,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dividerColor = color ?? theme.colorScheme.outlineVariant;
    
    return Row(
      children: [
        Expanded(
          child: Divider(
            thickness: thickness,
            indent: 0,
            endIndent: indent,
            color: dividerColor,
          ),
        ),
        Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Expanded(
          child: Divider(
            thickness: thickness,
            indent: indent,
            endIndent: 0,
            color: dividerColor,
          ),
        ),
      ],
    );
  }
} 