import 'dart:convert';

import 'package:karkar_provider_app/constants/all_imports.dart';
import 'package:karkar_provider_app/constants/app_strings.dart';
import 'package:karkar_provider_app/design/widget/text_field_widget.dart';
import 'package:karkar_provider_app/l10n/l10n.dart';
import 'package:karkar_provider_app/main.dart';
import 'package:karkar_provider_app/network/api_manager/api_manager.dart';
import 'package:karkar_provider_app/network/firebase_messaging_services.dart';
import 'package:karkar_provider_app/network/response/user_response.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({Key? key, required this.phoneNumber})
      : super(key: key);
  final String phoneNumber;

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  TextEditingController codeController = TextEditingController();
  FocusNode codeFN = FocusNode();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appbarBgColor,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        backgroundColor: AppColors.appbarBgColor,
        leading: BackArrowWidget(
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          AppLocalizations.of(context).verification,
          style: const TextStyle(fontSize: 20),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Text(
                    // "Enter Verification Code we've sent on given number ",
                    "${AppLocalizations.of(context).verificationCodesenton}  ${widget.phoneNumber}",
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppColors.whiteColor,
                    ),
                  ),
                  TextFieldWidget(
                    padding: const EdgeInsets.only(
                      top: 50,
                    ),
                    hintText: AppLocalizations.of(context).verificationCode,
                    label: AppLocalizations.of(context).enterVerificationCode,
                    controller: codeController,
                    keyboardType: TextInputType.number,
                    focusNode: codeFN,
                    maxLines: 1,
                    maxLength: 6,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  CommonButton(
                    text: AppLocalizations.of(context).submit,
                    onpressed: () {
                      validateOtp();
                    },
                  )
                ],
              ),
            ),
          ),
          isLoading ? Utility.progress(context) : Container(),
        ],
      ), //stack
    );
  }

  validateOtp() {
    if (codeController.text.trim() == '') {
      Utility.showToast(msg: AppLocalizations.of(context).pleaseenterotp);
    } else if (codeController.text.trim().isNotEmpty &&
        codeController.text.length < 6) {
      Utility.showToast(msg: AppLocalizations.of(context).otpdigitsnumber);
    } else {
      verifyOTP();
    }
  }

  void verifyOTP() async {
    if (await ApiManager.checkInternet()) {
      _changeLoadingState(true);
      var request = <String, dynamic>{};
      request['mobile_number'] = widget.phoneNumber;
      request['otp'] = codeController.text.trim();
      request['firebase_id'] = FirebaseMessagingService.token ?? '';
      // request['firebase_id'] = "TEST-242";
      request['type'] = "PROVIDER";

      UserResponse userResponse = UserResponse.fromJson(
        await ApiManager(context).postCall(
          AppStrings.verifyOtp,
          request,
        ),
      );
      _changeLoadingState(false);
      Utility.showToast(msg: userResponse.message);
      if (userResponse.status == "1" && userResponse.data != null) {
        await sharedPreferences.setString(
            AppStrings.userPrefKey, jsonEncode(userResponse.toJson()));
        gotoHome();
      } else if (userResponse.status == '0') {
        Utility.showToast(msg: userResponse.message);
      }
    } else {
      Utility.showToast(msg: AppLocalizations.of(context).noInternet);
    }
  }

  void gotoHome() {
    Navigator.pushAndRemoveUntil<void>(
      context,
      MaterialPageRoute(
        builder: (context) => const Home(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  _changeLoadingState(bool _isLoading) {
    isLoading = _isLoading;
    _notify();
  }

  _notify() {
    if (mounted) setState(() {});
  }
}
