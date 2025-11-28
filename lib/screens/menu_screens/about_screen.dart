import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/app_version/app_version_bloc.dart';
import 'package:nucatch/blocs/app_version/app_version_event.dart';
import 'package:nucatch/blocs/app_version/app_version_state.dart';
import 'package:nucatch/blocs/objects/setting/setting_bloc.dart';
import 'package:nucatch/blocs/objects/setting/setting_state.dart';
import 'package:nucatch/blocs/objects/user/user_bloc.dart';
import 'package:nucatch/blocs/objects/user/user_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/helper.dart';
import 'package:nucatch/helpers/template.dart';
import 'package:nucatch/models/setting_model.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key, required this.title});
  final String title;

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String get screenTitle => widget.title;

  SettingBloc get settingBloc => context.read<SettingBloc>();
  SettingState get settingState => settingBloc.state;
  SettingModel get settingModel => settingState.model;

  UserBloc get userBloc => context.read<UserBloc>();
  UserState get userState => userBloc.state;

  AppVersionBloc get appVersionBloc => context.read<AppVersionBloc>();

  String? version;
  String? buildNumber;

  String profileUrl = dotenv.env['PROFILE_URL']!;
  String privacyPolicyUrl = dotenv.env['PRIVACY_POLICY_URL']!;
  String facebookUrl = dotenv.env['FACEBOOK_URL']!;
  String email = dotenv.env['EMAIL_CONTACT']!;

  @override
  void initState() {
    super.initState();

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        version = packageInfo.version;
        buildNumber = packageInfo.buildNumber;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: LayoutConfig(context).gradientDecoration,
        child: SafeArea(
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
                  vertical: 20,
                ),
                sliver: SliverToBoxAdapter(
                  child: DeviceWrapper(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomElevatedButton(
                          shapeAt: RoundedWithShapeAt.topLeft,
                          child: Text(
                            lang(context).thankYou,
                            style: LayoutConfig(context).titleSectionStyle(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        CustomElevatedButton(
                          shapeAt: RoundedWithShapeAt.bottomRight,
                          backgroundColor:
                              Theme.of(context).secondaryHeaderColor,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                FontAwesomeIcons.solidHeart,
                                color: Theme.of(context).primaryColor,
                                size: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .fontSize,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "${lang(context).introductionContent}\n\n${lang(context).thankYouMessage}",
                                  style: LayoutConfig(context)
                                      .contentSectionStyle(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                ),
                sliver: SliverToBoxAdapter(
                  child: DeviceWrapper(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomElevatedButton(
                          shapeAt: RoundedWithShapeAt.topLeft,
                          child: Text(
                            lang(context).authorName,
                            style: LayoutConfig(context).titleSectionStyle(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        CustomElevatedButton(
                          shapeAt: RoundedWithShapeAt.bottomRight,
                          backgroundColor:
                              Theme.of(context).secondaryHeaderColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.user,
                                    color: Theme.of(context).primaryColor,
                                    size: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .fontSize,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "${lang(context).authorName}: ",
                                    style: LayoutConfig(context)
                                        .contentSectionStyle(),
                                  ),
                                  Text(
                                    "BOM",
                                    style: LayoutConfig(context)
                                        .titleSectionStyle(),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.codeBranch,
                                    color: Theme.of(context).primaryColor,
                                    size: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .fontSize,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "${lang(context).version}: ",
                                    style: LayoutConfig(context)
                                        .contentSectionStyle(),
                                  ),
                                  Text(
                                    version ?? "N/A",
                                    style: LayoutConfig(context)
                                        .contentSectionStyle(),
                                  ),
                                  if (buildNumber != null) ...[
                                    Text(
                                      " ($buildNumber)",
                                      style: LayoutConfig(context)
                                          .contentSectionStyle()
                                          .copyWith(
                                            fontSize: 12,
                                            color: Theme.of(context).hintColor,
                                          ),
                                    ),
                                  ],
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                ),
                sliver: SliverToBoxAdapter(
                  child: DeviceWrapper(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomElevatedButton(
                          shapeAt: RoundedWithShapeAt.topLeft,
                          child: Text(
                            lang(context).appUpdates,
                            style: LayoutConfig(context).titleSectionStyle(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        BlocBuilder<AppVersionBloc, AppVersionState>(
                          builder: (context, state) {
                            return CustomElevatedButton(
                              shapeAt: RoundedWithShapeAt.bottomRight,
                              backgroundColor:
                                  Theme.of(context).secondaryHeaderColor,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.circleInfo,
                                        color: Theme.of(context).primaryColor,
                                        size: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .fontSize,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          _getUpdateStatusText(context, state),
                                          style: LayoutConfig(context)
                                              .contentSectionStyle(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Center(
                                    child: CustomElevatedButton(
                                      text: lang(context).checkForUpdates,
                                      onPressed: state.status ==
                                              AppVersionStatus.checking
                                          ? null
                                          : () {
                                              appVersionBloc
                                                  .add(CheckForUpdateEvent());
                                            },
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      buttonSize: ButtonSize.small,
                                      shapeAt: RoundedWithShapeAt.topLeft,
                                      iconData: state.status ==
                                              AppVersionStatus.checking
                                          ? null
                                          : FontAwesomeIcons.arrowsRotate,
                                      child: state.status ==
                                              AppVersionStatus.checking
                                          ? SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  Theme.of(context)
                                                      .scaffoldBackgroundColor,
                                                ),
                                              ),
                                            )
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                ),
                sliver: SliverToBoxAdapter(
                  child: DeviceWrapper(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomElevatedButton(
                          shapeAt: RoundedWithShapeAt.topLeft,
                          child: Text(
                            lang(context).connectWithUs,
                            style: LayoutConfig(context).titleSectionStyle(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        CustomElevatedButton(
                          shapeAt: RoundedWithShapeAt.bottomRight,
                          backgroundColor:
                              Theme.of(context).secondaryHeaderColor,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                FontAwesomeIcons.connectdevelop,
                                color: Theme.of(context).primaryColor,
                                size: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .fontSize,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  lang(context).connectWithUsMessage,
                                  style: LayoutConfig(context)
                                      .contentSectionStyle(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () {
                                if (userState.username == null) {
                                  Share.share(
                                    lang(context).messageShareIntro(
                                      dotenv.env['PROFILE_URL']!,
                                    ),
                                  );
                                } else {
                                  Share.share(
                                    lang(context).messageShareIntroWIthUsername(
                                      userState.username ??
                                          lang(context).anonymous,
                                      dotenv.env['PROFILE_URL']!,
                                    ),
                                  );
                                }
                              },
                              icon: Icon(
                                FontAwesomeIcons.shareNodes,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Helper.launchURL(facebookUrl,
                                    fallbackUrl: facebookUrl);
                              },
                              icon: Icon(
                                FontAwesomeIcons.facebookF,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Helper.launchURL(privacyPolicyUrl);
                              },
                              icon: Icon(
                                FontAwesomeIcons.shieldHalved,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Helper.launchURL("mailto:$email");
                              },
                              icon: Icon(
                                FontAwesomeIcons.envelope,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getUpdateStatusText(BuildContext context, AppVersionState state) {
    switch (state.status) {
      case AppVersionStatus.initial:
        return lang(context).tapToCheckUpdates;
      case AppVersionStatus.checking:
        return lang(context).checkingForUpdates;
      case AppVersionStatus.updateAvailable:
        return lang(context).newVersionAvailable(
          state.availableVersion?.versionName ?? '',
          state.isForceUpdate ? lang(context).thisUpdateRequired : '',
        );
      case AppVersionStatus.noUpdate:
        return lang(context).usingLatestVersion;
      case AppVersionStatus.error:
        return lang(context).unableToCheckUpdates(
          state.errorMessage ?? lang(context).tryAgainLater,
        );
      case AppVersionStatus.dismissed:
        return lang(context).updatePostponed;
    }
  }
}
