import 'package:flutter/material.dart';
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
              shadowColor: Colors.transparent,
              foregroundColor: Colors.white,
              // forceElevated: true,
              elevation: 100,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                // background: Colors.transparent,

                titlePadding: EdgeInsets.zero,
                title: Text(
                  "Top score",
                  style: LayoutConfig(context).displaySmallStyle(
                    isActiveShadow: true,
                    isItalic: true,
                  ),
                ),
                // centerTitle: true,
              ),
              backgroundColor: Colors.transparent,
              expandedHeight: 100,
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
