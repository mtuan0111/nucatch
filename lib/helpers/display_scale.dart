import 'package:flutter/widgets.dart';

/// Tablets are held further away than phones and have far more room, so
/// phone-sized text and controls look tiny on them. On a tablet-sized window
/// everything text-based is drawn [kTabletTextScale]× larger (applied once,
/// to the whole text theme, in `main.dart`) and touch controls with a size
/// cap (keypad keys, Pick Right answers) may grow [kTabletControlScale]×.
///
/// Decided by the window, not the device: an iPad in a narrow split-screen
/// slot keeps phone sizes, and a foldable's inner screen (shortest side
/// ~670 pt, split into two narrow panes by its hinge) stays below the
/// threshold too.
const double kTabletMinShortestSide = 720;
const double kTabletTextScale = 1.2;
const double kTabletControlScale = 1.3;

bool isTabletWindow(Size size) => size.shortestSide >= kTabletMinShortestSide;

/// [kTabletTextScale] on a tablet-sized window, otherwise 1.
double textScaleForWindow(Size size) =>
    isTabletWindow(size) ? kTabletTextScale : 1.0;

/// [kTabletControlScale] on a tablet-sized window, otherwise 1. Reads
/// [MediaQuery.sizeOf], so callers rebuild when the window changes.
double controlScaleOf(BuildContext context) =>
    isTabletWindow(MediaQuery.sizeOf(context)) ? kTabletControlScale : 1.0;
