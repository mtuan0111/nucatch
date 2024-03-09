import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch_with_bloc/blocs/navs/menu/menu_bloc.dart';
import 'package:nucatch_with_bloc/blocs/navs/menu/menu_event.dart';
import 'package:nucatch_with_bloc/blocs/navs/menu/menu_state.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverFillRemaining(
              child: Center(
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      IntrinsicHeight(
                        child: Icon(
                          Icons.abc_sharp,
                          size: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .fontSize,
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      IntrinsicHeight(
                        child: Column(
                            children: menuArray.entries
                                .map((entry) => GestureDetector(
                                      onTap: () {
                                        BlocProvider.of<MenuBloc>(context).add(
                                          SelectOption(option: entry.key),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          entry.value,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ),
                                    ))
                                .toList()),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
