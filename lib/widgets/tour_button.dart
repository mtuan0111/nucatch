import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/objects/tour/tour_bloc.dart';
import 'package:nucatch/blocs/objects/tour/tour_event.dart';
import 'package:nucatch/blocs/objects/tour/tour_state.dart';

/// Tour button widget with pulsing animation for first-time users
class TourButton extends StatefulWidget {
  const TourButton({super.key});

  @override
  State<TourButton> createState() => _TourButtonState();
}

class _TourButtonState extends State<TourButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TourBloc, TourState>(
      builder: (context, state) {
        final shouldPulse = state.shouldShowTour && !state.isTourActive;

        return GestureDetector(
          onTap: () {
            context.read<TourBloc>().add(TourStarted());
          },
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.5),
                  blurRadius: shouldPulse ? 20 : 10,
                  spreadRadius: shouldPulse ? 5 : 2,
                ),
              ],
            ),
            child: shouldPulse
                ? ScaleTransition(
                    scale: _pulseAnimation,
                    child: _buildIcon(context),
                  )
                : _buildIcon(context),
          ),
        );
      },
    );
  }

  Widget _buildIcon(BuildContext context) {
    return Icon(
      FontAwesomeIcons.compass,
      color: Theme.of(context).colorScheme.onPrimary,
      size: 28,
    );
  }
}
