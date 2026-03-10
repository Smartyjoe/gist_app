import 'package:flutter/material.dart';

/// Defines the type of background applied to a styled post.
enum PostBackgroundType { solid, gradient, pattern }

/// Enum for subtle pattern types (drawn via CustomPainter — no assets needed).
enum PostBackgroundPattern { dots, waves, shapes }

/// Represents a single selectable background for a styled text post.
class PostBackground {
  final String id;
  final String label;
  final PostBackgroundType type;

  // For solid
  final Color? color;

  // For gradient
  final List<Color>? gradientColors;
  final AlignmentGeometry? gradientBegin;
  final AlignmentGeometry? gradientEnd;

  // For pattern
  final PostBackgroundPattern? pattern;
  final Color? patternBaseColor;
  final Color? patternDotColor;

  // Text color to use on top of this background
  final Color textColor;

  const PostBackground({
    required this.id,
    required this.label,
    required this.type,
    this.color,
    this.gradientColors,
    this.gradientBegin,
    this.gradientEnd,
    this.pattern,
    this.patternBaseColor,
    this.patternDotColor,
    this.textColor = Colors.white,
  });

  /// Returns the BoxDecoration to apply to the styled editor container.
  BoxDecoration get decoration {
    switch (type) {
      case PostBackgroundType.solid:
        return BoxDecoration(color: color);
      case PostBackgroundType.gradient:
        return BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors!,
            begin: gradientBegin as Alignment? ?? Alignment.topLeft,
            end: gradientEnd as Alignment? ?? Alignment.bottomRight,
          ),
        );
      case PostBackgroundType.pattern:
        return BoxDecoration(color: patternBaseColor);
    }
  }

  /// The curated library of 16 backgrounds.
  static const List<PostBackground> library = [
    // ── SOLID ──────────────────────────────────────────────────────────────
    PostBackground(
      id: 'solid_yellow',
      label: 'Soft Yellow',
      type: PostBackgroundType.solid,
      color: Color(0xFFFFF9C4),
      textColor: Color(0xFF5D4037),
    ),
    PostBackground(
      id: 'solid_blue',
      label: 'Sky Blue',
      type: PostBackgroundType.solid,
      color: Color(0xFFE3F2FD),
      textColor: Color(0xFF1565C0),
    ),
    PostBackground(
      id: 'solid_mint',
      label: 'Mint Green',
      type: PostBackgroundType.solid,
      color: Color(0xFFE8F5E9),
      textColor: Color(0xFF2E7D32),
    ),
    PostBackground(
      id: 'solid_coral',
      label: 'Coral',
      type: PostBackgroundType.solid,
      color: Color(0xFFFFCDD2),
      textColor: Color(0xFFC62828),
    ),
    PostBackground(
      id: 'solid_lavender',
      label: 'Lavender',
      type: PostBackgroundType.solid,
      color: Color(0xFFEDE7F6),
      textColor: Color(0xFF4527A0),
    ),
    PostBackground(
      id: 'solid_charcoal',
      label: 'Charcoal',
      type: PostBackgroundType.solid,
      color: Color(0xFF37474F),
      textColor: Color(0xFFECEFF1),
    ),

    // ── GRADIENT ───────────────────────────────────────────────────────────
    PostBackground(
      id: 'grad_purple_pink',
      label: 'Purple → Pink',
      type: PostBackgroundType.gradient,
      gradientColors: [Color(0xFF7B1FA2), Color(0xFFE91E63)],
      gradientBegin: Alignment.topLeft,
      gradientEnd: Alignment.bottomRight,
      textColor: Colors.white,
    ),
    PostBackground(
      id: 'grad_orange_yellow',
      label: 'Orange → Yellow',
      type: PostBackgroundType.gradient,
      gradientColors: [Color(0xFFF4511E), Color(0xFFFFD600)],
      gradientBegin: Alignment.topLeft,
      gradientEnd: Alignment.bottomRight,
      textColor: Colors.white,
    ),
    PostBackground(
      id: 'grad_blue_cyan',
      label: 'Blue → Cyan',
      type: PostBackgroundType.gradient,
      gradientColors: [Color(0xFF1565C0), Color(0xFF00BCD4)],
      gradientBegin: Alignment.topCenter,
      gradientEnd: Alignment.bottomCenter,
      textColor: Colors.white,
    ),
    PostBackground(
      id: 'grad_teal_green',
      label: 'Teal → Green',
      type: PostBackgroundType.gradient,
      gradientColors: [Color(0xFF00695C), Color(0xFF66BB6A)],
      gradientBegin: Alignment.topLeft,
      gradientEnd: Alignment.bottomRight,
      textColor: Colors.white,
    ),
    PostBackground(
      id: 'grad_indigo_purple',
      label: 'Indigo → Purple',
      type: PostBackgroundType.gradient,
      gradientColors: [Color(0xFF283593), Color(0xFF9C27B0)],
      gradientBegin: Alignment.topRight,
      gradientEnd: Alignment.bottomLeft,
      textColor: Colors.white,
    ),
    PostBackground(
      id: 'grad_rose_peach',
      label: 'Rose → Peach',
      type: PostBackgroundType.gradient,
      gradientColors: [Color(0xFFE91E63), Color(0xFFFFAB91)],
      gradientBegin: Alignment.topLeft,
      gradientEnd: Alignment.bottomRight,
      textColor: Colors.white,
    ),

    // ── PATTERN ────────────────────────────────────────────────────────────
    PostBackground(
      id: 'pattern_dots_blue',
      label: 'Soft Dots',
      type: PostBackgroundType.pattern,
      pattern: PostBackgroundPattern.dots,
      patternBaseColor: Color(0xFFE8EAF6),
      patternDotColor: Color(0xFF9FA8DA),
      textColor: Color(0xFF283593),
    ),
    PostBackground(
      id: 'pattern_dots_green',
      label: 'Mint Dots',
      type: PostBackgroundType.pattern,
      pattern: PostBackgroundPattern.dots,
      patternBaseColor: Color(0xFFE8F5E9),
      patternDotColor: Color(0xFFA5D6A7),
      textColor: Color(0xFF2E7D32),
    ),
    PostBackground(
      id: 'pattern_waves',
      label: 'Minimal Waves',
      type: PostBackgroundType.pattern,
      pattern: PostBackgroundPattern.waves,
      patternBaseColor: Color(0xFFFFF3E0),
      patternDotColor: Color(0xFFFFCC80),
      textColor: Color(0xFFE65100),
    ),
    PostBackground(
      id: 'pattern_shapes',
      label: 'Abstract Shapes',
      type: PostBackgroundType.pattern,
      pattern: PostBackgroundPattern.shapes,
      patternBaseColor: Color(0xFFFCE4EC),
      patternDotColor: Color(0xFFF48FB1),
      textColor: Color(0xFFAD1457),
    ),
  ];
}

// ---------------------------------------------------------------------------
// Pattern Painters (lightweight, no assets)
// ---------------------------------------------------------------------------

/// Paints repeating small dots over a base colour.
class DotPatternPainter extends CustomPainter {
  final Color dotColor;
  final double spacing;
  final double radius;

  const DotPatternPainter({
    required this.dotColor,
    this.spacing = 20,
    this.radius = 2.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = dotColor;
    for (double x = spacing / 2; x < size.width; x += spacing) {
      for (double y = spacing / 2; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(DotPatternPainter old) =>
      old.dotColor != dotColor || old.spacing != spacing;
}

/// Paints gentle sinusoidal wave lines.
class WavePatternPainter extends CustomPainter {
  final Color waveColor;

  const WavePatternPainter({required this.waveColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = waveColor
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const waveHeight = 10.0;
    const waveLength = 40.0;
    const verticalSpacing = 28.0;

    for (double startY = 0; startY < size.height + verticalSpacing; startY += verticalSpacing) {
      final path = Path();
      path.moveTo(0, startY);
      for (double x = 0; x < size.width; x += waveLength) {
        path.relativeQuadraticBezierTo(
          waveLength / 4, -waveHeight,
          waveLength / 2, 0,
        );
        path.relativeQuadraticBezierTo(
          waveLength / 4, waveHeight,
          waveLength / 2, 0,
        );
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(WavePatternPainter old) => old.waveColor != waveColor;
}

/// Paints scattered small circles and rounded rectangles as abstract shapes.
class ShapePatternPainter extends CustomPainter {
  final Color shapeColor;

  const ShapePatternPainter({required this.shapeColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = shapeColor
      ..style = PaintingStyle.fill;

    final positions = [
      Offset(size.width * 0.1, size.height * 0.1),
      Offset(size.width * 0.85, size.height * 0.15),
      Offset(size.width * 0.5, size.height * 0.08),
      Offset(size.width * 0.2, size.height * 0.9),
      Offset(size.width * 0.75, size.height * 0.85),
      Offset(size.width * 0.9, size.height * 0.5),
      Offset(size.width * 0.05, size.height * 0.55),
      Offset(size.width * 0.45, size.height * 0.92),
    ];

    for (int i = 0; i < positions.length; i++) {
      final p = positions[i];
      if (i % 3 == 0) {
        canvas.drawCircle(p, 10, paint);
      } else if (i % 3 == 1) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: p, width: 22, height: 12),
            const Radius.circular(6),
          ),
          paint,
        );
      } else {
        canvas.drawCircle(p, 5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(ShapePatternPainter old) => old.shapeColor != shapeColor;
}
