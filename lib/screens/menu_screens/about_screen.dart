import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch_with_bloc/blocs/navs/menu/menu_state.dart';
import 'package:nucatch_with_bloc/helpers/const.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String get screenTitle => menuArray[MenuOption.about]!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: LayoutConfig(context).gradientDecoration,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              foregroundColor: Theme.of(context).scaffoldBackgroundColor,
              shadowColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              pinned: true,
              stretch: true,
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final double appBarHeight = constraints.biggest.height;
                  final bool isCollapsed = appBarHeight <=
                      kToolbarHeight + MediaQuery.of(context).padding.top;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    color: isCollapsed
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                    child: FlexibleSpaceBar(
                      centerTitle: true,
                      titlePadding: EdgeInsets.zero,
                      title: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          screenTitle,
                          textAlign: TextAlign.center,
                          style: LayoutConfig(context).displaySmallStyle(
                            isActiveShadow: true,
                            isItalic: true,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(FontAwesomeIcons.chevronLeft),
              ),
              expandedHeight: 100,
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 50,
                vertical: 20,
              ),
              sliver: SliverToBoxAdapter(
                child: Wrap(
                  alignment: WrapAlignment.start,
                  runSpacing: 20,
                  spacing: 20,
                  children: [
                    Text(
                      "Thanks for enjoying!",
                      style: LayoutConfig(context).handWritingSectionStyle(),
                    ),
                    Text(
                      "Thanks for enjoying! Thanks for enjoying! Thanks for enjoying! Thanks for enjoying! Thanks for enjoying! Thanks for enjoying! Thanks for enjoying! ",
                      style: LayoutConfig(context).contentSectionStyle(),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Author: ",
                          style: LayoutConfig(context).contentSectionStyle(),
                        ),
                        Text(
                          "BOM",
                          style: LayoutConfig(context).titleSectionStyle(),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Version: ",
                          style: LayoutConfig(context).contentSectionStyle(),
                        ),
                        Text(
                          "1.2.1",
                          style: LayoutConfig(context).titleSectionStyle(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    Text(
                      "Additional information",
                      style: LayoutConfig(context).titleSectionStyle(),
                    ),
                    Wrap(
                      children: [
                        IconButton(
                          onPressed: null,
                          icon: Icon(
                            FontAwesomeIcons.share,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                        ),
                        IconButton(
                          onPressed: null,
                          icon: Icon(
                            FontAwesomeIcons.facebook,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                        ),
                        IconButton(
                          onPressed: null,
                          icon: Icon(
                            FontAwesomeIcons.shieldHalved,
                            color: Theme.of(context).scaffoldBackgroundColor,
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
      ),
    );
  }
}
