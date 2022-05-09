import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:karkar_provider_app/constants/all_imports.dart';
import 'package:karkar_provider_app/constants/app_asstes.dart';
import 'package:karkar_provider_app/constants/app_strings.dart';
import 'package:karkar_provider_app/design/page/faqs_page.dart';
import 'package:karkar_provider_app/design/page/my_offer_page.dart';
import 'package:karkar_provider_app/design/page/my_services.dart';
import 'package:karkar_provider_app/design/page/profile_setting.dart';
import 'package:karkar_provider_app/design/page/support_page.dart';
import 'package:karkar_provider_app/design/widget/dialog.dart';
import 'package:karkar_provider_app/l10n/l10n.dart';
import 'package:karkar_provider_app/network/api_manager/api_manager.dart';
import 'package:karkar_provider_app/network/firebase_messaging_services.dart';
import 'package:karkar_provider_app/network/models/user_data.dart';
import 'package:karkar_provider_app/network/response/common_response.dart';
import 'package:karkar_provider_app/network/response/user_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MorePage extends StatefulWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  bool isLoading = false;

  UserResponse? userResponse, prefUserResponse;
  UserData? userData, prefUserData;

  @override
  void initState() {
    super.initState();
    getPref();
  }

  getPref() async {
    prefUserResponse = await Utility.getUserPref();
    if (prefUserResponse != null && prefUserResponse?.data != null && prefUserResponse?.data?.id != null) {
      prefUserData = prefUserResponse?.data;

      await userDetailAPi(prefUserData?.id.toString() ?? '');
      _notify();
    }
  }

  Future userDetailAPi(String userId) async {
    if (await ApiManager.checkInternet()) {
      _changeLoadingState(true);
      var request = <String, dynamic>{};
      request['user_id'] = userId;
      UserResponse userResponse = UserResponse.fromJson(
        await ApiManager(context).getCall(
          AppStrings.usersDetails,
          request,
        ),
      );

      if (userResponse.status == '1' && userResponse.data != null) {
        userData = userResponse.data;
      } else {
        Utility.showToast(msg: userResponse.message);
      }

      _changeLoadingState(false);
    } else {
      Utility.showToast(msg: AppLocalizations.of(context).noInternet);
    }
  }

  _refresh() {
    isLoading = false;
    prefUserData = null;
    userData = null;
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appbarBgColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 50),
                  height: 250,
                  width: MediaQuery.of(context).size.width * 4,
                  child: Utility.imageLoader(
                    userData?.imageUrl ?? '',
                    AppAssets().logo,
                    BoxFit.cover,
                  ),
                ),
                Container(
                  color: AppColors.glassEffact,
                  padding: const EdgeInsets.only(top: 15, left: 20, bottom: 15),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userData?.name ?? '',
                        style: const TextStyle(color: AppColors.whiteColor, fontSize: 20),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        userData?.address ?? '',
                        maxLines: 1,
                        style: const TextStyle(color: AppColors.greyColor, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileSetting(),
                      ),
                    );
                    _refresh();
                  },
                  child: Container(
                    color: AppColors.glassEffact,
                    margin: const EdgeInsets.only(top: 6),
                    padding: const EdgeInsets.only(top: 15, left: 20, bottom: 15),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.settings,
                          color: AppColors.bookingDetailsIconcolor,
                        ),
                        const SizedBox(
                          width: 35,
                        ),
                        Text(
                          AppLocalizations.of(context).profileSetting,
                          style: const TextStyle(color: AppColors.greyColor, fontSize: 16),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const MyServices()));
                  },
                  child: Container(
                    color: AppColors.glassEffact,
                    padding: const EdgeInsets.only(top: 15, left: 20, bottom: 15),
                    child: Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.carAlt,
                          color: AppColors.bookingDetailsIconcolor,
                        ),
                        const SizedBox(
                          width: 35,
                        ),
                        Text(
                          AppLocalizations.of(context).myServices,
                          style: const TextStyle(color: AppColors.greyColor, fontSize: 16),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const MyOfferPage()));
                  },
                  child: Container(
                    color: AppColors.glassEffact,
                    padding: const EdgeInsets.only(top: 15, left: 20, bottom: 15),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.verified_user_sharp,
                          color: AppColors.bookingDetailsIconcolor,
                        ),
                        const SizedBox(
                          width: 35,
                        ),
                        Text(
                          AppLocalizations.of(context).myOffers,
                          style: const TextStyle(color: AppColors.greyColor, fontSize: 16),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SelectLanguage(),
                      ),
                    );
                  },
                  child: Container(
                    color: AppColors.glassEffact,
                    padding: const EdgeInsets.only(top: 15, left: 20, bottom: 15),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.language,
                          color: AppColors.bookingDetailsIconcolor,
                        ),
                        const SizedBox(
                          width: 35,
                        ),
                        Text(
                          AppLocalizations.of(context).changeLanguage,
                          style: const TextStyle(color: AppColors.greyColor, fontSize: 16),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SupportPage()));
                  },
                  child: Container(
                    color: AppColors.glassEffact,
                    padding: const EdgeInsets.only(top: 15, left: 20, bottom: 15),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.mail_sharp,
                          color: AppColors.bookingDetailsIconcolor,
                        ),
                        const SizedBox(
                          width: 35,
                        ),
                        Text(
                          AppLocalizations.of(context).contactus,
                          style: const TextStyle(color: AppColors.greyColor, fontSize: 16),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FaqsPage(),
                      ),
                    );
                  },
                  child: Container(
                    color: AppColors.glassEffact,
                    padding: const EdgeInsets.only(top: 15, left: 20, bottom: 15),
                    child: Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.questionCircle,
                          color: AppColors.bookingDetailsIconcolor,
                        ),
                        const SizedBox(
                          width: 35,
                        ),
                        Text(
                          AppLocalizations.of(context).faqs,
                          style: const TextStyle(color: AppColors.greyColor, fontSize: 16),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    logoutDialogPopup();
                  },
                  child: Container(
                    color: AppColors.glassEffact,
                    padding: const EdgeInsets.only(top: 15, left: 20, bottom: 15),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.login_sharp,
                          color: AppColors.bookingDetailsIconcolor,
                        ),
                        const SizedBox(
                          width: 35,
                        ),
                        Text(
                          AppLocalizations.of(context).logout,
                          style: const TextStyle(color: AppColors.greyColor, fontSize: 16),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          isLoading ? Utility.progress(context) : const SizedBox()
        ],
      ),
    );
  }

  logoutDialogPopup() {
    DailogBox.logoutDialog(
      context: context,
      onNoTap: () {
        Navigator.pop(context);
      },
      onYesTap: () {
        Navigator.pop(context);
        logOutAPI();
      },
    );
  }

  Future logOutAPI() async {
    if (await ApiManager.checkInternet()) {
      _changeLoadingState(true);

      var request = <String, dynamic>{};

      request['firebase_id'] = FirebaseMessagingService.token;

      CommonResponse commonResponse = CommonResponse.fromJson(
        await ApiManager(context).postCall(AppStrings.usersLogout, request),
      );

      if (commonResponse.status == '1') {
        Utility.showToast(msg: commonResponse.message);
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.remove(AppStrings.userPrefKey);
        sharedPreferences.clear();

        // ---Navigation ----
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
            (route) => false);
        // ---Navigation ----

      } else {
        Utility.showToast(msg: commonResponse.message);
      }
      _changeLoadingState(false);
    } else {
      Utility.showToast(msg: AppLocalizations.of(context).noInternet);
    }
  }

  dynamic _changeLoadingState(bool _isLoading) {
    isLoading = _isLoading;
    _notify();
  }

  _notify() {
    if (mounted) setState(() {});
  }
}
