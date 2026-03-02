import 'package:braillerecognition/core/widgets/tappable.dart';
import 'package:flutter/material.dart';

class GostButton extends StatelessWidget {
  const GostButton({
    super.key,
    required this.text,
    required this.onTap,
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(12),
  });
  final String text;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Tappable(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(12),
          child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ),
    );
  }
}
