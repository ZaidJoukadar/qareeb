import 'package:flutter/material.dart';
import 'package:qareeb/features/quran/presentation/theme/quran_reader_theme.dart';
import 'package:qcf_quran_lite/qcf_quran_lite.dart' hide Ayah, Surah;

/// Decorative surah title banner (Mushaf-style).
class SurahHeaderFrame extends StatelessWidget {
  const SurahHeaderFrame({required this.surahNameArabic, super.key});

  final String surahNameArabic;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: QuranReaderTheme.pageBackground,
                  border: Border.all(
                    color: QuranReaderTheme.ornamentBorder,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  surahNameArabic,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: QuranTextStyles.hafsStyle(
                    fontSize: 28,
                    height: 1.4,
                    color: QuranReaderTheme.arabicText,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                child: _CornerOrnament(flip: false),
              ),
              Positioned(
                right: 0,
                child: _CornerOrnament(flip: true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CornerOrnament extends StatelessWidget {
  const _CornerOrnament({required this.flip});

  final bool flip;

  @override
  Widget build(BuildContext context) {
    return Transform.flip(
      flipX: flip,
      child: CustomPaint(
        size: const Size(18, 18),
        painter: _CornerPainter(),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = QuranReaderTheme.ornamentGold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0);

    canvas.drawPath(path, paint);
    canvas.drawCircle(
      Offset(size.width * 0.35, size.height * 0.35),
      2,
      paint..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
