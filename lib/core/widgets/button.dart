import 'package:braillerecognition/core/utils/colors.dart';
import 'package:braillerecognition/core/widgets/tappable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.width = double.infinity,
    this.height = 50,
    this.isLoading = false,
    this.margin = const EdgeInsets.all(0),
    this.lowerBound = 0.98,
  });

  final String text;
  final Function()? onTap;
  final double width;
  final double height;
  final EdgeInsets margin;
  final bool isLoading;
  final double lowerBound;

  @override
  Widget build(BuildContext context) {
    return Tappable(
      onTap: onTap ?? () {},
      lowerBound: lowerBound,
      child: Container(
        margin: margin,
        height: height,
        width: width,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(14),
          ),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withAlpha(100),
              spreadRadius: 1,
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
          gradient: primaryGradient,
        ),
        child: isLoading
            ? const CupertinoActivityIndicator(
                color: Colors.white,
              )
            : Text(
                text,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.white,
                      fontFamily: "PoppinsBold",
                    ),
              ),
      ),
    );
  }
}
