import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom text field widget
class CustomTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final int maxLines;
  final int minLines;
  final int? maxLength;
  final TextCapitalization textCapitalization;
  final bool obscureText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final bool readOnly;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final Color borderColor;
  final Color focusedBorderColor;
  final Color fillColor;
  final double borderRadius;
  final EdgeInsets contentPadding;
  final List<TextInputFormatter>? inputFormatters;
  final bool showLabel;

  const CustomTextField({
    Key? key,
    this.label,
    this.hint,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.minLines = 1,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.validator,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.borderColor = const Color(0xFFE0E0E0),
    this.focusedBorderColor = const Color(0xFF00A8A8),
    this.fillColor = const Color(0xFFFAFAFA),
    this.borderRadius = 12,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    this.inputFormatters,
    this.showLabel = true,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null && widget.showLabel)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              widget.label!,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
          ),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          textCapitalization: widget.textCapitalization,
          obscureText: _obscureText,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          readOnly: widget.readOnly,
          textInputAction: widget.textInputAction,
          focusNode: widget.focusNode,
          inputFormatters: widget.inputFormatters,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: const TextStyle(
              color: Color(0xFFAAAAAA),
              fontSize: 14,
            ),
            filled: true,
            fillColor: widget.fillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(color: widget.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(color: widget.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(color: widget.focusedBorderColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: const BorderSide(color: Color(0xFFE74C3C)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: const BorderSide(color: Color(0xFFE74C3C), width: 2),
            ),
            contentPadding: widget.contentPadding,
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon, color: const Color(0xFF00A8A8))
                : null,
            suffixIcon: widget.suffixIcon != null
                ? IconButton(
                    icon: Icon(
                      widget.obscureText
                          ? (_obscureText ? Icons.visibility_off : Icons.visibility)
                          : widget.suffixIcon,
                      color: const Color(0xFF00A8A8),
                    ),
                    onPressed: () {
                      if (widget.obscureText) {
                        setState(() => _obscureText = !_obscureText);
                      } else {
                        widget.onSuffixIconPressed?.call();
                      }
                    },
                  )
                : null,
            counterText: '',
          ),
        ),
      ],
    );
  }
}
