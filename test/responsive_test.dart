import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qareeb/core/presentation/responsive/responsive.dart';

void main() {
  group('Responsive', () {
    testWidgets('uses 1.0 scale at the design baseline', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(390, 844)),
            child: Builder(
              builder: (context) {
                expect(Responsive.scaleOf(context), 1.0);
                expect(Responsive.horizontalPadding(context), 16);
                expect(Responsive.quranDeviceScale(context), 1.0);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('scales up on tablet while staying clamped', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(768, 1024)),
            child: Builder(
              builder: (context) {
                expect(Responsive.scaleOf(context), Responsive.maxScale);
                expect(
                  Responsive.horizontalPadding(context),
                  16 * Responsive.maxScale,
                );
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('scales down on small phones', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(320, 568)),
            child: Builder(
              builder: (context) {
                expect(
                  Responsive.scaleOf(context),
                  lessThan(1.0),
                );
                expect(
                  Responsive.scaleOf(context),
                  greaterThanOrEqualTo(Responsive.minScale),
                );
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
    });
  });
}
