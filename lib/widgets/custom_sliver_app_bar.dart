import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skeleton_core/skeleton_core.dart';

/// A reusable SliverAppBar widget with consistent styling and animations.
///
/// Features:
/// - Animated background color transition (transparent → primary color when collapsed)
/// - Flexible space bar with centered title
/// - Optional back button navigation
/// - Support for custom title widgets
/// - Opacity control for capture states
class CustomSliverAppBar extends StatelessWidget {
  /// The title text to display. Ignored if [titleWidget] is provided.
  final String? title;

  /// Custom widget for the title. Overrides [title] if provided.
  final Widget? titleWidget;

  /// Callback when back button is pressed. If null, no leading button is shown.
  final VoidCallback? onBackPressed;

  /// The height of the app bar when expanded.
  final double expandedHeight;

  /// Opacity of the app bar content (useful for capture states).
  final double opacity;

  /// Custom leading widget. Overrides default back button if provided.
  final Widget? leading;

  /// List of action widgets to display on the trailing side.
  final List<Widget>? actions;

  /// Padding around the title text.
  final EdgeInsets titlePadding;

  const CustomSliverAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.onBackPressed,
    this.expandedHeight = 100,
    this.opacity = 1.0,
    this.leading,
    this.actions,
    this.titlePadding = const EdgeInsets.all(kPaddingM),
  }) : assert(
          title != null || titleWidget != null,
          'Either title or titleWidget must be provided',
        );

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      shadowColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      pinned: true,
      stretch: true,
      expandedHeight: expandedHeight,
      flexibleSpace: Opacity(
        opacity: opacity,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double appBarHeight = constraints.biggest.height;
            final bool isCollapsed = appBarHeight <=
                kToolbarHeight + MediaQuery.of(context).padding.top;

            return AnimatedContainer(
              duration: const Duration(milliseconds: kAnimationDurationMedium),
              color: isCollapsed
                  ? Theme.of(context).primaryColor
                  : Colors.transparent,
              child: FlexibleSpaceBar(
                centerTitle: true,
                titlePadding: EdgeInsets.zero,
                title: Padding(
                  padding: titlePadding,
                  child: titleWidget != null
                      ? FittedBox(
                          fit: BoxFit.scaleDown,
                          child: titleWidget,
                        )
                      : FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            title!,
                            textAlign: TextAlign.center,
                            style:
                                AppTextStyles.displaySmallTitleScreen(context),
                          ),
                        ),
                ),
              ),
            );
          },
        ),
      ),
      leading: leading ??
          (onBackPressed != null
              ? Opacity(
                  opacity: opacity,
                  child: IconButton(
                    onPressed: onBackPressed,
                    icon: const Icon(FontAwesomeIcons.chevronLeft),
                  ),
                )
              : null),
      actions: actions,
    );
  }
}
