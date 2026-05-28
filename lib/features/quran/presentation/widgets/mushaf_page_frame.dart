import 'package:flutter/material.dart';
import 'package:qareeb/core/presentation/responsive/responsive.dart';
import 'package:qareeb/features/quran/presentation/theme/quran_reader_theme.dart';

/// Traditional mushaf-style double border with corner ornaments around page content.
class MushafPageFrame extends StatelessWidget {
  const MushafPageFrame({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final borderColor = QuranReaderTheme.ornamentBorderOf(context);
    final goldColor = QuranReaderTheme.ornamentGoldOf(context);
    final background = QuranReaderTheme.pageBackgroundOf(context);
    final outerMargin = Responsive.spacing(context, 6);
    final innerGap = Responsive.spacing(context, 5);
    final contentInset = Responsive.spacing(context, 10);
    final cornerSize = Responsive.spacing(context, 22);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        outerMargin,
        outerMargin,
        outerMargin,
        Responsive.spacing(context, 4),
      ),
      child: SizedBox.expand(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: background,
            border: Border.all(color: borderColor, width: 1.5),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Padding(
                padding: EdgeInsets.all(innerGap),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: goldColor.withValues(alpha: 0.55),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Positioned(
                top: innerGap,
                left: innerGap,
                child: _MushafCornerOrnament(
                  size: cornerSize,
                  color: goldColor,
                  quadrant: _MushafCorner.topLeft,
                ),
              ),
              Positioned(
                top: innerGap,
                right: innerGap,
                child: _MushafCornerOrnament(
                  size: cornerSize,
                  color: goldColor,
                  quadrant: _MushafCorner.topRight,
                ),
              ),
              Positioned(
                bottom: innerGap,
                left: innerGap,
                child: _MushafCornerOrnament(
                  size: cornerSize,
                  color: goldColor,
                  quadrant: _MushafCorner.bottomLeft,
                ),
              ),
              Positioned(
                bottom: innerGap,
                right: innerGap,
                child: _MushafCornerOrnament(
                  size: cornerSize,
                  color: goldColor,
                  quadrant: _MushafCorner.bottomRight,
                ),
              ),
              Positioned.fill(
                child: CustomPaint(
                  painter: _MushafEdgeOrnamentPainter(
                    inset: innerGap + 2,
                    color: goldColor.withValues(alpha: 0.45),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  innerGap + contentInset,
                  innerGap + contentInset,
                  innerGap + contentInset,
                  innerGap + contentInset,
                ),
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _MushafCorner { topLeft, topRight, bottomLeft, bottomRight }

class _MushafCornerOrnament extends StatelessWidget {
  const _MushafCornerOrnament({
    required this.size,
    required this.color,
    required this.quadrant,
  });

  final double size;
  final Color color;
  final _MushafCorner quadrant;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _MushafCornerPainter(color: color, quadrant: quadrant),
    );
  }
}

class _MushafCornerPainter extends CustomPainter {
  const _MushafCornerPainter({required this.color, required this.quadrant});

  final Color color;
  final _MushafCorner quadrant;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;

    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final r = size.width * 0.22;

    switch (quadrant) {
      case _MushafCorner.topLeft:
        path
          ..moveTo(0, size.height * 0.55)
          ..lineTo(0, r)
          ..quadraticBezierTo(0, 0, r, 0)
          ..lineTo(size.width * 0.55, 0);
        canvas.drawCircle(Offset(r * 1.1, r * 1.1), 2.2, fill);
      case _MushafCorner.topRight:
        path
          ..moveTo(size.width * 0.45, 0)
          ..lineTo(size.width - r, 0)
          ..quadraticBezierTo(size.width, 0, size.width, r)
          ..lineTo(size.width, size.height * 0.55);
        canvas.drawCircle(
          Offset(size.width - r * 1.1, r * 1.1),
          2.2,
          fill,
        );
      case _MushafCorner.bottomLeft:
        path
          ..moveTo(0, size.height * 0.45)
          ..lineTo(0, size.height - r)
          ..quadraticBezierTo(0, size.height, r, size.height)
          ..lineTo(size.width * 0.55, size.height);
        canvas.drawCircle(
          Offset(r * 1.1, size.height - r * 1.1),
          2.2,
          fill,
        );
      case _MushafCorner.bottomRight:
        path
          ..moveTo(size.width, size.height * 0.45)
          ..lineTo(size.width, size.height - r)
          ..quadraticBezierTo(
            size.width,
            size.height,
            size.width - r,
            size.height,
          )
          ..lineTo(size.width * 0.45, size.height);
        canvas.drawCircle(
          Offset(size.width - r * 1.1, size.height - r * 1.1),
          2.2,
          fill,
        );
    }

    canvas.drawPath(path, stroke);
  }

  @override
  bool shouldRepaint(covariant _MushafCornerPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.quadrant != quadrant;
}

/// Small diamond markers centered on each edge (between corners).
class _MushafEdgeOrnamentPainter extends CustomPainter {
  const _MushafEdgeOrnamentPainter({
    required this.inset,
    required this.color,
  });

  final double inset;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final centers = [
      Offset(size.width / 2, inset),
      Offset(size.width / 2, size.height - inset),
      Offset(inset, size.height / 2),
      Offset(size.width - inset, size.height / 2),
    ];

    for (final center in centers) {
      _drawDiamond(canvas, center, 3.5, paint);
    }
  }

  void _drawDiamond(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path()
      ..moveTo(center.dx, center.dy - radius)
      ..lineTo(center.dx + radius, center.dy)
      ..lineTo(center.dx, center.dy + radius)
      ..lineTo(center.dx - radius, center.dy)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _MushafEdgeOrnamentPainter oldDelegate) =>
      oldDelegate.inset != inset || oldDelegate.color != color;
}
