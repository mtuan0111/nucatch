import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch_with_bloc/blocs/navs/menu/menu_bloc.dart';
import 'package:nucatch_with_bloc/blocs/navs/menu/menu_event.dart';
import 'package:nucatch_with_bloc/blocs/navs/menu/menu_state.dart';
import 'package:nucatch_with_bloc/blocs/objects/user/user_bloc.dart';
import 'package:nucatch_with_bloc/blocs/objects/user/user_state.dart';
import 'package:nucatch_with_bloc/helpers/const.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String? version;

  @override
  void initState() {
    super.initState();

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        version = packageInfo.version;
        log("version: ");
        log(version!);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return Scaffold(
          body: Container(
            decoration: LayoutConfig(context).gradientDecoration,
            child: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    foregroundColor: Theme.of(context).scaffoldBackgroundColor,
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    surfaceTintColor: Colors.transparent,
                    pinned: true,
                    flexibleSpace: const Center(
                      child: Image(
                        height: 160,
                        image: AssetImage("assets/images/main-logo.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                    expandedHeight: 240,
                    toolbarHeight: 80,
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          "Welcome ${state.username}",
                          style: LayoutConfig(context).titleSectionStyle(),
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final entry = menuArray.entries.elementAt(index);
                          return Center(
                            child: CustomeTitleButton(
                              text: entry.value,
                              onTap: () => BlocProvider.of<MenuBloc>(context)
                                  .add(SelectOption(option: entry.key)),
                            ),
                          );
                        },
                        childCount: menuArray.length,
                      ),
                    ),
                  ),
                  if (version?.isNotEmpty ?? false)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Version: ",
                              style: LayoutConfig(context).titleSectionStyle(),
                            ),
                            Text(
                              version!,
                              style:
                                  LayoutConfig(context).contentSectionStyle(),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomeTitleButton extends StatelessWidget {
  final String text;
  final Function onTap;
  const CustomeTitleButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          text,
          style: LayoutConfig(context).displaySmallStyle(
            isActiveShadow: true,
            isItalic: true,
          ),
        ),
      ),
    );
  }
}
