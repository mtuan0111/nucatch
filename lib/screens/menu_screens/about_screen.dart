import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/helper.dart';
import 'package:nucatch/helpers/lightning_painter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:skeleton_core/skeleton_core.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key, required this.title});
  final String title;

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> with AppVersionStateMixin {
  String get screenTitle => widget.title;

  SettingBloc get settingBloc => context.read<SettingBloc>();
  SettingState get settingState => settingBloc.state;
  BaseSettingModel get settingModel => settingState.model;

  UserBloc get userBloc => context.read<UserBloc>();
  UserState get userState => userBloc.state;

  AppVersionBloc get appVersionBloc => context.read<AppVersionBloc>();

  String profileUrl = dotenv.env['PROFILE_URL']!;
  String privacyPolicyUrl = dotenv.env['PRIVACY_POLICY_URL']!;
  String facebookUrl = dotenv.env['FACEBOOK_URL']!;
  String email = dotenv.env['EMAIL_CONTACT']!;

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
                    child: CustomWrapContainer(
                      icon: FontAwesomeIcons.solidHeart,
                      title: coreLang(context).thankYou,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lang(context).introductionContent,
                            style: AppTextStyles.bodyLarge(context),
                          ),
                          const SizedBox(height: kSpaceML),
                          Text(
                            coreLang(context).thankYouMessage,
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
                    child: CustomWrapContainer(
                      icon: FontAwesomeIcons.circleInfo,
                      title: coreLang(context).authorName,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow(
                            context,
                            FontAwesomeIcons.user,
                            coreLang(context).authorName,
                            "BOM",
                          ),
                          const SizedBox(height: kSpaceML),
                          _buildInfoRow(
                            context,
                            FontAwesomeIcons.codeBranch,
                            coreLang(context).version,
                            appVersion ?? "N/A",
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
                    child: CustomWrapContainer(
                      icon: FontAwesomeIcons.arrowsRotate,
                      title: coreLang(context).appUpdates,
                      child: BlocBuilder<AppVersionBloc, AppVersionState>(
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(kPaddingL),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withValues(alpha: 0.1),
                                  borderRadius: const BorderRadius.only(
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
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CustomElevatedButton(
                                      text: coreLang(context).checkForUpdates,
                                      onPressed: state.status ==
                                              AppVersionStatus.checking
                                          ? null
                                          : () {
                                              appVersionBloc
                                                  .add(CheckForUpdateEvent());
                                            },
                                      iconData: FontAwesomeIcons.arrowsRotate,
                                      shapeAt: RoundedWithShapeAt.topLeft,
                                      buttonSize: ButtonSize.smallest,
                                    ),
                                  ],
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
                    child: CustomWrapContainer(
                      icon: FontAwesomeIcons.shareNodes,
                      title: coreLang(context).connectWithUs,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: kSpaceL),
                          Text(
                            coreLang(context).connectWithUsMessage,
                            style: AppTextStyles.bodyLarge(context),
                          ),
                          const SizedBox(height: kSpaceXL),
                          Wrap(
                            spacing: kSpaceS,
                            runSpacing: kSpaceM,
                            children: [
                              _buildSocialButton(
                                context,
                                icon: FontAwesomeIcons.shareNodes,
                                label: coreLang(context).share,
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
                                            coreLang(context).anonymous,
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
        return coreLang(context).tapToCheckUpdates;
      case AppVersionStatus.checking:
        return coreLang(context).checkingForUpdates;
      case AppVersionStatus.updateAvailable:
        return coreLang(context).newVersionAvailable(
          state.availableVersion?.versionName ?? '',
          state.isForceUpdate ? coreLang(context).thisUpdateRequired : '',
        );
      case AppVersionStatus.noUpdate:
        return coreLang(context).usingLatestVersion;
      case AppVersionStatus.error:
        return coreLang(context).unableToCheckUpdates(
          state.errorMessage ?? coreLang(context).tryAgainLater,
        );
      case AppVersionStatus.dismissed:
        return coreLang(context).updatePostponed;
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
                Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.1),
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
                    style: AppTextStyles.bodySmall(context),
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
