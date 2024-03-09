import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text("About"),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            sliver: SliverToBoxAdapter(
              child: Wrap(
                alignment: WrapAlignment.start,
                runSpacing: 20,
                spacing: 20,
                children: [
                  Text("Thanks for enjoying!"),
                  Text(
                      "Thanks for enjoying! Thanks for enjoying! Thanks for enjoying! Thanks for enjoying! Thanks for enjoying! Thanks for enjoying! Thanks for enjoying! "),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("Author: BOM"),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Version: 1.2.1"),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  Text("Additional information"),
                  Wrap(
                    children: [
                      IconButton(
                        onPressed: null,
                        icon: Icon(
                          FontAwesomeIcons.share,
                        ),
                      ),
                      IconButton(
                        onPressed: null,
                        icon: Icon(
                          FontAwesomeIcons.facebook,
                        ),
                      ),
                      IconButton(
                        onPressed: null,
                        icon: Icon(
                          FontAwesomeIcons.shieldHalved,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
