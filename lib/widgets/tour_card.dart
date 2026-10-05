import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:skeleton_core/skeleton_core.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/widgets/tour_spotlight.dart';

/// The spotlight shared by the menu tour (`GlobalTourWrapper`) and the
/// in-game rule tutorial (`TutorialOverlay`): dims everything except the
/// element being explained, blocks taps outside it, and places [card]
/// beside it — so every step of the tour, from the first menu step through the last
/// lesson, points at what it's talking about the same way.
class TourSpotlightLayer extends StatefulWidget {
  const TourSpotlightLayer({
    super.key,
    required this.measureTarget,
    required this.cardToken,
    required this.card,
    this.showCard = true,
    this.holeIsInteractive = false,
  });

  /// The spotlighted element's global rect, or [Rect.zero] for none (the
  /// card is then centered and nothing is highlighted).
  final Rect Function() measureTarget;

  /// Changes whenever the card's content does, so each new card fades in.
  final Object cardToken;
  final Widget card;

  /// False while the real UI is mid-animation and there's nothing to read.
  final bool showCard;

  /// Whether taps inside the highlight reach the element (a "tap this key"
  /// lesson) or are blocked like everywhere else (a step that only
  /// explains it).
  final bool holeIsInteractive;

  @override
  State<TourSpotlightLayer> createState() => _TourSpotlightLayerState();
}

class _TourSpotlightLayerState extends State<TourSpotlightLayer> {
  Rect _measured = Rect.zero;
  DateTime _watchUntil = DateTime.now();
  bool _watching = false;

  /// [TourSpotlightLayer.measureTarget] (global coordinates) in this
  /// layer's own coordinates — the hole and card are laid out in those, and
  /// the two differ whenever the layer itself is offset, e.g. while the
  /// in-game screen hosting it is still sliding in.
  Rect _measureLocal() {
    final target = widget.measureTarget();
    if (target == Rect.zero) return target;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.attached || !box.hasSize) return target;
    return target.shift(-box.localToGlobal(Offset.zero));
  }

  /// Keeps re-measuring for a short while after every build and rebuilds
  /// whenever the target has moved. [build] reads positions from the
  /// previous frame's layout, and the target keeps moving after it — the
  /// page it's on sliding in, a list scrolling it into view, fold/unfold,
  /// rotation — so without this the hole (the only place taps get through)
  /// would stay where the element used to be.
  void _watch() {
    _watchUntil = DateTime.now().add(const Duration(milliseconds: 800));
    if (_watching) return;
    _watching = true;
    WidgetsBinding.instance.addPostFrameCallback(_check);
  }

  void _check(Duration _) {
    if (!mounted) {
      _watching = false;
      return;
    }
    if (_measureLocal() != _measured) {
      _watching = false;
      setState(() {}); // build re-measures and calls _watch again
      return;
    }
    if (DateTime.now().isBefore(_watchUntil)) {
      WidgetsBinding.instance
        ..addPostFrameCallback(_check)
        ..scheduleFrame();
    } else {
      _watching = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Re-measure whenever the window or its hinge changes; see [_watch].
    MediaQuery.sizeOf(context);
    MediaQuery.displayFeaturesOf(context);
    final targetRect = _measured = _measureLocal();
    _watch();

    return Stack(
      children: [
        Positioned.fill(
          child: TourHoleBlocker(
            holeRect: targetRect,
            holeIsInteractive: widget.holeIsInteractive &&
                widget.showCard &&
                targetRect != Rect.zero,
            child: CustomPaint(
              painter: TourSpotlightPainter(targetRect: targetRect),
            ),
          ),
        ),
        if (widget.showCard)
          Positioned.fill(
            child: TourCardPlacement(
              key: ValueKey(widget.cardToken),
              targetRect: targetRect,
              child: widget.card,
            ),
          ),
      ],
    );
  }
}

/// Lays a tour card out next to the spotlight — below it when there's
/// more room there, above it otherwise, centered on screen for
/// a [Rect.zero] target (nothing to point at).
///
/// Positioned from [targetRect] directly (the same global rect the
/// spotlight hole is painted from) rather than through an overlay-entry
/// tooltip: those snapshot the anchor's position once, when the entry is
/// created, so a card built while its host screen was still settling into
/// place stayed stuck off-screen for the whole lesson.
class TourCardPlacement extends StatelessWidget {
  final Rect targetRect;
  final Widget child;

  const TourCardPlacement({
    super.key,
    required this.targetRect,
    required this.child,
  });

  static const double _maxCardWidth = 380;
  static const double _minCardWidth = 260;
  static const double _gap = kSpaceM;

  /// Below this much height above/below the spotlight (a tall keypad
  /// highlight) a portrait card goes beside the spotlight instead.
  static const double _minVerticalSpace = 200;

  /// The pane (sub-screen between hinges) the card goes in: the whole
  /// window when there's no hinge, else the pane overlapping [targetRect]
  /// least, the larger one on a tie.
  Rect _pickPane(List<Rect> panes) {
    double overlap(Rect pane) {
      if (targetRect == Rect.zero || !pane.overlaps(targetRect)) return 0;
      final r = pane.intersect(targetRect);
      return r.width * r.height;
    }

    double area(Rect r) => r.width * r.height;
    return panes.reduce((a, b) {
      final oa = overlap(a), ob = overlap(b);
      if (oa != ob) return oa < ob ? a : b;
      return area(a) >= area(b) ? a : b;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final padding = mediaQuery.padding;
    return LayoutBuilder(builder: (context, constraints) {
      final size = constraints.biggest;
      // On a half-opened foldable (or a dual-screen device) keep the card
      // inside one pane — the one overlapping the spotlight least — so it
      // never straddles the hinge.
      final pane = _pickPane(
        DisplayFeatureSubScreen.subScreensInBounds(
          Offset.zero & size,
          DisplayFeatureSubScreen.avoidBounds(mediaQuery),
        ).toList(),
      );
      final safe = Rect.fromLTRB(
        math.max(pane.left, padding.left) + kPaddingL,
        math.max(pane.top, padding.top) + kSpaceM,
        math.min(pane.right, size.width - padding.right) - kPaddingL,
        math.min(pane.bottom, size.height - padding.bottom) - kSpaceM,
      );
      final fullWidth = safe.width.clamp(0.0, _maxCardWidth);

      final card = TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 200),
        builder: (context, opacity, child) =>
            Opacity(opacity: opacity, child: child),
        child: child,
      );

      Widget place(Rect area, {required Alignment alignment}) {
        final width = area.width.clamp(0.0, fullWidth);
        return Stack(children: [
          Positioned.fromRect(
            rect: area,
            child: Align(
              alignment: alignment,
              child: SizedBox(
                width: width,
                // Caps the card at the free space; TourCard then
                // scrolls its body text, never its title or buttons.
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: area.height),
                  child: card,
                ),
              ),
            ),
          ),
        ]);
      }

      if (targetRect == Rect.zero) {
        return place(safe, alignment: Alignment.center);
      }
      if (!targetRect.overlaps(safe)) {
        // The spotlight is in the other pane: sit level with it.
        final y = ((targetRect.center.dy - safe.top) / safe.height * 2 - 1)
            .clamp(-1.0, 1.0);
        return place(safe, alignment: Alignment(0, y));
      }

      final below = Rect.fromLTRB(
          safe.left, targetRect.bottom + _gap, safe.right, safe.bottom);
      final above =
          Rect.fromLTRB(safe.left, safe.top, safe.right, targetRect.top - _gap);
      final vertical = below.height >= above.height ? below : above;
      final verticalAlign = identical(vertical, below)
          ? Alignment.topCenter
          : Alignment.bottomCenter;

      final right = Rect.fromLTRB(
          targetRect.right + _gap, safe.top, safe.right, safe.bottom);
      final left = Rect.fromLTRB(
          safe.left, safe.top, targetRect.left - _gap, safe.bottom);
      final side = right.width >= left.width ? right : left;
      final sideFits = side.width >= _minCardWidth;
      final verticalFits = vertical.height >= _minVerticalSpace;

      // Landscape has width to spare and little height, so beside the
      // spotlight is tried first; portrait is the other way round.
      final landscape = safe.width > safe.height;
      if (landscape ? sideFits : !verticalFits && sideFits) {
        return place(side, alignment: Alignment.center);
      }
      if (verticalFits || sideFits) {
        return place(vertical, alignment: verticalAlign);
      }
      // Nowhere beside the spotlight has room for the title and buttons
      // (e.g. a spotlight filling most of a landscape phone): overlapping
      // it beats squeezing the card until it overflows.
      return place(safe, alignment: Alignment.center);
    });
  }
}

/// A tour step's card, built from the same pieces as the app's dialogs
/// (`AlertTemplate`): a gradient title bar, a body panel with the
/// description, progress and "Skip Tour", and the red-Previous /
/// green-Next [CustomElevatedButton] pair. A null [onPrevious] or [onNext]
/// hides that button.
class TourCard extends StatelessWidget {
  const TourCard({
    super.key,
    required this.title,
    required this.description,
    required this.progress,
    required this.onSkip,
    this.onPrevious,
    this.onNext,
    this.nextLabel,
  });

  final String title;

  /// May contain `**bold**` markers.
  final String description;

  /// e.g. "3 / 34" — see `TourProgress`.
  final String progress;
  final VoidCallback onSkip;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  /// Defaults to the localized "Next".
  final String? nextLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonTheme = CustomButtonTheme.of(context);

    // Same resolution as AlertTemplate's title and body.
    final titleBackgroundColor = buttonTheme?.dialogTitleBackgroundColor;
    final bodyBackgroundColor =
        buttonTheme?.dialogBackgroundColor ?? theme.scaffoldBackgroundColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomElevatedButton(
          text: title,
          buttonSize: ButtonSize.small,
          shapeAt:
              buttonTheme?.dialogTitleShapeAt ?? RoundedWithShapeAt.topLeft,
          color: titleBackgroundColor?.getSmartColor(context) ??
              theme.colorScheme.onPrimary,
          backgroundColor: titleBackgroundColor,
          gradient: titleBackgroundColor == null
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [theme.primaryColor, theme.secondaryHeaderColor],
                )
              : null,
        ),
        Flexible(
          // At the largest font sizes, or in the little height phone
          // landscape leaves, only the description scrolls — the title and
          // the Previous/Next buttons always stay on screen.
          child: SingleChildScrollView(
            child: CustomElevatedButton(
              backgroundColor: bodyBackgroundColor,
              color: bodyBackgroundColor.getSmartColor(context),
              shapeAt: RoundedWithShapeAt.topRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    kPaddingL, kSpaceM, kPaddingL, kSpaceXS),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        style: AppTextStyles.withColor(
                            AppTextStyles.bodyLargeBold(context),
                            theme.colorScheme.primary.getDarker()),
                        children: tourBoldSpans(description),
                      ),
                    ),
                    const SizedBox(height: kSpaceS),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            progress,
                            style: AppTextStyles.withColor(
                                AppTextStyles.bodySmall(context),
                                theme.colorScheme.secondary.getDarker()),
                          ),
                        ),
                        Flexible(
                          child: TextButton(
                            onPressed: onSkip,
                            child: Text(
                              lang(context).tourSkip,
                              textAlign: TextAlign.end,
                              style: AppTextStyles.withColor(
                                  AppTextStyles.bodyMediumBold(context),
                                  theme.colorScheme.secondary),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (onPrevious != null || onNext != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                if (onPrevious != null)
                  Expanded(
                    child: CustomElevatedButton(
                      text: lang(context).tourPrevious,
                      onPressed: onPrevious,
                      color: theme.colorScheme.onError,
                      backgroundColor: theme.colorScheme.error,
                      buttonSize: ButtonSize.small,
                      shapeAt: RoundedWithShapeAt.topRight,
                    ),
                  ),
                if (onPrevious != null && onNext != null)
                  const SizedBox(width: kSpaceM),
                if (onNext != null)
                  Expanded(
                    child: CustomElevatedButton(
                      text: nextLabel ?? lang(context).tourNext,
                      onPressed: onNext,
                      color: theme.colorScheme.onPrimary,
                      backgroundColor: theme.primaryColor,
                      buttonSize: ButtonSize.small,
                      shapeAt: RoundedWithShapeAt.topLeft,
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Splits [text] on `**bold**` markers (used throughout the tour and lesson strings)
/// into plain and bold spans, so the markers never render literally.
List<TextSpan> tourBoldSpans(String text) {
  final spans = <TextSpan>[];
  var lastIndex = 0;
  for (final match in RegExp(r'\*\*(.*?)\*\*').allMatches(text)) {
    if (match.start > lastIndex) {
      spans.add(TextSpan(text: text.substring(lastIndex, match.start)));
    }
    spans.add(TextSpan(
      text: match.group(1),
      style: const TextStyle(fontWeight: FontWeight.bold),
    ));
    lastIndex = match.end;
  }
  if (lastIndex < text.length) {
    spans.add(TextSpan(text: text.substring(lastIndex)));
  }
  return spans;
}
