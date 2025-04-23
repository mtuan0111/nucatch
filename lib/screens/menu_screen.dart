import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch_with_bloc/blocs/navs/menu/menu_bloc.dart';
import 'package:nucatch_with_bloc/blocs/navs/menu/menu_event.dart';
import 'package:nucatch_with_bloc/blocs/navs/menu/menu_state.dart';
import 'package:nucatch_with_bloc/blocs/objects/user/user_bloc.dart';
import 'package:nucatch_with_bloc/blocs/objects/user/user_state.dart';
import 'package:nucatch_with_bloc/helpers/const.dart';
import 'package:nucatch_with_bloc/helpers/template.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String? version;
  MenuBloc get menuBloc => context.read<MenuBloc>();
  MenuState get menuState => menuBloc.state;

  @override
  void initState() {
    super.initState();

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        version = packageInfo.version;
        log("version: ");
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
                      child: MainLogo(),
                    ),
                    expandedHeight: 240,
                    toolbarHeight: 80,
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          "${lang(context).welcome} ${state.username ?? lang(context).anonymous}",
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
                          final entry =
                              menuArray(context).entries.elementAt(index);
                          return Center(
                            child: CustomeTitleButton(
                              text: entry.value,
                              onTap: () =>
                                  menuBloc.add(SelectOption(option: entry.key)),
                            ),
                          );
                        },
                        childCount: menuArray(context).length,
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
                              "${lang(context).version}: ",
                              // style: LayoutConfig(context).titleSectionStyle(),
                            ),
                            Text(
                              version ?? "",
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
