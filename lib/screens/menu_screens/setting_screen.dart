import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/navs/menu/menu_bloc.dart';
import 'package:nucatch/blocs/navs/menu/menu_event.dart';
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
    required this.title,
  });
  final String title;

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String get screenTitle => widget.title;

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
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        SafeArea(
                          top: false,
                          child: DeviceWrapper(
                            child: BlocBuilder<UserBloc, UserState>(
                              builder: (context, userState) {
                                return Form(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      // Username field
                                      TextFormField(
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.person,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                          ),
                                          labelText: lang(context).name,
                                          hintText: lang(context).anonymous,
                                          labelStyle: LayoutConfig(context)
                                              .titleSectionStyle(),
                                          hintStyle: LayoutConfig(context)
                                              .contentSectionStyle()
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary
                                                    .withOpacity(0.5),
                                              ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              LayoutConfig.layoutBorderRadius,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              LayoutConfig.layoutBorderRadius,
                                            ),
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary
                                                  .withOpacity(0.3),
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              LayoutConfig.layoutBorderRadius,
                                            ),
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                              width: 2,
                                            ),
                                          ),
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
                                      const SizedBox(height: 24),
                                      // Font size slider
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.1),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(
                                                LayoutConfig
                                                        .layoutBorderRadius /
                                                    5),
                                            topRight: Radius.circular(
                                                LayoutConfig
                                                    .layoutBorderRadius),
                                            bottomLeft: Radius.circular(
                                                LayoutConfig
                                                    .layoutBorderRadius),
                                            bottomRight: Radius.circular(
                                                LayoutConfig
                                                    .layoutBorderRadius),
                                          ),
                                          border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary
                                                .withOpacity(0.2),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons.textWidth,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Text(
                                                    lang(context).fontSize,
                                                    style: LayoutConfig(context)
                                                        .titleSectionStyle(),
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 12,
                                                    vertical: 6,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .primaryColor
                                                        .withOpacity(0.3),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Text(
                                                    settingState.fontSize
                                                        .toString(),
                                                    style: LayoutConfig(context)
                                                        .contentSectionStyle()
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Slider(
                                              value: settingState.fontSize
                                                  .toDouble(),
                                              min: 0,
                                              max: 10,
                                              divisions: 10,
                                              activeColor: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                              inactiveColor: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary
                                                  .withOpacity(0.3),
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
                                      const SizedBox(height: 16),
                                      // Volume slider
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.1),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(
                                                LayoutConfig
                                                    .layoutBorderRadius),
                                            topRight: Radius.circular(
                                                LayoutConfig
                                                    .layoutBorderRadius),
                                            bottomLeft: Radius.circular(
                                                LayoutConfig
                                                    .layoutBorderRadius),
                                            bottomRight: Radius.circular(
                                                LayoutConfig
                                                        .layoutBorderRadius /
                                                    5),
                                          ),
                                          border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary
                                                .withOpacity(0.2),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  settingState.vol > 7
                                                      ? FontAwesomeIcons
                                                          .volumeHigh
                                                      : settingState.vol > 4
                                                          ? FontAwesomeIcons
                                                              .volumeLow
                                                          : settingState.vol > 0
                                                              ? FontAwesomeIcons
                                                                  .volumeOff
                                                              : FontAwesomeIcons
                                                                  .volumeXmark,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 12),
                                                Text(
                                                  lang(context).volume,
                                                  style: LayoutConfig(context)
                                                      .titleSectionStyle(),
                                                ),
                                                const Spacer(),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 12,
                                                    vertical: 6,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .primaryColor
                                                        .withOpacity(0.3),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Text(
                                                    settingState.vol.toString(),
                                                    style: LayoutConfig(context)
                                                        .contentSectionStyle()
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Slider(
                                              value:
                                                  settingState.vol.toDouble(),
                                              min: 0,
                                              max: 10,
                                              divisions: 10,
                                              activeColor: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                              inactiveColor: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary
                                                  .withOpacity(0.3),
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
                                      const SizedBox(height: 16),
                                      // Vibrate toggle
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.1),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(
                                                LayoutConfig
                                                        .layoutBorderRadius /
                                                    5),
                                            topRight: Radius.circular(
                                                LayoutConfig
                                                    .layoutBorderRadius),
                                            bottomLeft: Radius.circular(
                                                LayoutConfig
                                                    .layoutBorderRadius),
                                            bottomRight: Radius.circular(
                                                LayoutConfig
                                                    .layoutBorderRadius),
                                          ),
                                          border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary
                                                .withOpacity(0.2),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              FontAwesomeIcons.waveSquare,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              lang(context).vibrate,
                                              style: LayoutConfig(context)
                                                  .titleSectionStyle(),
                                            ),
                                            const Spacer(),
                                            Switch(
                                              value: settingState.isVibrate,
                                              activeThumbColor:
                                                  Theme.of(context)
                                                      .primaryColor,
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
                                      const SizedBox(height: 16),
                                      // Top scores slider
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.1),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(
                                                LayoutConfig
                                                    .layoutBorderRadius),
                                            topRight: Radius.circular(
                                                LayoutConfig
                                                    .layoutBorderRadius),
                                            bottomLeft: Radius.circular(
                                                LayoutConfig
                                                    .layoutBorderRadius),
                                            bottomRight: Radius.circular(
                                                LayoutConfig
                                                        .layoutBorderRadius /
                                                    5),
                                          ),
                                          border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary
                                                .withOpacity(0.2),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons.ribbon,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Text(
                                                    lang(context)
                                                        .numberOfTopScores,
                                                    style: LayoutConfig(context)
                                                        .titleSectionStyle(),
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 12,
                                                    vertical: 6,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .primaryColor
                                                        .withOpacity(0.3),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Text(
                                                    settingState
                                                        .numberOfTopBoard
                                                        .toString(),
                                                    style: LayoutConfig(context)
                                                        .contentSectionStyle()
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Slider(
                                              value: settingState
                                                  .numberOfTopBoard
                                                  .toDouble(),
                                              min: 20,
                                              max: 100,
                                              divisions: 8,
                                              activeColor: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                              inactiveColor: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary
                                                  .withOpacity(0.3),
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
                                      const SizedBox(height: 16),
                                      // Language dropdown
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.1),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(
                                                LayoutConfig
                                                        .layoutBorderRadius /
                                                    5),
                                            topRight: Radius.circular(
                                                LayoutConfig
                                                    .layoutBorderRadius),
                                            bottomLeft: Radius.circular(
                                                LayoutConfig
                                                    .layoutBorderRadius),
                                            bottomRight: Radius.circular(
                                                LayoutConfig
                                                    .layoutBorderRadius),
                                          ),
                                          border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary
                                                .withOpacity(0.2),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons.language,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 12),
                                                Text(
                                                  lang(context).language,
                                                  style: LayoutConfig(context)
                                                      .titleSectionStyle(),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 12),
                                            DropdownButtonFormField<String>(
                                              initialValue: settingState.locale,
                                              items: languages.entries
                                                  .map(
                                                    (lang) => DropdownMenuItem<
                                                        String>(
                                                      value: lang.key,
                                                      child: Text(
                                                        lang.value,
                                                        style: LayoutConfig(
                                                                context)
                                                            .contentSectionStyle(),
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                              onChanged: (val) {
                                                if (val != null) {
                                                  settingBloc.add(
                                                    ChangedLocale(locale: val),
                                                  );
                                                }
                                              },
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 12,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    LayoutConfig
                                                        .layoutBorderRadius,
                                                  ),
                                                  borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary
                                                        .withOpacity(0.3),
                                                  ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    LayoutConfig
                                                        .layoutBorderRadius,
                                                  ),
                                                  borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary
                                                        .withOpacity(0.3),
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    LayoutConfig
                                                        .layoutBorderRadius,
                                                  ),
                                                  borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary,
                                                    width: 2,
                                                  ),
                                                ),
                                              ),
                                              dropdownColor: Theme.of(context)
                                                  .primaryColor,
                                              style: LayoutConfig(context)
                                                  .contentSectionStyle(),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
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
