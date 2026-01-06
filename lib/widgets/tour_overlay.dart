import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch/helpers/ui_constants.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:nucatch/blocs/objects/tour/tour_bloc.dart';
import 'package:nucatch/blocs/objects/tour/tour_event.dart';
import 'package:nucatch/blocs/objects/tour/tour_state.dart';
import 'package:nucatch/helpers/tour_content.dart';

/// Tour overlay that manages SuperTooltip display
class TourOverlay extends StatefulWidget {
  final Map<TourStep, GlobalKey> targetKeys;

  const TourOverlay({
    super.key,
    required this.targetKeys,
  });

  @override
  State<TourOverlay> createState() => _TourOverlayState();
}

class _TourOverlayState extends State<TourOverlay> {
  SuperTooltipController? _tooltipController;

  @override
  void dispose() {
    _tooltipController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TourBloc, TourState>(
      listener: (context, state) {
        if (state.isTourActive) {
          _showTooltipForCurrentStep(state);
        } else {
          _hideTooltip();
        }
      },
      child: const SizedBox.shrink(),
    );
  }

  void _showTooltipForCurrentStep(TourState state) {
    // Hide previous tooltip
    _hideTooltip();

    // Get current step data
    final stepData = TourContent.getStep(state.currentStep);
    final targetKey = widget.targetKeys[stepData.step];

    if (targetKey == null || targetKey.currentContext == null) {
      // Target not available, skip to next step
      Future.delayed(const Duration(milliseconds: kAnimationDurationSlow), () {
        if (mounted) {
          context.read<TourBloc>().add(TourStepCompleted());
        }
      });
      return;
    }

    // Create new tooltip controller
    _tooltipController = SuperTooltipController();

    // Show tooltip after a short delay
    Future.delayed(const Duration(milliseconds: kAnimationDurationMedium), () {
      if (mounted && _tooltipController != null) {
        _tooltipController!.showTooltip();
      }
    });
  }

  void _hideTooltip() {
    _tooltipController?.dispose();
    _tooltipController = null;
  }
}
