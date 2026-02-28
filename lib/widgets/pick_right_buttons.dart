import 'package:flutter/material.dart';
import 'package:nucatch/helpers/helper.dart';
import 'package:nucatch/helpers/template.dart';
import 'package:nucatch/helpers/ui_constants.dart';
import 'package:nucatch/helpers/app_text_styles.dart';

/// Three-button vertical layout for Pick Right difficulty mode
/// Displays three equations for the player to choose from
///
/// Animation flow:
/// 1. Correct tap → [isCorrectAnimating] = true → scale up (1.3x) + fade out
/// 2. New equations generated → widget rebuilds via [ValueKey]
/// 3. New widget mounts → entrance fade-in + scale from 0.8 → 1.0
class PickRightButtons extends StatefulWidget {
  final List<String> equations; // List of 3 equations
  final Function(int, Offset?)
      onButtonTap; // button index (0, 1, 2) with position
  final bool isEnabled;
  final int? selectedOption; // Highlight selected button
  final bool isCorrectAnimating; // Drive scale+fade-out animation

  const PickRightButtons({
    super.key,
    required this.equations,
    required this.onButtonTap,
    this.isEnabled = true,
    this.selectedOption,
    this.isCorrectAnimating = false,
  });

  @override
  State<PickRightButtons> createState() => _PickRightButtonsState();
}

class _PickRightButtonsState extends State<PickRightButtons>
    with SingleTickerProviderStateMixin {
  final List<GlobalKey> _buttonKeys = [GlobalKey(), GlobalKey(), GlobalKey()];
  late AnimationController _entranceController;
  late Animation<double> _entranceOpacity;
  late Animation<double> _entranceScale;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _entranceOpacity = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOut,
    );
    _entranceScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Curves.easeOutBack,
      ),
    );
    // Trigger entrance animation after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        print(
            '🎬 [PickRight] Entrance animation START - equations: ${widget.equations}');
        _entranceController.forward();
      }
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  Offset? _getButtonCenter(GlobalKey key) {
    final RenderBox? renderBox =
        key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final position = renderBox.localToGlobal(Offset.zero);
      final size = renderBox.size;
      return position + Offset(size.width / 2, size.height / 2);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    print(
        '🎬 [PickRight] build - isCorrectAnimating: ${widget.isCorrectAnimating}, isEnabled: ${widget.isEnabled}, equations: ${widget.equations}');
    // Exit animation: scale up + fade out on correct answer
    return AnimatedScale(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutQuart,
      scale: widget.isCorrectAnimating ? 1.3 : 1.0,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutQuart,
        opacity: widget.isCorrectAnimating ? 0.0 : 1.0,
        // Entrance animation: fade-in + scale from 0.85 → 1.0
        child: FadeTransition(
          opacity: _entranceOpacity,
          child: ScaleTransition(
            scale: _entranceScale,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int i = 0; i < widget.equations.length && i < 3; i++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: kSpaceS),
                      child: _buildEquationButton(
                        context: context,
                        equation: widget.equations[i],
                        buttonIndex: i,
                        color: Theme.of(context).primaryColor,
                        buttonKey: _buttonKeys[i],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEquationButton({
    required BuildContext context,
    required String equation,
    required int buttonIndex,
    required Color color,
    required GlobalKey buttonKey,
  }) {
    final isSelected = widget.selectedOption == buttonIndex;

    return CustomElevatedButton(
      key: buttonKey,
      onPressed: widget.isEnabled
          ? () {
              final position = _getButtonCenter(buttonKey);
              widget.onButtonTap(buttonIndex, position);
            }
          : null,
      backgroundColor:
          isSelected ? color.withOpacity(0.8) : color.withOpacity(0.6),
      shapeAt: RoundedWithShapeAt.all,
      buttonRadius: kBorderRadiusL,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: kSpaceL,
          horizontal: kSpaceM,
        ),
        child: Center(
          child: Text(
            equation,
            style: AppTextStyles.titleLarge(context).copyWith(
              fontSize: kFontSizeXL,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
