import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch_with_bloc/blocs/navs/menu/menu_state.dart';
import 'package:nucatch_with_bloc/helpers/const.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String get screenTitle => menuArray(context)[MenuOption.about]!;

  String? version;

  @override
  void initState() {
    super.initState();

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        version = packageInfo.version;
      });
    });
  }

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
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lang(context).thankYou,
                      style: LayoutConfig(context).titleSectionStyle(),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.solidHeart,
                          color: Theme.of(context).primaryColor,
                          size:
                              Theme.of(context).textTheme.titleLarge!.fontSize,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            lang(context).thankYouMessage,
                            style: LayoutConfig(context).contentSectionStyle(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lang(context).authorName,
                      style: LayoutConfig(context).titleSectionStyle(),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.user,
                          color: Theme.of(context).primaryColor,
                          size:
                              Theme.of(context).textTheme.titleLarge!.fontSize,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "${lang(context).authorName}: ",
                          style: LayoutConfig(context).contentSectionStyle(),
                        ),
                        Text(
                          "BOM",
                          style: LayoutConfig(context).titleSectionStyle(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.codeBranch,
                          color: Theme.of(context).primaryColor,
                          size:
                              Theme.of(context).textTheme.titleLarge!.fontSize,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "${lang(context).version}: ",
                          style: LayoutConfig(context).contentSectionStyle(),
                        ),
                        Text(
                          version ?? "N/A",
                          style: LayoutConfig(context).contentSectionStyle(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lang(context).connectWithUs,
                      style: LayoutConfig(context).titleSectionStyle(),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.connectdevelop,
                          color: Theme.of(context).primaryColor,
                          size:
                              Theme.of(context).textTheme.titleLarge!.fontSize,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            lang(context).connectWithUsMessage,
                            style: LayoutConfig(context).contentSectionStyle(),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              // Add share functionality
                            },
                            icon: Icon(
                              FontAwesomeIcons.shareNodes,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // Add Facebook link
                            },
                            icon: Icon(
                              FontAwesomeIcons.facebookF,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // Add privacy policy link
                            },
                            icon: Icon(
                              FontAwesomeIcons.shieldHalved,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // Add email link
                            },
                            icon: Icon(
                              FontAwesomeIcons.envelope,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
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
