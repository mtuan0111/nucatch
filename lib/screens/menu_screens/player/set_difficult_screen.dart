import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch/blocs/navs/player/player_nav_cubit.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch/blocs/objects/turn/turn_bloc.dart';
import 'package:nucatch/blocs/objects/turn/turn_event.dart';
import 'package:nucatch/blocs/objects/turn/turn_state.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_bloc.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_event.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_state.dart';
import 'package:nucatch/blocs/objects/user/user_bloc.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/helper.dart';

import 'package:nucatch/helpers/template.dart';

class SetDifficultScreen extends StatefulWidget {
  const SetDifficultScreen({super.key});

  @override
  State<SetDifficultScreen> createState() => _SetDifficultScreenState();
}

class _SetDifficultScreenState extends State<SetDifficultScreen> {
  UserBloc get userBloc => context.read<UserBloc>();

  TurnBloc get turnBloc => context.read<TurnBloc>();
  TurnState get turnState => turnBloc.state;

  TurnRecordedListBloc get turnRecordedListBloc =>
      context.read<TurnRecordedListBloc>();
  TurnRecordedListState get turnRecordedListState => turnRecordedListBloc.state;

  double get screenWidth => MediaQuery.of(context).size.width;
  double get buttonSpace => 20;

  @override
  void initState() {
    // await _onSaveRecorded(SaveRecorded(savingRecord: itemModel), emitter);
    // turnBloc.add(SaveRecorded(context: context));

    turnRecordedListBloc.add(
      LoadData(),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: LayoutConfig(context).gradientDecoration,
        child: SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverFillRemaining(
                child: DeviceWrapper(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          lang(context).difficultySetting,
                          style: LayoutConfig(context).displaySmallStyle(),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        Column(
                          // crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: buttonSpace,
                          // runSpacing: buttonSpace,
                          children: Difficulty.values.map((difficulty) {
                            String textButton = '';

                            IconData difficultyIcon =
                                Helper.getIconFromDifficulty(
                                    context, difficulty);

                            return Row(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AnimatedButton(
                                  context,

                                  onPressed: () {
                                    turnBloc.add(
                                      SetDifficulty(
                                        difficulty: difficulty,
                                        onChanged: () {
                                          turnBloc.add(Start());
                                          context
                                              .read<PlayerNavCubit>()
                                              .showPlay();
                                        },
                                      ),
                                    );
                                  },
                                  // text: textButton,
                                  iconData: difficultyIcon,
                                ),
                                Text(
                                  textButton,
                                  style:
                                      LayoutConfig(context).titleSectionStyle(),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        Helper.getTitleFromDifficulty(
                                            context, difficulty),
                                        textAlign: TextAlign.start,
                                        style: LayoutConfig(context)
                                            .titleSectionStyle(),
                                      ),
                                      Text(
                                        Helper.getDescriptionFromDifficulty(
                                            context, difficulty),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
