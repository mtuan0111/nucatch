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
        decoration: LayoutConfig.gradientDecoration(context),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  "Top score",
                ),
                centerTitle: true,
              ),
              backgroundColor: Colors.transparent,
              expandedHeight: 100,
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.menu),
                  tooltip: "Menu",
                  onPressed: () {
                    return;
                  },
                ),
              ],
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
