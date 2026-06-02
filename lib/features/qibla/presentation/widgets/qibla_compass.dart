import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:qareeb/core/theme/app_theme.dart';

class QiblaCompass extends StatelessWidget {
  const QiblaCompass({
    required this.heading,
    required this.qiblaBearing,
    required this.isAligned,
    super.key,
  });

  final double heading;
  final double qiblaBearing;
  final bool isAligned;

  @override
  Widget build(BuildContext context) {
    final relativeQibla = _normalizeAngle(qiblaBearing - heading);

    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            angle: -heading * math.pi / 180,
            child: CustomPaint(
              size: const Size(280, 280),
              painter: _CompassDialPainter(isAligned: isAligned),
            ),
          ),
          Transform.rotate(
            angle: -relativeQibla * math.pi / 180,
            child: _QiblaNeedle(isAligned: isAligned),
          ),
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: isAligned ? AppColors.gold : AppColors.navy,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ],
      ),
    );
  }

  static double _normalizeAngle(double degrees) {
    var normalized = degrees % 360;
    if (normalized > 180) {
      normalized -= 360;
    } else if (normalized < -180) {
      normalized += 360;
    }
    return normalized;
  }
}

class _QiblaNeedle extends StatelessWidget {
  const _QiblaNeedle({required this.isAligned});

  final bool isAligned;

  @override
  Widget build(BuildContext context) {
    final color = isAligned ? AppColors.gold : AppColors.navy;

    return SizedBox(
      width: 120,
      height: 120,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.arrow_drop_up, size: 56, color: color),
          Icon(Icons.mosque, size: 36, color: color),
        ],
      ),
    );
  }
}

class _CompassDialPainter extends CustomPainter {
  _CompassDialPainter({required this.isAligned});

  final bool isAligned;

  static const _cardinals = ['N', 'E', 'S', 'W'];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final outerPaint = Paint()
      ..color = isAligned
          ? AppColors.gold.withValues(alpha: 0.25)
          : AppColors.navy.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, outerPaint);

    final ringPaint = Paint()
      ..color = isAligned ? AppColors.gold : AppColors.navy
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, radius - 2, ringPaint);

    final tickPaint = Paint()
      ..color = AppColors.navy.withValues(alpha: 0.35)
      ..strokeWidth = 1.5;

    List.generate(72, (i) {
      final angle = i * math.pi / 36;
      final isMajor = i % 18 == 0;
      final isMedium = i % 9 == 0;
      final tickLength = isMajor ? 18.0 : (isMedium ? 12.0 : 6.0);
      final innerRadius = radius - 24 - tickLength;
      final outerRadius = radius - 24;

      final start = Offset(
        center.dx + innerRadius * math.sin(angle),
        center.dy - innerRadius * math.cos(angle),
      );
      final end = Offset(
        center.dx + outerRadius * math.sin(angle),
        center.dy - outerRadius * math.cos(angle),
      );
      canvas.drawLine(start, end, tickPaint);
    });

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    List.generate(_cardinals.length, (i) {
      final label = _cardinals[i];
      final angle = i * math.pi / 2;
      final labelRadius = radius - 42;
      final offset = Offset(
        center.dx + labelRadius * math.sin(angle),
        center.dy - labelRadius * math.cos(angle),
      );

      textPainter.text = TextSpan(
        text: label,
        style: TextStyle(
          color: i == 0 ? AppColors.gold : AppColors.navy,
          fontSize: i == 0 ? 20 : 16,
          fontWeight: FontWeight.w700,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        offset - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    });
  }

  @override
  bool shouldRepaint(covariant _CompassDialPainter oldDelegate) {
    return oldDelegate.isAligned != isAligned;
  }
}
