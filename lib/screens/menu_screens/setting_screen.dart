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
import 'package:nucatch/blocs/objects/tour/tour_bloc.dart';
import 'package:nucatch/blocs/objects/tour/tour_event.dart';
import 'package:nucatch/blocs/objects/user/user_bloc.dart';
import 'package:nucatch/blocs/objects/user/user_event.dart';
import 'package:nucatch/blocs/objects/user/user_state.dart';

import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/app_text_styles.dart';
import 'package:nucatch/helpers/template.dart';
import 'package:nucatch/helpers/ui_constants.dart';

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
                        duration: const Duration(
                            milliseconds: kAnimationDurationMedium),
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
                              style: AppTextStyles.displaySmallTitleScreen(
                                  context),
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
                                          labelStyle:
                                              AppTextStyles.titleLarge(context),
                                          hintStyle: AppTextStyles.withColor(
                                              AppTextStyles.bodyLarge(context),
                                              Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary
                                                  .withOpacity(0.5)),
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
                                        style:
                                            AppTextStyles.titleLarge(context),
                                        initialValue: userState.model.username,
                                        onChanged: (value) {
                                          userBloc.add(
                                            UsernameChanged(
                                              newUsername: value,
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(height: kSpace2XL),
                                      // Font size slider
                                      Container(
                                        padding:
                                            const EdgeInsets.all(kPaddingL),
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
                                                  size: kIconSizeM,
                                                ),
                                                const SizedBox(width: kSpaceML),
                                                Expanded(
                                                  child: Text(
                                                    lang(context).fontSize,
                                                    style: AppTextStyles
                                                        .titleLarge(context),
                                                  ),
                                                ),
                                                const SizedBox(width: kSpaceML),
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
                                                    style: AppTextStyles
                                                        .bodyLargeBold(context),
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
                                      const SizedBox(height: kSpaceL),
                                      // Volume slider
                                      Container(
                                        padding:
                                            const EdgeInsets.all(kPaddingL),
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
                                                  size: kIconSizeM,
                                                ),
                                                const SizedBox(width: kSpaceML),
                                                Text(
                                                  lang(context).volume,
                                                  style:
                                                      AppTextStyles.titleLarge(
                                                          context),
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
                                                    style: AppTextStyles
                                                        .bodyLargeBold(context),
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
                                      const SizedBox(height: kSpaceL),
                                      // Vibrate toggle
                                      Container(
                                        padding:
                                            const EdgeInsets.all(kPaddingL),
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
                                              size: kIconSizeM,
                                            ),
                                            const SizedBox(width: kSpaceML),
                                            Text(
                                              lang(context).vibrate,
                                              style: AppTextStyles.titleLarge(
                                                  context),
                                            ),
                                            const Spacer(),
                                            Switch(
                                              value: settingState.isVibrate,
                                              activeColor: Theme.of(context)
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
                                      const SizedBox(height: kSpaceL),
                                      // Top scores slider
                                      Container(
                                        padding:
                                            const EdgeInsets.all(kPaddingL),
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
                                                  size: kIconSizeM,
                                                ),
                                                const SizedBox(width: kSpaceML),
                                                Expanded(
                                                  child: Text(
                                                    lang(context)
                                                        .numberOfTopScores,
                                                    style: AppTextStyles
                                                        .titleLarge(context),
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
                                                    style: AppTextStyles
                                                        .bodyLargeBold(context),
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
                                      const SizedBox(height: kSpaceL),
                                      // Only show my recorded toggle
                                      Container(
                                        padding:
                                            const EdgeInsets.all(kPaddingL),
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
                                              FontAwesomeIcons.userCheck,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                              size: kIconSizeM,
                                            ),
                                            const SizedBox(width: kSpaceML),
                                            Expanded(
                                              child: Text(
                                                lang(context)
                                                    .onlyShowMyRecorded,
                                                style: AppTextStyles.titleLarge(
                                                    context),
                                              ),
                                            ),
                                            const SizedBox(width: kSpaceML),
                                            Switch(
                                              value: settingState
                                                  .onlyShowMyRecorded,
                                              activeColor: Theme.of(context)
                                                  .primaryColor,
                                              onChanged: (val) {
                                                settingBloc.add(
                                                  ChangedOnlyShowMyRecorded(
                                                      onlyShowMyRecorded: val),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: kSpaceL),
                                      // Language dropdown
                                      Container(
                                        padding:
                                            const EdgeInsets.all(kPaddingL),
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
                                                  size: kIconSizeM,
                                                ),
                                                const SizedBox(width: kSpaceML),
                                                Text(
                                                  lang(context).language,
                                                  style:
                                                      AppTextStyles.titleLarge(
                                                          context),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: kSpaceML),
                                            DropdownButtonFormField<String>(
                                              value: settingState.locale,
                                              items: languages.entries
                                                  .map(
                                                    (lang) => DropdownMenuItem<
                                                        String>(
                                                      value: lang.key,
                                                      child: Text(
                                                        lang.value,
                                                        style: AppTextStyles
                                                            .bodyLarge(context),
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
                                              style: AppTextStyles.bodyLarge(
                                                  context),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: kSpace2XL),
                                      // Restart Tour Button
                                      Container(
                                        padding:
                                            const EdgeInsets.all(kPaddingL),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.2),
                                          borderRadius: BorderRadius.only(
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
                                              FontAwesomeIcons.compass,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                              size: kIconSizeM,
                                            ),
                                            const SizedBox(width: kSpaceML),
                                            Expanded(
                                              child: Text(
                                                lang(context)
                                                    .tourRestartFromSettings,
                                                style: AppTextStyles.titleLarge(
                                                    context),
                                              ),
                                            ),
                                            const SizedBox(width: kSpaceML),
                                            ElevatedButton(
                                              onPressed: () {
                                                final tourBloc =
                                                    context.read<TourBloc>();
                                                // Reset tour
                                                tourBloc.add(TourReset());
                                                // Start tour immediately
                                                tourBloc.add(TourStarted());
                                                // Show confirmation
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      lang(context)
                                                          .tourResetMessage,
                                                      style: AppTextStyles
                                                          .bodyLarge(context),
                                                    ),
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .primaryColor,
                                                  ),
                                                );
                                                // Navigate back to main menu to start tour
                                                context
                                                    .read<MenuBloc>()
                                                    .add(ShowMenu());
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .primaryColor,
                                                foregroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary,
                                              ),
                                              child: Text(
                                                lang(context)
                                                    .tourRestartFromSettings,
                                                style: AppTextStyles.bodyLarge(
                                                    context),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
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
