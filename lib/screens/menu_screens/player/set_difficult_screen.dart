import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/navs/menu/menu_bloc.dart';
import 'package:nucatch/blocs/navs/menu/menu_event.dart';
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
              SliverAppBar(
                foregroundColor: Theme.of(context).scaffoldBackgroundColor,
                shadowColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                pinned: true,
                stretch: true,
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final double appBarHeight = constraints.biggest.height;
                    final bool isCollapsed = appBarHeight <=
                        kToolbarHeight + MediaQuery.of(context).padding.top;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      color: isCollapsed
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                      child: FlexibleSpaceBar(
                        centerTitle: true,
                        titlePadding: EdgeInsets.zero,
                        title: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            lang(context).difficultySetting,
                            textAlign: TextAlign.center,
                            style: LayoutConfig(context).displaySmallStyle(
                              isActiveShadow: true,
                              isItalic: true,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                leading: IconButton(
                  onPressed: () {
                    context.read<MenuBloc>().add(ShowMenu());
                  },
                  icon: const Icon(FontAwesomeIcons.chevronLeft),
                ),
                expandedHeight: MediaQuery.of(context).size.height * 0.22,
              ),
              SliverFillRemaining(
                child: DeviceWrapper(
                  child: SingleChildScrollView(
                    child: Column(
                      // crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: buttonSpace,
                      // runSpacing: buttonSpace,
                      children: Difficulty.values.map((difficulty) {
                        String textButton = '';

                        IconData difficultyIcon =
                            Helper.getIconFromDifficulty(context, difficulty);

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
                                      context.read<PlayerNavCubit>().showPlay();
                                    },
                                  ),
                                );
                              },
                              // text: textButton,
                              iconData: difficultyIcon,
                            ),
                            Text(
                              textButton,
                              style: LayoutConfig(context).titleSectionStyle(),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
