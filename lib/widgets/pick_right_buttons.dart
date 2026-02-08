import 'package:flutter/material.dart';
import 'package:nucatch/helpers/helper.dart';
import 'package:nucatch/helpers/template.dart';
import 'package:nucatch/helpers/ui_constants.dart';
import 'package:nucatch/helpers/app_text_styles.dart';

/// Three-button vertical layout for Pick Right difficulty mode
/// Displays three equations for the player to choose from
class PickRightButtons extends StatefulWidget {
  final List<String> equations; // List of 3 equations
  final Function(int, Offset?)
      onButtonTap; // button index (0, 1, 2) with position
  final bool isEnabled;
  final int? selectedOption; // Highlight selected button

  const PickRightButtons({
    super.key,
    required this.equations,
    required this.onButtonTap,
    this.isEnabled = true,
    this.selectedOption,
  });

  @override
  State<PickRightButtons> createState() => _PickRightButtonsState();
}

class _PickRightButtonsState extends State<PickRightButtons> {
  final List<GlobalKey> _buttonKeys = [GlobalKey(), GlobalKey(), GlobalKey()];

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
    return Column(
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
