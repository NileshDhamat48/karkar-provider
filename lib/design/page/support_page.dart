import 'package:karkar_provider_app/constants/all_imports.dart';
import 'package:karkar_provider_app/constants/app_strings.dart';
import 'package:karkar_provider_app/design/widget/button.dart';
import 'package:karkar_provider_app/design/widget/text_field_widget.dart';
import 'package:karkar_provider_app/l10n/l10n.dart';
import 'package:karkar_provider_app/network/api_manager/api_manager.dart';
import 'package:karkar_provider_app/network/models/setting_model.dart';
import 'package:karkar_provider_app/network/response/common_response.dart';
import 'package:karkar_provider_app/network/response/setting_response.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  TextEditingController contactnumberController = TextEditingController();
  FocusNode contactnumberFN = FocusNode();

  TextEditingController writeyourmessageController = TextEditingController();
  FocusNode writeyourmessageFN = FocusNode();

  TextEditingController fullnameController = TextEditingController();
  FocusNode fullnameFN = FocusNode();

  bool isLoading = false;

  SettingResponse? termsOfUseResponse;
  List<SettingModel>? listData = [];
  String phoneNumber = '';
  String emailAddress = '';

  @override
  void initState() {
    super.initState();
    termsOfUSeAPI();
  }

  void termsOfUSeAPI() async {
    if (await ApiManager.checkInternet()) {
      _changeLoadingState(true);
      var request = <String, dynamic>{};
      request['type'] = "CONTACT";
      SettingResponse termsOfUseResponse = SettingResponse.fromJson(
        await ApiManager(context).getCall(
          AppStrings.setting,
          request,
        ),
      );

      if (termsOfUseResponse.status == '1' &&
          termsOfUseResponse.data != null &&
          termsOfUseResponse.data!.isNotEmpty) {
        listData!.addAll(termsOfUseResponse.data!);

        var phone =
            listData!.firstWhere((element) => element.key == 'support_phone');

        phoneNumber = phone.value ?? '';

        var email =
            listData!.firstWhere((element) => element.key == 'support_email');

        emailAddress = email.value ?? '';
      } else {
        Utility.showToast(msg: termsOfUseResponse.message);
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

  _notify() {
    if (mounted) setState(() {});
  }

  // --- add support ---

  validateData() {
    if (fullnameController.text.isEmpty) {
      Utility.showToast(msg: AppLocalizations.of(context).fullnameisreqiured);
    } else if (contactnumberController.text.isEmpty) {
      Utility.showToast(
          msg: AppLocalizations.of(context).contactnumberisrequired);
    } else if (contactnumberController.text.trim().isNotEmpty &&
        contactnumberController.text.length < 10) {
      Utility.showToast(
          msg: AppLocalizations.of(context)
              .contactNumbermusthaveatleast10digitNumber);
    } else if (writeyourmessageController.text.isEmpty) {
      Utility.showToast(msg: AppLocalizations.of(context).enterthemessage);
    } else {
      supportAPi();
    }
  }

  Future supportAPi() async {
    if (await ApiManager.checkInternet()) {
      _changeLoadingState(true);

      var request = <String, dynamic>{};

      request['contact_info'] = contactnumberController.text.trim();
      request['message'] = writeyourmessageController.text.trim();
      request['name'] = fullnameController.text.trim();

      CommonResponse commonResponse = CommonResponse.fromJson(
        await ApiManager(context).postCall(AppStrings.addSupport, request),
      );

      if (commonResponse.status == '1') {
        contactnumberController.clear();
        writeyourmessageController.clear();
        fullnameController.clear();
        Navigator.of(context).pop();
        Utility.showToast(msg: commonResponse.message);
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
      backgroundColor: AppColors.bodybgcolor,
      appBar: AppBar(
        backgroundColor: AppColors.appbarBgColor,
        leading: BackArrowWidget(
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          AppLocalizations.of(context).support,
          style: const TextStyle(fontSize: 20),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(left: 20, top: 22, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).weareHappytohearfromyou,
                    style: const TextStyle(
                        color: AppColors.whiteColor, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    AppLocalizations.of(context)
                        .letusknowyourqueriesandFeedbacks,
                    style: const TextStyle(
                        color: AppColors.greyColor, fontSize: 14),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [button1(context), button2(context)],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.mail_rounded,
                        color: AppColors.bookingDetailsIconcolor,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        AppLocalizations.of(context).sendYourMessage,
                        style: const TextStyle(
                            color: AppColors.whiteColor, fontSize: 18),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: Column(
                      children: [
                        TextFieldWidget(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          hintText: AppLocalizations.of(context).enterFullName,
                          label: AppLocalizations.of(context).fullName,
                          controller: fullnameController,
                          keyboardType: TextInputType.text,
                          focusNode: fullnameFN,
                          maxLines: 1,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFieldWidget(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          hintText:
                              AppLocalizations.of(context).enterContactnumber,
                          label: AppLocalizations.of(context).contactNumber,
                          controller: contactnumberController,
                          keyboardType: TextInputType.number,
                          focusNode: contactnumberFN,
                          maxLines: 1,
                          maxLength: 10,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFieldWidget(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          hintText:
                              AppLocalizations.of(context).writeyourmessage,
                          label: AppLocalizations.of(context).writeyourmessage,
                          controller: writeyourmessageController,
                          keyboardType: TextInputType.text,
                          focusNode: writeyourmessageFN,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 150),
                    child: CommonButton(
                      text: AppLocalizations.of(context).submit,
                      onpressed: () {
                        validateData();
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          if (isLoading) Utility.progress(context)
        ],
      ),
    );
  }

  Widget button1(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (phoneNumber.isNotEmpty) {
          final Uri phoneLaunchUri = Uri(
            scheme: 'tel',
            path: phoneNumber,
          );

          launch(phoneLaunchUri.toString());
        } else {
          Utility.showToast(
              msg: AppLocalizations.of(context).nophonenumberfound);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),

        // margin: EdgeInsets.all(16.0),
        // margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: AppColors.whiteColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Icon(
              Icons.phone,
              size: 18,
              color: AppColors.bookingDetailsIconcolor,
            ),
            const SizedBox(
              width: 16,
            ),
            Text(
              AppLocalizations.of(context).callUs,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.bookingDetailsIconcolor,
              ),
            ),
          ],
        ),
      ),
      // onTap: onpressed,
    );
  }

  Widget button2(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (emailAddress.isNotEmpty) {
          final Uri emailLaunchUri = Uri(
            scheme: 'mailto',
            path: emailAddress,
          );

          launch(emailLaunchUri.toString());
        } else {
          Utility.showToast(msg: AppLocalizations.of(context).noemailfound);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        margin: const EdgeInsets.only(left: 16.0),
        // margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          gradient: AppColors.lineargradient,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.mail_rounded,
              size: 18,
              color: AppColors.whiteColor,
            ),
            const SizedBox(
              width: 16,
            ),
            Text(
              AppLocalizations.of(context).mailUs,
              style: const TextStyle(fontSize: 17, color: AppColors.whiteColor),
            ),
          ],
        ),
      ),
      // onTap: onpressed,
    );
  }
}
