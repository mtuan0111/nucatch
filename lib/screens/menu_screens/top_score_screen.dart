import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch_with_bloc/blocs/navs/menu/menu_state.dart';
import 'package:nucatch_with_bloc/helpers/const.dart';
import 'package:nucatch_with_bloc/screens/menu_screens/player/gameover_screen.dart';

class TopScoreScreen extends StatefulWidget {
  const TopScoreScreen({super.key});

  @override
  State<TopScoreScreen> createState() => _TopScoreScreenState();
}

class _TopScoreScreenState extends State<TopScoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Container(
        decoration: LayoutConfig(context).gradientDecoration,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              foregroundColor: Colors.white,
              shadowColor: Colors.transparent,
              surfaceTintColor: Colors.primaries[0],
              backgroundColor: Colors.transparent,

              elevation: 100,
              pinned: true,
              stretch: true,

              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.zero,
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    textAlign: TextAlign.center,
                    menuArray[MenuOption.topScore]!,
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
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                vertical: 50,
                horizontal: 10,
              ),
              sliver: SliverToBoxAdapter(
                child: IntrinsicWidth(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    runSpacing: 50,
                    spacing: 50,
                    children: List.generate(
                      5,
                      (index) => RankingItem(
                        ranking: index + 1,
                        playerName: "playerName",
                        createdAt: DateTime.now(),
                        turnedPoint: 2,
                      ),
                    ).toList(),
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
