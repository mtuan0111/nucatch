import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch_with_bloc/blocs/navs/menu/menu_state.dart';
import 'package:nucatch_with_bloc/blocs/objects/setting/setting_bloc.dart';
import 'package:nucatch_with_bloc/blocs/objects/setting/setting_event.dart';
import 'package:nucatch_with_bloc/blocs/objects/setting/setting_state.dart';
import 'package:nucatch_with_bloc/blocs/objects/user/user_bloc.dart';
import 'package:nucatch_with_bloc/blocs/objects/user/user_event.dart';
import 'package:nucatch_with_bloc/blocs/objects/user/user_state.dart';

import 'package:nucatch_with_bloc/helpers/const.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({
    super.key,
  });

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String get screenTitle => menuArray[MenuOption.setting]!;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
      builder: (context, settingState) {
        return Scaffold(
          body: Container(
            decoration: LayoutConfig(context).gradientDecoration,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  foregroundColor: Theme.of(context).scaffoldBackgroundColor,
                  shadowColor: Colors.transparent,
                  // surfaceTintColor: Colors.transparent,
                  backgroundColor: Theme.of(context).primaryColor,

                  pinned: true,
                  stretch: true,

                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: EdgeInsets.zero,
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        textAlign: TextAlign.center,
                        screenTitle,
                        style: LayoutConfig(context).displaySmallStyle(
                          isActiveShadow: true,
                          isItalic: true,
                        ),
                      ),
                    ),
                  ),
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(FontAwesomeIcons.chevronLeft),
                  ),
                  expandedHeight: 100,

                  // leading: Expanded(child: Center(child: Text("back"))),
                ),
                DecoratedSliver(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  sliver: SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 50,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          BlocBuilder<UserBloc, UserState>(
                            builder: (context, userState) {
                              return Form(
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  runSpacing: 20,
                                  spacing: 20,
                                  children: [
                                    TextFormField(
                                      decoration: InputDecoration(
                                        icon: const Icon(
                                          Icons.person,
                                        ),
                                        labelText: 'Name',
                                        labelStyle: LayoutConfig(context)
                                            .titleSectionStyle(),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            LayoutConfig.layoutBorderRadius,
                                          ),
                                        ),
                                        iconColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        fillColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        focusColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                      ),
                                      style: LayoutConfig(context)
                                          .titleSectionStyle(),
                                      initialValue: userState.model.username,
                                      onChanged: (value) {
                                        BlocProvider.of<UserBloc>(context).add(
                                          UsernameChanged(
                                            newUsername: value,
                                          ),
                                        );
                                      },
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.textWidth,
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Font size",
                                                style: LayoutConfig(context)
                                                    .titleSectionStyle(),
                                              ),
                                              Slider(
                                                value: settingState.fontSize
                                                    .toDouble(),
                                                min: 0,
                                                max: 10,
                                                divisions: 10,
                                                label: settingState.fontSize
                                                    .round()
                                                    .toString(),
                                                onChanged: (val) {
                                                  setState(() {
                                                    BlocProvider.of<
                                                                SettingBloc>(
                                                            context)
                                                        .add(
                                                      ChangedFontSize(
                                                        fontSize: val.round(),
                                                      ),
                                                    );
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          settingState.vol > 7
                                              ? FontAwesomeIcons.volumeHigh
                                              : settingState.vol > 4
                                                  ? FontAwesomeIcons.volumeLow
                                                  : settingState.vol > 2
                                                      ? FontAwesomeIcons
                                                          .volumeOff
                                                      : FontAwesomeIcons
                                                          .volumeXmark,
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Volume",
                                                style: LayoutConfig(context)
                                                    .titleSectionStyle(),
                                              ),
                                              Slider(
                                                value:
                                                    settingState.vol.toDouble(),
                                                min: 0,
                                                max: 10,
                                                divisions: 10,
                                                label: settingState.vol
                                                    .round()
                                                    .toString(),
                                                onChanged: (val) {
                                                  BlocProvider.of<SettingBloc>(
                                                          context)
                                                      .add(
                                                    ChangedVol(
                                                      vol: val.round(),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.ribbon,
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Number of top turn",
                                                style: LayoutConfig(context)
                                                    .titleSectionStyle(),
                                              ),
                                              Slider(
                                                value: settingState
                                                    .numberOfTopBoard
                                                    .toDouble(),
                                                min: 20,
                                                max: 100,
                                                divisions: 8,
                                                label: settingState
                                                    .numberOfTopBoard
                                                    .round()
                                                    .toString(),
                                                onChanged: (val) {
                                                  setState(() {
                                                    BlocProvider.of<
                                                                SettingBloc>(
                                                            context)
                                                        .add(
                                                      ChangedNumberOfTopBoard(
                                                        numberOfTopBoard:
                                                            val.round(),
                                                      ),
                                                    );
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
