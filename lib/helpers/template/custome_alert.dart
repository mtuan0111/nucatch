import 'package:flutter/material.dart';
import 'package:nucatch/blocs/navs/player/player_nav_cubit.dart';
import 'package:nucatch/blocs/objects/turn/turn_bloc.dart';
import 'package:nucatch/blocs/objects/turn/turn_event.dart';
import 'package:nucatch/blocs/objects/turn/turn_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/helper.dart';
import 'package:nucatch/helpers/template.dart';

class MenuAlert extends StatelessWidget {
  final int point;
  final int? rank;
  final TurnBloc turnBloc;
  final TurnState turnState;
  final PlayerNavCubit playerNavCubit;

  const MenuAlert({
    super.key,
    this.point = 0,
    this.rank,
    required this.turnBloc,
    required this.turnState,
    required this.playerNavCubit,
  });

  @override
  Widget build(BuildContext context) {
    return AlertTemplate(
      title: lang(context).mainMenu,
      message: lang(context).confirmExit,
      content: Column(
        spacing: 5,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (rank != null) RankingSortingWidget(position: rank!),
          if (rank != null) const SizedBox(height: 20),
          Text(
            "${lang(context).yourScoreIs}: $point",
            style: TextStyle(
              color: Theme.of(context).secondaryHeaderColor,
              fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            "${lang(context).difficulty}: ${Helper.getTitleFromDifficulty(context, turnState.difficultyModel!.difficulty)}",
            style: TextStyle(
              color: Theme.of(context).secondaryHeaderColor,
              fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          AnimatedButton(
            context,
            iconData: Helper.getIconFromDifficulty(
              context,
              turnState.difficultyModel!.difficulty,
            ),
            shapeAt: RoundedWithShapeAt.topLeft,
            // backgroundColor: Colors.white70,
            // color: Colors.black87,
            buttonSize: ButtonSize.smallest,

            // icon: Icon(Helper.getIconFromDifficulty(
            //     context, turnState.difficultyModel!.difficulty)),
            onPressed: () {
              showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (context) => AlertTemplate(
                  title: lang(context).difficultySetting,
                  message: lang(context).confirmChangeDifficulty,
                  possitiveButtonLabel: lang(context).yes,
                  onPossitiveButtonPressed: () =>
                      Navigator.of(context).pop(true),
                  negativeButtonLabel: lang(context).no,
                  onNegativeButtonPressed: () =>
                      Navigator.of(context).pop(false),
                ),
              ).then((confirmed) {
                if (confirmed == true) {
                  turnBloc.add(SaveRecorded(
                    callback: () {
                      playerNavCubit.showSetDifficulty();
                      Navigator.of(context).pop(false);
                    },
                  ));
                }
              });
            },
          )
        ],
      ),
      possitiveButtonLabel: lang(context).yes,
      onPossitiveButtonPressed: () => Navigator.of(context).pop(true),
      negativeButtonLabel: lang(context).no,
      onNegativeButtonPressed: () => Navigator.of(context).pop(false),
    );
  }
}

class AlertTemplate extends StatelessWidget {
  final String title;
  final String? message;
  final Widget? content;
  // final List<Widget> actions;
  final String? possitiveButtonLabel;
  final VoidCallback? onPossitiveButtonPressed;
  final String? negativeButtonLabel;
  final VoidCallback? onNegativeButtonPressed;

  const AlertTemplate({
    super.key,
    required this.title,
    this.message,
    this.content,
    // required this.actions,
    this.possitiveButtonLabel,
    this.onPossitiveButtonPressed,
    this.negativeButtonLabel,
    this.onNegativeButtonPressed,
  });

  Widget _buildPossitiveButton(BuildContext context) {
    return CustomElevatedButton(
      text: possitiveButtonLabel ?? lang(context).yes,
      onPressed: onPossitiveButtonPressed ?? () => Navigator.of(context).pop(),
      color: Theme.of(context).scaffoldBackgroundColor,
      backgroundColor: Theme.of(context).primaryColor,
      buttonSize: ButtonSize.small,
      shapeAt: RoundedWithShapeAt.topLeft,
    );
  }

  Widget _buildNegativeButton(BuildContext context) {
    return CustomElevatedButton(
      text: negativeButtonLabel ?? lang(context).no,
      onPressed: onNegativeButtonPressed ?? () => Navigator.of(context).pop(),
      color: Theme.of(context).scaffoldBackgroundColor,
      backgroundColor: Theme.of(context).colorScheme.error,
      buttonSize: ButtonSize.small,
      shapeAt: RoundedWithShapeAt.topRight,
    );
  }

  @override
  Widget build(BuildContext context) {
    return
        // Dialog(
        //       backgroundColor: Colors.transparent,
        //       child: Column(
        //         mainAxisSize: MainAxisSize.min,
        //         children: [
        //           // Main dialog content
        //           Container(
        //             decoration: BoxDecoration(
        //               color: Theme.of(context).scaffoldBackgroundColor,
        //               borderRadius: BorderRadius.circular(20),
        //             ),
        //             child: Column(
        //               mainAxisSize: MainAxisSize.min,
        //               children: [
        //                 // Title section
        //                 Stack(
        //                   clipBehavior: Clip.none,
        //                   children: [
        //                     Positioned(
        //                       top: -40,
        //                       left: 0,
        //                       right: 0,
        //                       child: Center(
        //                         child: CustomElevatedButton(
        //                           text: title,
        //                           buttonSize: ButtonSize.small,
        //                           shapeAt: RoundedWithShapeAt.topLeft,
        //                           color: Colors.black87,
        //                         ),
        //                       ),
        //                     ),
        //                     Padding(
        //                       padding: const EdgeInsets.all(20),
        //                       child: Column(
        //                         children: [
        //                           const SizedBox(
        //                               height: 20), // Space for positioned title
        //                           if (message != null)
        //                             Text(
        //                               message!,
        //                               style: TextStyle(
        //                                 color: Theme.of(context).hintColor,
        //                                 fontSize: Theme.of(context)
        //                                     .textTheme
        //                                     .bodyMedium!
        //                                     .fontSize,
        //                               ),
        //                               textAlign: TextAlign.center,
        //                             ),
        //                         ],
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //                 // Content section
        //                 Padding(
        //                   padding: const EdgeInsets.only(
        //                       left: 20, right: 20, bottom: 20),
        //                   child: content,
        //                 ),
        //               ],
        //             ),
        //           ),
        //           // Buttons outside the dialog
        //           const SizedBox(height: 20),
        //           Padding(
        //             padding: const EdgeInsets.symmetric(horizontal: 20),
        //             child: Row(
        //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //               children: [
        //                 if (negativeButtonLabel != null)
        //                   Expanded(child: _buildNegativeButton(context)),
        //                 if (negativeButtonLabel != null &&
        //                     possitiveButtonLabel != null)
        //                   const SizedBox(width: 10),
        //                 if (possitiveButtonLabel != null)
        //                   Expanded(child: _buildPossitiveButton(context)),
        //               ],
        //             ),
        //           ),
        //         ],
        //       ),
        //     ) ??
        Dialog(
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(20),
      // ),
      // clipBehavior: Clip.none,
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main dialog content
          Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        shapeAt: RoundedWithShapeAt.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (content != null) content!,
                              // const SizedBox(height: 70), // Space for buttons
                              if (message != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    message!,
                                    style: TextStyle(
                                      color: Theme.of(context).hintColor,
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .fontSize,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Title positioned on top
          Positioned(
            top: 0,
            left: 20,
            right: 20,
            child: CustomElevatedButton(
              text: title,
              buttonSize: ButtonSize.small,
              shapeAt: RoundedWithShapeAt.topLeft,
              color: Colors.black87,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).secondaryHeaderColor,
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 0,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (negativeButtonLabel != null)
                    Expanded(child: _buildNegativeButton(context)),
                  if (negativeButtonLabel != null &&
                      possitiveButtonLabel != null)
                    const SizedBox(width: 10),
                  if (possitiveButtonLabel != null)
                    Expanded(child: _buildPossitiveButton(context)),
                ],
              ))
        ],
      ),
    );
  }
}
