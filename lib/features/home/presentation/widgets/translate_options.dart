import 'package:braillerecognition/core/widgets/tappable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class TranslateOptions extends StatelessWidget {
  const TranslateOptions({
    super.key,
    required this.selectedLanguage,
    required this.onLanguageTap,
    required this.onCameraTap,
    required this.onImportTap,
    required this.onKeyboardTap,
  });
  
  final String selectedLanguage;
  final VoidCallback onLanguageTap;
  final VoidCallback onCameraTap;
  final VoidCallback onImportTap;
  final VoidCallback onKeyboardTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFA2E7FB).withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 4), // changes position of shadow
                ),
              ],
              color: const Color(0xFFA2E7FB),
            ),
            child: Tappable(
              onTap: onLanguageTap,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Braille",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  HugeIcon(icon: HugeIcons.strokeRoundedArrowRight01, size: 32),
                  Expanded(
                    child: Text(
                      selectedLanguage,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD5F3FB).withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 4), // changes position of shadow
                ),
              ],
              color: const Color(0xFFD5F3FB),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Tappable(
                    onTap: onCameraTap,
                    child: Column(
                      children: [
                        HugeIcon(
                          size: 28,
                          icon: HugeIcons.strokeRoundedCamera01,
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Camera",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Tappable(
                    onTap: onImportTap,
                    child: Column(
                      children: [
                        HugeIcon(
                          size: 28,
                          icon: HugeIcons.strokeRoundedDownload01,
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Import",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Tappable(
                    onTap: onKeyboardTap,
                    child: Column(
                      children: [
                        HugeIcon(
                          size: 28,
                          icon: HugeIcons.strokeRoundedKeyboard,
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Keyboard",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
