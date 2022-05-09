import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:karkar_provider_app/constants/all_imports.dart';
import 'package:karkar_provider_app/constants/app_asstes.dart';
import 'package:karkar_provider_app/constants/app_strings.dart';
import 'package:karkar_provider_app/constants/style.dart';
import 'package:karkar_provider_app/design/page/privacypolicypage.dart';
import 'package:karkar_provider_app/design/page/register_page.dart';
import 'package:karkar_provider_app/design/page/tearmandconditionpage.dart';
import 'package:karkar_provider_app/design/widget/button.dart';
import 'package:karkar_provider_app/design/widget/text_field_widget.dart';
import 'package:karkar_provider_app/l10n/l10n.dart';
import 'package:karkar_provider_app/network/api_manager/api_manager.dart';
import 'package:karkar_provider_app/network/models/country_model.dart';
import 'package:karkar_provider_app/network/response/common_response.dart';
import 'package:karkar_provider_app/network/response/country_list_response.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool checkBox = false;
  bool isLoading = false;

  CountryModel? dropdownvalue;
  String selectedPhoneNumber = '';
  String apiPhoneNumber = '';

  List<CountryModel> listData = [];

  TextEditingController phoneNumberController = TextEditingController();
  FocusNode phoneNumberFN = FocusNode();

  @override
  void initState() {
    super.initState();
    getCountryListAPi();
  }

  Future getCountryListAPi() async {
    if (await ApiManager.checkInternet()) {
      _changeLoadingState(true);

      CountryListResponse countryListResponse = CountryListResponse.fromJson(
          await ApiManager(context).getCall(AppStrings.countryList));

      if (countryListResponse.status == '1' &&
          countryListResponse.data != null &&
          countryListResponse.data!.isNotEmpty) {
        listData.addAll(countryListResponse.data!);
      } else if (countryListResponse.status == '0') {
        Utility.showToast(msg: countryListResponse.message);
      }

      _changeLoadingState(false);
    } else {
      Utility.showToast(msg: AppLocalizations.of(context).noInternet);
    }
  }

  _changeLoadingState(bool _isLoading) {
    isLoading = _isLoading;
    _notify();
  }

  validateData() {
    if (selectedPhoneNumber == '' || dropdownvalue == null) {
      Utility.showToast(msg: AppLocalizations.of(context).pleaseselectCountry);
    } else if (phoneNumberController.text.trim().isEmpty) {
      Utility.showToast(
          msg: AppLocalizations.of(context).phoneNumberisrequired);
    } else if (phoneNumberController.text.trim().isNotEmpty &&
        phoneNumberController.text.length < 10) {
      Utility.showToast(
          msg: AppLocalizations.of(context).phoneNumberhaveatleastdigitNumber);
    } else if (checkBox == false) {
      Utility.showToast(
          msg: AppLocalizations.of(context)
              .termsConditionsandPrivacyPolicyisrequired);
    } else {
      var mobileNumber =
          selectedPhoneNumber + phoneNumberController.text.trim();

      if (mobileNumber != '') {
        loginAPi(mobileNumber);
      }
    }
  }

  Future loginAPi(String mobileNumber) async {
    if (await ApiManager.checkInternet()) {
      _changeLoadingState(true);

      var request = <String, dynamic>{};
      request['mobile_number'] = mobileNumber;
      request['type'] = "PROVIDER";

      CommonResponse commonResponse = CommonResponse.fromJson(
          await ApiManager(context).postCall(AppStrings.sendOTP, request));

      if (commonResponse.status == '1') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerificationPage(
              phoneNumber: mobileNumber,
            ),
          ),
        );
      } else if (commonResponse.status == '2') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegisterPage(
              phoneNumber: mobileNumber,
            ),
          ),
        );
      }
      Utility.showToast(msg: commonResponse.message);

      _changeLoadingState(false);
    } else {
      Utility.showToast(msg: AppLocalizations.of(context).noInternet);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appbarBgColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.105,
                ),
                Image.asset(
                  AppAssets().logo,
                  height: 250,
                ),
                dropDown(),
                const SizedBox(
                  height: 16,
                ),
                TextFieldWidget(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  hintText: AppLocalizations.of(context).enterPhonenumber,
                  label: AppLocalizations.of(context).phoneNumber,
                  controller: phoneNumberController,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  focusNode: phoneNumberFN,
                  maxLines: 1,
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Row(
                    children: [
                      Checkbox(
                        value: checkBox,
                        activeColor: AppColors.primaryColor,
                        side: const BorderSide(
                          color: AppColors.whiteColor,
                          width: 2,
                        ),
                        onChanged: (onChanged) {
                          checkBox = !checkBox;
                          _notify();
                        },
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Flexible(
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(fontSize: 18),
                            children: [
                              TextSpan(
                                  text: AppLocalizations.of(context)
                                      .confirmtoacceptour),
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const TearmAndConditionPage(),
                                      ),
                                    );
                                  },
                                text:
                                    AppLocalizations.of(context).termsCondition,
                                style: const TextStyle(
                                  color: AppColors.primaryBlueColor,
                                ),
                              ),
                              TextSpan(
                                  text: AppLocalizations.of(context).andour),
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const PrivacyPolicyPage(),
                                      ),
                                    );
                                  },
                                text:
                                    AppLocalizations.of(context).privacyPolicy,
                                style: const TextStyle(
                                  color: AppColors.primaryBlueColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CommonButton(
                  text: AppLocalizations.of(context).continues,
                  onpressed: () {
                    validateData();
                  },
                ),
              ],
            ),
          ),
          isLoading ? Utility.progress(context) : Container(),
        ],
      ),
    );
  }

  dropDown() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context).selectCountry,
            style: TextStyle(
              color: AppColors.greyColor,
              fontSize: Style().tStyle13(context),
            ),
          ),
          Theme(
            data: ThemeData(
              canvasColor: AppColors.appbarBgColor,
            ),
            child: Center(
              child: DropdownButton<CountryModel>(
                style: const TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 16,
                ),
                // iconDisabledColoxr: AppColors.greenColor,
                value: dropdownvalue,
                hint: Text(
                  AppLocalizations.of(context).selectCountry,
                  style: const TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 18,
                  ),
                ),
                isExpanded: true,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.greyColor,
                ),
                onChanged: (CountryModel? newValue) {
                  dropdownvalue = newValue!;

                  selectedPhoneNumber =
                      dropdownvalue?.phonecode?.toString() ?? '';

                  if (selectedPhoneNumber != '') {
                    selectedPhoneNumber = '+' + selectedPhoneNumber;
                  }

                  _notify();
                },
                items: listData.map((value) {
                  return DropdownMenuItem<CountryModel>(
                    value: value,
                    child: Text(
                      "(${value.phonecode ?? ''})  ${value.name ?? ''}",
                      style: const TextStyle(
                        color: AppColors.whiteColor,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _notify() {
    if (mounted) setState(() {});
  }
}
