import 'package:flutter/material.dart';

/// Custom elevated button widget
class CustomElevatedButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double? width;
  final double height;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final TextStyle? textStyle;
  final bool isLoading;
  final IconData? icon;
  final MainAxisAlignment mainAxisAlignment;

  const CustomElevatedButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.width,
    this.height = 48,
    this.backgroundColor = const Color(0xFF00A8A8),
    this.textColor = Colors.white,
    this.borderRadius = 12,
    this.textStyle,
    this.isLoading = false,
    this.icon,
    this.mainAxisAlignment = MainAxisAlignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          disabledBackgroundColor: backgroundColor.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: EdgeInsets.zero,
        ),
        child: isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: textColor,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: mainAxisAlignment,
                children: [
                  if (icon != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(icon, color: textColor),
                    ),
                  Text(
                    label,
                    style: textStyle ??
                        TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Custom outlined button widget
class CustomOutlinedButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double? width;
  final double height;
  final Color borderColor;
  final Color textColor;
  final double borderRadius;
  final TextStyle? textStyle;
  final bool isLoading;

  const CustomOutlinedButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.width,
    this.height = 48,
    this.borderColor = const Color(0xFF00A8A8),
    this.textColor = const Color(0xFF00A8A8),
    this.borderRadius = 12,
    this.textStyle,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: textColor,
                  strokeWidth: 2,
                ),
              )
            : Text(
                label,
                style: textStyle ??
                    TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
              ),
      ),
    );
  }
}

/// Custom text button widget
class CustomTextButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color textColor;
  final TextStyle? textStyle;
  final EdgeInsets padding;

  const CustomTextButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.textColor = const Color(0xFF00A8A8),
    this.textStyle,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: textStyle ??
              TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}
