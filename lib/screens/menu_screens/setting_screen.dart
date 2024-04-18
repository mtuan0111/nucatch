import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch_with_bloc/blocs/navs/menu/menu_state.dart';
import 'package:nucatch_with_bloc/features/settings/settings_controller.dart';

import 'package:nucatch_with_bloc/helpers/const.dart';

class SettingScreen extends StatefulWidget {
  final SettingsController settingsController;
  const SettingScreen({
    super.key,
    required this.settingsController,
  });

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String get screenTitle => menuArray[MenuOption.setting]!;

  SettingsController get settingsController => widget.settingsController;

  @override
  Widget build(BuildContext context) {
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
                      Form(
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
                                labelStyle:
                                    LayoutConfig(context).titleSectionStyle(),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    LayoutConfig.layoutBorderRadius,
                                  ),
                                ),
                                iconColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                fillColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                focusColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.textWidth,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Font size",
                                        style: LayoutConfig(context)
                                            .titleSectionStyle(),
                                      ),
                                      Slider(
                                        value: settingsController.fontSize,
                                        min: 0,
                                        max: 10,
                                        divisions: 10,
                                        label: settingsController.fontSize
                                            .round()
                                            .toString(),
                                        onChanged: (val) {
                                          setState(() {
                                            settingsController
                                                .updateFontSize(val.round());
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
                                  settingsController.vol > 7
                                      ? FontAwesomeIcons.volumeHigh
                                      : settingsController.vol > 4
                                          ? FontAwesomeIcons.volumeLow
                                          : settingsController.vol > 2
                                              ? FontAwesomeIcons.volumeOff
                                              : FontAwesomeIcons.volumeXmark,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Volume",
                                        style: LayoutConfig(context)
                                            .titleSectionStyle(),
                                      ),
                                      Slider(
                                        value: settingsController.vol,
                                        min: 0,
                                        max: 10,
                                        divisions: 10,
                                        label: settingsController.vol
                                            .round()
                                            .toString(),
                                        onChanged: (val) {
                                          setState(() {
                                            settingsController
                                                .updateVol(val.round());
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
                                  FontAwesomeIcons.ribbon,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Number of top turn",
                                        style: LayoutConfig(context)
                                            .titleSectionStyle(),
                                      ),
                                      Slider(
                                        value: settingsController.numberOfTurn,
                                        min: 20,
                                        max: 100,
                                        divisions: 8,
                                        label: settingsController.numberOfTurn
                                            .round()
                                            .toString(),
                                        onChanged: (val) {
                                          setState(() {
                                            settingsController
                                                .updateNumberOfTurn(
                                                    val.round());
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
  }
}
