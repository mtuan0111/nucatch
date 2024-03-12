import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch_with_bloc/blocs/navs/menu/menu_bloc.dart';
import 'package:nucatch_with_bloc/blocs/navs/menu/menu_state.dart';
import 'package:nucatch_with_bloc/blocs/objects/turn/turn_bloc.dart';
import 'package:nucatch_with_bloc/blocs/objects/turn/turn_event.dart';
import 'package:nucatch_with_bloc/blocs/objects/turn/turn_state.dart';

import '../../blocs/navs/menu/menu_event.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double get screenWidth => MediaQuery.of(context).size.width;
  double get buttonSpace => 20;
  String inputtedValue = "";

  @override
  Widget build(BuildContext context) {
    TextStyle buttonStyle = Theme.of(context).textTheme.headlineMedium!;

    return Scaffold(
      body: BlocBuilder<TurnBloc, TurnState>(
        builder: (context, turnState) {
          return Container(
            constraints: const BoxConstraints.expand(),
            color: Colors.green,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Level: ${turnState.level}"),
                              Text("Point: ${turnState.point}"),
                            ],
                          ),
                          if (turnState.isShowExpect &&
                              turnState.expect != null)
                            Expanded(
                              child: Center(
                                child: Text(
                                  turnState.expect!,
                                  style: buttonStyle,
                                ),
                              ),
                            )
                          else
                            Expanded(
                              child: Center(
                                child: Text(
                                  turnState.typing,
                                  style: buttonStyle,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: buttonSpace,
                        runSpacing: buttonSpace,
                        children: keyboardArray.entries.map((e) {
                          return SizedBox(
                            width: (screenWidth / 3) - buttonSpace * 2,
                            height: (screenWidth / 3) - buttonSpace * 2,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (e.key == KeyboardOption.reset) {
                                  return await pressReset();
                                }

                                if (e.key == KeyboardOption.mainMenu) {
                                  return await pressMainMenu(context);
                                }

                                // setState(() {
                                //   inputtedValue += e.value.toString();
                                // });

                                context.read<TurnBloc>().add(
                                      Tap(keyValue: e.key),
                                    );
                              },
                              child: Builder(builder: (context) {
                                if (e.value == 10) {
                                  return Icon(
                                    FontAwesomeIcons.arrowsRotate,
                                    size: buttonStyle.fontSize,
                                    color: buttonStyle.color,
                                  );
                                }

                                if (e.value == 11) {
                                  return Icon(
                                    FontAwesomeIcons.bars,
                                    size: buttonStyle.fontSize,
                                    color: buttonStyle.color,
                                  );
                                }

                                return Text(
                                  e.value.toString(),
                                  style: buttonStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }),
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> pressReset() async {
    return;
  }

  Future<void> pressMainMenu(BuildContext context) async {
    // context.read<MenuBloc>().add(SelectOption(option: null));
    BlocProvider.of<MenuBloc>(context).add(SelectOption(option: null));
    return;
  }
}
