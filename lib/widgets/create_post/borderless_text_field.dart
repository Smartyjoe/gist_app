import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../models/post_background.dart';
import '../../utils/responsive.dart';

/// Borderless text field component inspired by Facebook's Create Post interface.
///
/// Two modes:
/// 1. **Normal mode** — plain white background, left-aligned, standard font.
/// 2. **Styled mode** — rendered inside a rounded background card with the
///    chosen [PostBackground], centered text, larger font, and a character
///    counter that appears as the user nears the 180-char limit.
class BorderlessTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hintText;
  final int minLines;
  final int? maxLines;
  final ValueChanged<String>? onChanged;
  final TextStyle? style;
  final TextStyle? hintStyle;

  /// Legacy plain colour — kept for backward compat (ignored when
  /// [activeBackground] is set).
  final Color? backgroundColor;

  final EdgeInsets? padding;

  /// When non-null the field renders in styled "background" mode.
  final PostBackground? activeBackground;

  static const int maxStyledChars = 180;

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
    this.activeBackground,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    if (activeBackground != null) {
      return _StyledEditor(
        controller: controller,
        focusNode: focusNode,
        hintText: hintText,
        onChanged: onChanged,
        background: activeBackground!,
        responsive: responsive,
      );
    }

    // ── Normal mode ─────────────────────────────────────────────────────────
    return Container(
      color: backgroundColor ?? AppTheme.white,
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: responsive.sp(20),
            vertical: responsive.sp(16),
          ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        maxLines: maxLines,
        minLines: minLines,
        style: style ??
            TextStyle(
              fontSize: responsive.sp(16),
              color: AppTheme.textPrimary,
              height: 1.5,
            ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: hintStyle ??
              TextStyle(
                fontSize: responsive.sp(16),
                color: AppTheme.greyMedium,
                fontWeight: FontWeight.w400,
              ),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          counterText: '',
        ),
        onChanged: onChanged,
        textCapitalization: TextCapitalization.sentences,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Styled editor (background mode)
// ---------------------------------------------------------------------------

class _StyledEditor extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final PostBackground background;
  final Responsive responsive;

  const _StyledEditor({
    required this.controller,
    this.focusNode,
    required this.hintText,
    this.onChanged,
    required this.background,
    required this.responsive,
  });

  @override
  State<_StyledEditor> createState() => _StyledEditorState();
}

class _StyledEditorState extends State<_StyledEditor> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_refresh);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() => setState(() {});

  int get _charCount => widget.controller.text.length;
  bool get _nearLimit =>
      _charCount >= BorderlessTextField.maxStyledChars - 40;

  /// Per-background text style tuned for beauty and readability.
  TextStyle _textStyleFor(PostBackground bg, double baseSp) {
    final color = bg.textColor;
    switch (bg.id) {
      // ── Solids ────────────────────────────────────────────────────────────
      case 'solid_yellow':
        return TextStyle(
          fontSize: baseSp * 1.05,
          color: color,
          fontWeight: FontWeight.w700,
          height: 1.45,
          letterSpacing: 0.2,
        );
      case 'solid_blue':
        return TextStyle(
          fontSize: baseSp,
          color: color,
          fontWeight: FontWeight.w600,
          height: 1.5,
          letterSpacing: 0.1,
        );
      case 'solid_mint':
        return TextStyle(
          fontSize: baseSp,
          color: color,
          fontWeight: FontWeight.w600,
          height: 1.5,
          letterSpacing: 0.15,
        );
      case 'solid_coral':
        return TextStyle(
          fontSize: baseSp * 1.08,
          color: color,
          fontWeight: FontWeight.w700,
          height: 1.4,
          letterSpacing: 0.0,
        );
      case 'solid_lavender':
        return TextStyle(
          fontSize: baseSp,
          color: color,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.italic,
          height: 1.55,
          letterSpacing: 0.3,
        );
      case 'solid_charcoal':
        return TextStyle(
          fontSize: baseSp,
          color: color,
          fontWeight: FontWeight.w400,
          height: 1.6,
          letterSpacing: 0.4,
        );

      // ── Gradients ─────────────────────────────────────────────────────────
      case 'grad_purple_pink':
        return TextStyle(
          fontSize: baseSp * 1.1,
          color: color,
          fontWeight: FontWeight.w800,
          height: 1.35,
          letterSpacing: -0.2,
          shadows: [Shadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))],
        );
      case 'grad_orange_yellow':
        return TextStyle(
          fontSize: baseSp * 1.1,
          color: color,
          fontWeight: FontWeight.w800,
          height: 1.35,
          letterSpacing: -0.1,
          shadows: [Shadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 1))],
        );
      case 'grad_blue_cyan':
        return TextStyle(
          fontSize: baseSp,
          color: color,
          fontWeight: FontWeight.w600,
          height: 1.5,
          letterSpacing: 0.5,
          shadows: [Shadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))],
        );
      case 'grad_teal_green':
        return TextStyle(
          fontSize: baseSp,
          color: color,
          fontWeight: FontWeight.w600,
          height: 1.5,
          letterSpacing: 0.2,
          shadows: [Shadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 1))],
        );
      case 'grad_indigo_purple':
        return TextStyle(
          fontSize: baseSp * 1.05,
          color: color,
          fontWeight: FontWeight.w700,
          height: 1.4,
          letterSpacing: 0.1,
          shadows: [Shadow(color: Colors.black38, blurRadius: 8, offset: Offset(0, 2))],
        );
      case 'grad_rose_peach':
        return TextStyle(
          fontSize: baseSp * 1.05,
          color: color,
          fontWeight: FontWeight.w700,
          height: 1.4,
          letterSpacing: 0.0,
          shadows: [Shadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 1))],
        );

      // ── Patterns ──────────────────────────────────────────────────────────
      case 'pattern_dots_blue':
        return TextStyle(
          fontSize: baseSp,
          color: color,
          fontWeight: FontWeight.w700,
          height: 1.5,
          letterSpacing: 0.3,
        );
      case 'pattern_dots_green':
        return TextStyle(
          fontSize: baseSp,
          color: color,
          fontWeight: FontWeight.w600,
          height: 1.5,
          letterSpacing: 0.2,
        );
      case 'pattern_waves':
        return TextStyle(
          fontSize: baseSp * 1.05,
          color: color,
          fontWeight: FontWeight.w700,
          height: 1.45,
          letterSpacing: 0.1,
        );
      case 'pattern_shapes':
        return TextStyle(
          fontSize: baseSp * 1.05,
          color: color,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.italic,
          height: 1.45,
          letterSpacing: 0.0,
        );

      default:
        return TextStyle(
          fontSize: baseSp,
          color: color,
          fontWeight: FontWeight.w600,
          height: 1.45,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = widget.background;
    final r = widget.responsive;
    final textColor = bg.textColor;
    final textStyle = _textStyleFor(bg, r.sp(22));

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: r.sp(16),
        vertical: r.sp(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Background card ──────────────────────────────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(r.sp(16)),
            child: _PatternLayer(
              background: bg,
              child: Container(
                // Solid/gradient decoration applied here; pattern base colour
                // is applied by _PatternLayer — either way NO white fill here.
                decoration: bg.type == PostBackgroundType.pattern
                    ? null
                    : bg.decoration,
                constraints: BoxConstraints(minHeight: r.sp(200)),
                padding: EdgeInsets.symmetric(
                  horizontal: r.sp(24),
                  vertical: r.sp(32),
                ),
                child: TextField(
                  controller: widget.controller,
                  focusNode: widget.focusNode,
                  maxLines: null,
                  maxLength: BorderlessTextField.maxStyledChars,
                  textAlign: TextAlign.center,
                  style: textStyle,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: textStyle.copyWith(
                      color: textColor.withOpacity(0.5),
                    ),
                    // Fully transparent — lets the background show through
                    filled: false,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    counterText: '',
                  ),
                  onChanged: widget.onChanged,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
            ),
          ),

          // ── Character counter (shown near limit) ─────────────────────────
          if (_nearLimit)
            Padding(
              padding: EdgeInsets.only(top: r.sp(6), right: r.sp(4)),
              child: Text(
                '${BorderlessTextField.maxStyledChars - _charCount} characters remaining',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: r.sp(11),
                  color: _charCount >= BorderlessTextField.maxStyledChars
                      ? AppTheme.alertOrange
                      : AppTheme.greyMedium,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Pattern layer wrapper — draws pattern CustomPainters behind the child.
// ---------------------------------------------------------------------------

class _PatternLayer extends StatelessWidget {
  final PostBackground background;
  final Widget child;

  const _PatternLayer({required this.background, required this.child});

  @override
  Widget build(BuildContext context) {
    if (background.type != PostBackgroundType.pattern) return child;

    return Container(
      decoration: background.decoration, // base colour
      child: CustomPaint(
        painter: _resolvePainter(background),
        child: child,
      ),
    );
  }

  CustomPainter _resolvePainter(PostBackground bg) {
    final dotColor = bg.patternDotColor ?? Colors.white.withOpacity(0.4);
    switch (bg.pattern) {
      case PostBackgroundPattern.dots:
        return DotPatternPainter(dotColor: dotColor);
      case PostBackgroundPattern.waves:
        return WavePatternPainter(waveColor: dotColor);
      case PostBackgroundPattern.shapes:
        return ShapePatternPainter(shapeColor: dotColor);
      default:
        return DotPatternPainter(dotColor: dotColor);
    }
  }
}
