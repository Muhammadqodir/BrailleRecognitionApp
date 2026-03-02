import 'package:braillerecognition/core/widgets/tappable.dart';
import 'package:flutter/material.dart';

class OutlineBtn extends StatelessWidget {
  const OutlineBtn({
    super.key,
    this.height = 40,
    required this.onTap,
    this.width = 40,
    this.padding = const EdgeInsets.all(12),
    required this.child,
  });

  final double width;
  final Function()? onTap;
  final double height;
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Tappable(
      onTap: onTap ?? () {},
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        // padding: padding,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor, width: 1.5),
          borderRadius: BorderRadius.circular(22),
        ),
        child: child,
      ),
    );
  }
}
