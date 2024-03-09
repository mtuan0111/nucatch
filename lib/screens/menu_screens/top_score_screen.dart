import 'package:flutter/material.dart';

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
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text("Top score"),
          ),
          SliverFillRemaining(
            fillOverscroll: true,
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: List.generate(
                    10,
                    (index) => TopScoreItem(
                      index: index,
                    ),
                  ).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TopScoreItem extends StatelessWidget {
  final int index;
  const TopScoreItem({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 300,
        color: Colors.red,
        child: Row(
          children: [
            Container(
                height: 80,
                width: 80,
                color: Colors.greenAccent,
                child: Center(child: Text("Rank ${index + 1}"))),
            const Expanded(
                child: Column(
              children: [
                Text("Name"),
                Text("Time"),
                Text("Score"),
              ],
            )),
          ],
        ));
  }
}
