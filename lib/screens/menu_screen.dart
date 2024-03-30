import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch_with_bloc/blocs/navs/menu/menu_bloc.dart';
import 'package:nucatch_with_bloc/blocs/navs/menu/menu_event.dart';
import 'package:nucatch_with_bloc/blocs/navs/menu/menu_state.dart';
import 'package:nucatch_with_bloc/blocs/objects/user/user_bloc.dart';
import 'package:nucatch_with_bloc/blocs/objects/user/user_state.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).secondaryHeaderColor,
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: SafeArea(
                child: CustomScrollView(
                  slivers: <Widget>[
                    const SliverToBoxAdapter(
                      child: Image(
                        height: 160,
                        image: AssetImage("assets/images/main-logo.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                        ),
                        child: Column(
                          children: [
                            Center(
                                child: Text(
                              "Welcome ${state.model.name}",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                    color: Colors.white,
                                  ),
                            )),
                          ],
                        ),
                      ),
                    ),
                    SliverFillRemaining(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: menuArray.entries
                            .map((entry) => CustomeTitleButton(
                                  text: entry.value,
                                  onTap: () {
                                    BlocProvider.of<MenuBloc>(context).add(
                                      SelectOption(option: entry.key),
                                    );
                                  },
                                ))
                            .toList(),
                      ),
                    )
                  ],
                ),
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
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
            color: Colors.white,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            shadows: [
              const BoxShadow(
                color: Colors.black54,
                blurRadius: 4,
                offset: Offset(0, 4),
              )
            ],
          ),
        ),
      ),
    );
  }
}
