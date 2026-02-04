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
import 'package:nucatch/helpers/app_text_styles.dart';
import 'package:nucatch/blocs/objects/user/user_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/helper.dart';
import 'package:nucatch/helpers/template.dart';
import 'package:nucatch/helpers/ui_constants.dart';
import 'package:nucatch/widgets/custom_sliver_app_bar.dart';
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
              CustomSliverAppBar(
                title: screenTitle,
                onBackPressed: () {
                  Navigator.pop(context);
                },
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
                                size: kIconSizeM,
                              ),
                              const SizedBox(width: kSpaceML),
                              Expanded(
                                child: Text(
                                  lang(context).thankYou,
                                  style: AppTextStyles.titleLarge(context)
                                      .copyWith(fontSize: kFontSizeL),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: kSpaceL),
                          Text(
                            lang(context).introductionContent,
                            style: AppTextStyles.bodyLarge(context),
                          ),
                          const SizedBox(height: kSpaceML),
                          Text(
                            lang(context).thankYouMessage,
                            style: AppTextStyles.bodyLarge(context).copyWith(
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
                                size: kIconSizeM,
                              ),
                              const SizedBox(width: kSpaceML),
                              Text(
                                lang(context).authorName,
                                style: AppTextStyles.titleLarge(context)
                                    .copyWith(fontSize: kFontSizeL),
                              ),
                            ],
                          ),
                          const SizedBox(height: kSpaceL),
                          _buildInfoRow(
                            context,
                            FontAwesomeIcons.user,
                            lang(context).authorName,
                            "BOM",
                          ),
                          const SizedBox(height: kSpaceML),
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
                                    size: kIconSizeM,
                                  ),
                                  const SizedBox(width: kSpaceML),
                                  Expanded(
                                    child: Text(
                                      lang(context).appUpdates,
                                      style: AppTextStyles.titleLarge(context)
                                          .copyWith(fontSize: kFontSizeL),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: kSpaceL),
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
                                      size: kIconSizeM,
                                    ),
                                    const SizedBox(width: kSpaceML),
                                    Expanded(
                                      child: Text(
                                        _getUpdateStatusText(context, state),
                                        style: AppTextStyles.bodyLarge(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: kSpaceL),
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
                                          size: kIconSizeS,
                                        ),
                                  label: Text(
                                    lang(context).checkForUpdates,
                                    style: AppTextStyles.withColor(
                                        AppTextStyles.bodyLarge(context),
                                        Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
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
                                size: kIconSizeM,
                              ),
                              const SizedBox(width: kSpaceML),
                              Expanded(
                                child: Text(
                                  lang(context).connectWithUs,
                                  style: AppTextStyles.titleLarge(context)
                                      .copyWith(fontSize: kFontSizeL),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: kSpaceL),
                          Text(
                            lang(context).connectWithUsMessage,
                            style: AppTextStyles.bodyLarge(context),
                          ),
                          const SizedBox(height: kSpaceXL),
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
          size: kIconSizeS,
        ),
        const SizedBox(width: kSpaceML),
        Text(
          "$label: ",
          style: AppTextStyles.bodyLarge(context),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodyLarge(context).copyWith(
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
                    size: kIconSizeM,
                  ),
                  const SizedBox(width: kSpaceS),
                  Text(
                    label,
                    style: AppTextStyles.bodyLarge(context).copyWith(
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
