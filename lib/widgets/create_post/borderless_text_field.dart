import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../utils/responsive.dart';

/// Borderless text field component inspired by Facebook's Create Post interface.
/// 
/// Key features:
/// - NO borders, NO background, NO card container
/// - Feels like typing on a blank white page
/// - Expandable with unlimited lines
/// - Clean, premium aesthetic
class BorderlessTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hintText;
  final int minLines;
  final int? maxLines;
  final ValueChanged<String>? onChanged;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final Color? backgroundColor;
  final EdgeInsets? padding;

  const BorderlessTextField({
    Key? key,
    required this.controller,
    this.focusNode,
    this.hintText = "What's on your mind?",
    this.minLines = 5,
    this.maxLines,
    this.onChanged,
    this.style,
    this.hintStyle,
    this.backgroundColor,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Container(
      // Background color (for text-only posts with color)
      color: backgroundColor ?? AppTheme.white,
      
      // Only padding - NO decoration, NO border, NO borderRadius
      padding: padding ?? EdgeInsets.symmetric(
        horizontal: responsive.sp(20),
        vertical: responsive.sp(16),
      ),
      
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        maxLines: maxLines,
        minLines: minLines,
        style: style ?? TextStyle(
          fontSize: responsive.sp(16),
          color: AppTheme.textPrimary,
          height: 1.5,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: hintStyle ?? TextStyle(
            fontSize: responsive.sp(16),
            color: AppTheme.greyMedium,
            fontWeight: FontWeight.w400,
          ),
          
          // CRITICAL: All borders set to none
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          
          // No internal padding - handled by Container
          contentPadding: EdgeInsets.zero,
          
          // No counter text
          counterText: '',
        ),
        onChanged: onChanged,
        textCapitalization: TextCapitalization.sentences,
      ),
    );
  }
}
