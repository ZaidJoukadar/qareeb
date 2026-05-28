import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qareeb/core/theme/app_theme.dart';

/// Opens a [showBarModalBottomSheet] styled for Qareeb (Slack/Facebook-style bar).
///
/// Keep [expand] false so the sheet stays anchored to the bottom. With
/// [expand] true the route fills the screen from the top and the drag bar sits
/// under the status bar.
///
/// Use [ModalScrollController.of] on the primary scroll view inside [builder] so
/// drag-to-dismiss stays in sync with scrolling.
Future<T?> showAppBarModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool expand = false,
  /// When true, opens at half height and snaps to near-full (see
  /// [AppBarModalSnapBody]). Scrollable content should omit a controller so
  /// [PrimaryScrollController] can link drag-to-expand.
  bool snap = false,
  bool useRootNavigator = false,
  bool isDismissible = true,
  bool enableDrag = true,
  Color? backgroundColor,
  Color? barrierColor,
  Widget? topControl,
}) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;
  final resolvedBarrier = barrierColor ??
      (isDark
          ? Colors.black.withValues(alpha: 0.65)
          : AppColors.navy.withValues(alpha: 0.45));
  final handle = topControl ?? _BarDragHandle(isDark: isDark);

  if (snap) {
    return showModalBottomSheet<T>(
      context: context,
      useRootNavigator: useRootNavigator,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      barrierColor: resolvedBarrier,
      builder: (sheetContext) {
        return AppBarModalSnapBody(
          builder: (context, scrollController) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                Center(child: handle),
                const SizedBox(height: 8),
                Expanded(
                  child: PrimaryScrollController(
                    controller: scrollController,
                    child: builder(context),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  return showBarModalBottomSheet<T>(
    context: context,
    expand: expand,
    useRootNavigator: useRootNavigator,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    backgroundColor: backgroundColor ?? theme.colorScheme.surface,
    barrierColor: resolvedBarrier,
    topControl: handle,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: builder,
  );
}

/// Bounds scrollable bar-modal content and wires [ModalScrollController].
class AppBarModalScrollBody extends StatelessWidget {
  const AppBarModalScrollBody({
    required this.child,
    this.maxHeightFactor = 0.9,
    super.key,
  });

  final Widget child;
  final double maxHeightFactor;

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height * maxHeightFactor;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: child,
      ),
    );
  }
}

/// Fixed-height bar-modal body for a header plus scrollable list.
class AppBarModalListBody extends StatelessWidget {
  const AppBarModalListBody({
    required this.header,
    required this.list,
    this.heightFactor = 0.6,
    super.key,
  });

  final Widget header;
  final Widget list;
  final double heightFactor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * heightFactor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          header,
          Expanded(child: list),
        ],
      ),
    );
  }
}

class AppBarModalSnapBody extends StatelessWidget {
  const AppBarModalSnapBody({
    required this.builder,
    this.initialSize = 0.5,
    this.minSize = 0.5,
    this.maxSize = 0.99,
    this.snapSizes = const [0.5, 0.90],
    super.key,
  });

  final Widget Function(BuildContext context, ScrollController scrollController)
      builder;
  final double initialSize;
  final double minSize;
  final double maxSize;
  final List<double> snapSizes;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final surfaceColor = Theme.of(context).colorScheme.surface;

    return SizedBox(
      height: screenHeight,
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: initialSize,
        minChildSize: minSize,
        maxChildSize: maxSize,
        snap: true,
        snapSizes: snapSizes,
        builder: (context, scrollController) {
          return Material(
            color: surfaceColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            clipBehavior: Clip.antiAlias,
            child: builder(context, scrollController),
          );
        },
      ),
    );
  }
}

class _BarDragHandle extends StatelessWidget {
  const _BarDragHandle({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6,
      width: 40,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.cream.withValues(alpha: 0.45)
            : AppColors.navy.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
