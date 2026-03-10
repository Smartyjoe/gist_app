import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../utils/responsive.dart';

class ExpandableTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final int minLines;
  final int maxLines;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;

  const ExpandableTextField({
    Key? key,
    required this.controller,
    this.hintText = "What's on your mind?",
    this.minLines = 1,
    this.maxLines = 10,
    this.focusNode,
    this.onChanged,
  }) : super(key: key);

  @override
  State<ExpandableTextField> createState() => _ExpandableTextFieldState();
}

class _ExpandableTextFieldState extends State<ExpandableTextField>
    with SingleTickerProviderStateMixin {
  late FocusNode _focusNode;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
      if (_isFocused) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _isFocused ? AppTheme.white : AppTheme.greySoft.withOpacity(0.3),
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          border: Border.all(
            color: _isFocused ? AppTheme.greenPrimary : Colors.transparent,
            width: 2,
          ),
        ),
        child: TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          onChanged: widget.onChanged,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          style: TextStyle(
            fontSize: responsive.sp(16),
            color: AppTheme.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              fontSize: responsive.sp(16),
              color: AppTheme.greyMedium,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: responsive.sp(16),
              vertical: responsive.sp(12),
            ),
          ),
        ),
      ),
    );
  }
}
