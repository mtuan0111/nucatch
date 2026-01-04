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
import 'package:nucatch/helpers/ui_constants.dart';
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
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
                  horizontal: 20,
                  vertical: 10,
                ),
                sliver: SliverToBoxAdapter(
                  child: DeviceWrapper(
                    child: Container(
                      padding: const EdgeInsets.all(kPaddingXL),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surface
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                              LayoutConfig.layoutBorderRadius / 5),
                          topRight:
                              Radius.circular(LayoutConfig.layoutBorderRadius),
                          bottomLeft:
                              Radius.circular(LayoutConfig.layoutBorderRadius),
                          bottomRight:
                              Radius.circular(LayoutConfig.layoutBorderRadius),
                        ),
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimary
                              .withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.solidHeart,
                                color: Theme.of(context).colorScheme.onPrimary,
                                size: 24,
                              ),
                              const SizedBox(width: kSpaceML),
                              Expanded(
                                child: Text(
                                  lang(context).thankYou,
                                  style: LayoutConfig(context)
                                      .titleSectionStyle()
                                      .copyWith(fontSize: kFontSizeL),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            lang(context).introductionContent,
                            style: LayoutConfig(context).contentSectionStyle(),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            lang(context).thankYouMessage,
                            style: LayoutConfig(context)
                                .contentSectionStyle()
                                .copyWith(
                                  fontStyle: FontStyle.italic,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                sliver: SliverToBoxAdapter(
                  child: DeviceWrapper(
                    child: Container(
                      padding: const EdgeInsets.all(kPaddingXL),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surface
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.only(
                          topLeft:
                              Radius.circular(LayoutConfig.layoutBorderRadius),
                          topRight:
                              Radius.circular(LayoutConfig.layoutBorderRadius),
                          bottomLeft:
                              Radius.circular(LayoutConfig.layoutBorderRadius),
                          bottomRight: Radius.circular(
                              LayoutConfig.layoutBorderRadius / 5),
                        ),
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimary
                              .withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.circleInfo,
                                color: Theme.of(context).colorScheme.onPrimary,
                                size: 24,
                              ),
                              const SizedBox(width: kSpaceML),
                              Text(
                                lang(context).authorName,
                                style: LayoutConfig(context)
                                    .titleSectionStyle()
                                    .copyWith(fontSize: kFontSizeL),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildInfoRow(
                            context,
                            FontAwesomeIcons.user,
                            lang(context).authorName,
                            "BOM",
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            context,
                            FontAwesomeIcons.codeBranch,
                            lang(context).version,
                            version ?? "N/A",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                sliver: SliverToBoxAdapter(
                  child: DeviceWrapper(
                    child: Container(
                      padding: const EdgeInsets.all(kPaddingXL),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surface
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                              LayoutConfig.layoutBorderRadius / 5),
                          topRight:
                              Radius.circular(LayoutConfig.layoutBorderRadius),
                          bottomLeft:
                              Radius.circular(LayoutConfig.layoutBorderRadius),
                          bottomRight:
                              Radius.circular(LayoutConfig.layoutBorderRadius),
                        ),
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimary
                              .withOpacity(0.2),
                        ),
                      ),
                      child: BlocBuilder<AppVersionBloc, AppVersionState>(
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.arrowsRotate,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    size: 24,
                                  ),
                                  const SizedBox(width: kSpaceML),
                                  Expanded(
                                    child: Text(
                                      lang(context).appUpdates,
                                      style: LayoutConfig(context)
                                          .titleSectionStyle()
                                          .copyWith(fontSize: kFontSizeL),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(kPaddingL),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(kBorderRadiusL),
                                    topRight: Radius.circular(kBorderRadiusL),
                                    bottomLeft: Radius.circular(kBorderRadiusL),
                                    bottomRight:
                                        Radius.circular(kBorderRadiusL / 5),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      _getStatusIcon(state.status),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        _getUpdateStatusText(context, state),
                                        style: LayoutConfig(context)
                                            .contentSectionStyle(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Center(
                                child: ElevatedButton.icon(
                                  onPressed:
                                      state.status == AppVersionStatus.checking
                                          ? null
                                          : () {
                                              appVersionBloc
                                                  .add(CheckForUpdateEvent());
                                            },
                                  icon: state.status ==
                                          AppVersionStatus.checking
                                      ? SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                            ),
                                          ),
                                        )
                                      : Icon(
                                          FontAwesomeIcons.arrowsRotate,
                                          size: 16,
                                        ),
                                  label: Text(
                                    lang(context).checkForUpdates,
                                    style: LayoutConfig(context)
                                        .contentSectionStyle()
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    foregroundColor:
                                        Theme.of(context).colorScheme.onPrimary,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: kSpace2XL,
                                      vertical: kSpaceML,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft:
                                            Radius.circular(kBorderRadiusL / 5),
                                        topRight:
                                            Radius.circular(kBorderRadiusL),
                                        bottomLeft:
                                            Radius.circular(kBorderRadiusL),
                                        bottomRight:
                                            Radius.circular(kBorderRadiusL),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                sliver: SliverToBoxAdapter(
                  child: DeviceWrapper(
                    child: Container(
                      padding: const EdgeInsets.all(kPaddingXL),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surface
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.only(
                          topLeft:
                              Radius.circular(LayoutConfig.layoutBorderRadius),
                          topRight:
                              Radius.circular(LayoutConfig.layoutBorderRadius),
                          bottomLeft:
                              Radius.circular(LayoutConfig.layoutBorderRadius),
                          bottomRight: Radius.circular(
                              LayoutConfig.layoutBorderRadius / 5),
                        ),
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimary
                              .withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.shareNodes,
                                color: Theme.of(context).colorScheme.onPrimary,
                                size: 24,
                              ),
                              const SizedBox(width: kSpaceML),
                              Expanded(
                                child: Text(
                                  lang(context).connectWithUs,
                                  style: LayoutConfig(context)
                                      .titleSectionStyle()
                                      .copyWith(fontSize: kFontSizeL),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            lang(context).connectWithUsMessage,
                            style: LayoutConfig(context).contentSectionStyle(),
                          ),
                          const SizedBox(height: 20),
                          Wrap(
                            // mainAxisAlignment: MainAxisAlignment.,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 5,
                            runSpacing: 10,
                            children: [
                              _buildSocialButton(
                                context,
                                icon: FontAwesomeIcons.shareNodes,
                                label: 'Share',
                                onTap: () {
                                  // Get the button's position for iPad share sheet
                                  final box =
                                      context.findRenderObject() as RenderBox?;
                                  final sharePositionOrigin = box != null
                                      ? box.localToGlobal(Offset.zero) &
                                          box.size
                                      : null;

                                  if (userState.username == null) {
                                    Share.share(
                                      lang(context).messageShareIntro(
                                        dotenv.env['PROFILE_URL']!,
                                      ),
                                      sharePositionOrigin: sharePositionOrigin,
                                    );
                                  } else {
                                    Share.share(
                                      lang(context)
                                          .messageShareIntroWIthUsername(
                                        userState.username ??
                                            lang(context).anonymous,
                                        dotenv.env['PROFILE_URL']!,
                                      ),
                                      sharePositionOrigin: sharePositionOrigin,
                                    );
                                  }
                                },
                              ),
                              _buildSocialButton(
                                context,
                                icon: FontAwesomeIcons.facebookF,
                                label: 'Facebook',
                                onTap: () {
                                  Helper.launchURL(facebookUrl,
                                      fallbackUrl: facebookUrl);
                                },
                              ),
                              _buildSocialButton(
                                context,
                                icon: FontAwesomeIcons.shieldHalved,
                                label: 'Privacy',
                                onTap: () {
                                  Helper.launchURL(privacyPolicyUrl);
                                },
                              ),
                              _buildSocialButton(
                                context,
                                icon: FontAwesomeIcons.envelope,
                                label: 'Email',
                                onTap: () {
                                  Helper.launchURL("mailto:$email");
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SliverPadding(
                padding: EdgeInsets.only(bottom: 20),
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

  IconData _getStatusIcon(AppVersionStatus status) {
    switch (status) {
      case AppVersionStatus.checking:
        return FontAwesomeIcons.spinner;
      case AppVersionStatus.updateAvailable:
        return FontAwesomeIcons.arrowUp;
      case AppVersionStatus.noUpdate:
        return FontAwesomeIcons.circleCheck;
      case AppVersionStatus.error:
        return FontAwesomeIcons.circleExclamation;
      default:
        return FontAwesomeIcons.circleInfo;
    }
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.onPrimary,
          size: 18,
        ),
        const SizedBox(width: 12),
        Text(
          "$label: ",
          style: LayoutConfig(context).contentSectionStyle(),
        ),
        Expanded(
          child: Text(
            value,
            style: LayoutConfig(context).contentSectionStyle().copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Row(
      children: [
        Expanded(
          child: CustomElevatedButton(
            onPressed: onTap,
            shapeAt: RoundedWithShapeAt.all,
            backgroundColor:
                Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 24,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    label,
                    style: LayoutConfig(context).contentSectionStyle().copyWith(
                          fontSize: kFontSizeXS,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
