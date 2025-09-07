import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/navs/menu/menu_bloc.dart';
import 'package:nucatch/blocs/navs/menu/menu_event.dart';
import 'package:nucatch/blocs/navs/menu/menu_state.dart';
import 'package:nucatch/blocs/objects/setting/setting_bloc.dart';
import 'package:nucatch/blocs/objects/setting/setting_event.dart';
import 'package:nucatch/blocs/objects/setting/setting_state.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_bloc.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_state.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_event.dart'
    as tlre;
import 'package:nucatch/blocs/objects/user/user_bloc.dart';
import 'package:nucatch/blocs/objects/user/user_event.dart';
import 'package:nucatch/blocs/objects/user/user_state.dart';

import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/template.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({
    super.key,
  });

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String get screenTitle => menuArray(context)[MenuOption.setting]!;

  UserBloc get userBloc => context.read<UserBloc>();
  UserState get userState => userBloc.state;

  SettingBloc get settingBloc => context.read<SettingBloc>();
  SettingState get settingState => settingBloc.state;

  TurnRecordedListBloc get turnRecordedListBloc =>
      context.read<TurnRecordedListBloc>();
  TurnRecordedListState get turnRecordedListState => turnRecordedListBloc.state;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
      builder: (context, settingState) {
        if (settingState.numberOfTopBoard !=
            turnRecordedListState.numberOfTopBoard) {
          turnRecordedListBloc.add(
            tlre.ChangeNumberOfTopBoard(
              numberOfTopBoard: settingState.numberOfTopBoard,
            ),
          );
        }
        return Scaffold(
          body: Container(
            decoration: LayoutConfig(context).gradientDecoration,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  foregroundColor: Theme.of(context).scaffoldBackgroundColor,
                  shadowColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  pinned: true,
                  stretch: true,
                  flexibleSpace: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
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
                              screenTitle,
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
                      // Navigator.pop(context);
                    },
                    icon: const Icon(FontAwesomeIcons.chevronLeft),
                  ),
                  expandedHeight: 100,
                ),
                DecoratedSliver(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  sliver: SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 50,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          BlocBuilder<UserBloc, UserState>(
                            builder: (context, userState) {
                              return DeviceWrapper(
                                child: Form(
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
                                          labelText: lang(context).name,
                                          hintText: lang(context).anonymous,
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
                                          userBloc.add(
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
                                                  lang(context).fontSize,
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
                                                      settingBloc.add(
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
                                                  lang(context).volume,
                                                  style: LayoutConfig(context)
                                                      .titleSectionStyle(),
                                                ),
                                                Slider(
                                                  value: settingState.vol
                                                      .toDouble(),
                                                  min: 0,
                                                  max: 10,
                                                  divisions: 10,
                                                  label: settingState.vol
                                                      .round()
                                                      .toString(),
                                                  onChanged: (val) {
                                                    settingBloc.add(
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
                                            FontAwesomeIcons.waveSquare,
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  lang(context).vibrate,
                                                  style: LayoutConfig(context)
                                                      .titleSectionStyle(),
                                                ),
                                                Switch(
                                                  value: settingState.isVibrate,
                                                  onChanged: (val) {
                                                    settingBloc.add(
                                                      ChangedIsVibrate(
                                                          isVibrate: val),
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
                                                  lang(context)
                                                      .numberOfTopScores,
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
                                                      settingBloc.add(
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
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.language,
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
                                                  lang(context).language,
                                                  style: LayoutConfig(context)
                                                      .titleSectionStyle(),
                                                ),
                                                DropdownButtonFormField<String>(
                                                  initialValue:
                                                      settingState.locale,
                                                  items: languages.entries
                                                      .map(
                                                        (lang) =>
                                                            DropdownMenuItem<
                                                                String>(
                                                          value: lang.key,
                                                          child:
                                                              Text(lang.value),
                                                        ),
                                                      )
                                                      .toList(),
                                                  onChanged: (val) {
                                                    if (val != null) {
                                                      settingBloc.add(
                                                        ChangedLocale(
                                                            locale: val),
                                                      );
                                                    }
                                                  },
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        LayoutConfig
                                                            .layoutBorderRadius,
                                                      ),
                                                    ),
                                                    fillColor: Theme.of(context)
                                                        .scaffoldBackgroundColor,
                                                    focusColor: Theme.of(
                                                            context)
                                                        .scaffoldBackgroundColor,
                                                  ),
                                                  dropdownColor:
                                                      Theme.of(context)
                                                          .primaryColor,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
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
