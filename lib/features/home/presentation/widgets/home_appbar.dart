import 'package:braillerecognition/core/widgets/tappable.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key, this.showShadow = false});

  final bool showShadow;

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: showShadow ? [
            BoxShadow(
              color: Theme.of(
                context,
              ).colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 0),
            ),
          ] : null,
        ),
        child: SafeArea(
          child: Row(
            children: [
              Image.asset("assets/images/icon.png", width: 32),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Braille Recognition",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Tappable(
                child: HugeIcon(
                  strokeWidth: 2,
                  color: Theme.of(context).primaryColor,
                  icon: HugeIcons.strokeRoundedInfinity01,
                ),
                onTap: () {
                  // open paywall
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
