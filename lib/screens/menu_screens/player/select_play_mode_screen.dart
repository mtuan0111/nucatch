import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/navs/menu/menu_bloc.dart';
import 'package:nucatch/blocs/navs/menu/menu_event.dart';
import 'package:nucatch/blocs/navs/player/player_nav_cubit.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/template.dart';

class SelectPlayModeScreen extends StatelessWidget {
  const SelectPlayModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: LayoutConfig(context).gradientDecoration,
        child: SafeArea(
          child: DeviceWrapper(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    lang(context).selectPlayMode,
                    style: LayoutConfig(context).titleSectionStyle(),
                  ),
                ),

                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Solo Mode Card
                          _PlayModeCard(
                            title: lang(context).soloMode,
                            description: lang(context).soloModeDescription,
                            icon: FontAwesomeIcons.user,
                            color: Colors.blue,
                            onTap: () {
                              context
                                  .read<PlayerNavCubit>()
                                  .selectPlayMode(PlayMode.solo);
                            },
                          ),

                          const SizedBox(height: 30),

                          // Combat Mode Card
                          _PlayModeCard(
                            title: lang(context).combatMode,
                            description: lang(context).combatModeDescription,
                            icon: FontAwesomeIcons.userGroup,
                            color: Colors.orange,
                            onTap: () {
                              context
                                  .read<PlayerNavCubit>()
                                  .selectPlayMode(PlayMode.combat);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Back Button
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CustomElevatedButton(
                    text: lang(context).mainMenu,
                    shapeAt: RoundedWithShapeAt.all,
                    onPressed: () {
                      context.read<MenuBloc>().add(ShowMenu());
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlayModeCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _PlayModeCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withOpacity(0.5),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 60,
              color: color,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: LayoutConfig(context).titleSectionStyle().copyWith(
                    color: color,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              textAlign: TextAlign.center,
              style: LayoutConfig(context).contentSectionStyle(),
            ),
          ],
        ),
      ),
    );
  }
}
