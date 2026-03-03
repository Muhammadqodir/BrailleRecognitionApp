import 'package:braillerecognition/core/widgets/tappable.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

/// Custom bottom navigation bar following shadcn design principles
class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<NavigationItemData> items;

  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              items.length,
              (index) => _NavigationButton(
                item: items[index],
                isSelected: currentIndex == index,
                onTap: () => onTap(index),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Individual navigation button
class _NavigationButton extends StatefulWidget {
  final NavigationItemData item;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavigationButton({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_NavigationButton> createState() => _NavigationButtonState();
}

class _NavigationButtonState extends State<_NavigationButton> {
  @override
  Widget build(BuildContext context) {
    final isSelected = widget.isSelected;
    final theme = Theme.of(context);

    final iconColor = isSelected
        ? theme.primaryColor
        : theme.colorScheme.onSurfaceVariant;

    final textColor = isSelected
        ? theme.primaryColor
        : theme.colorScheme.onSurfaceVariant;

    double strokeWidth = isSelected ? 2 : 1;

    return Expanded(
      child: Tappable(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: isSelected
                ? theme.primaryColor.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              HugeIcon(
                icon: widget.item.icon,
                color: iconColor,
                size: 24,
                strokeWidth: strokeWidth,
              ),
              const SizedBox(height: 4),
              // if (isSelected)
              //   Container(
              //     height: 6,
              //     width: 6,
              //     decoration: BoxDecoration(
              //       color: theme.primaryColor,
              //       shape: BoxShape.circle,
              //     ),
              //   ),
              Text(
                widget.item.label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: textColor,
                  height: 1,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Navigation item data class
class NavigationItemData {
  final String label;
  final dynamic icon;

  const NavigationItemData({required this.label, required this.icon});
}
