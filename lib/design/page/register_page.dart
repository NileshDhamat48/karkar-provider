import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:karkar_provider_app/constants/all_imports.dart';
import 'package:karkar_provider_app/constants/app_asstes.dart';
import 'package:karkar_provider_app/constants/app_dimens.dart';
import 'package:karkar_provider_app/constants/app_strings.dart';
import 'package:karkar_provider_app/design/widget/dialog.dart';
import 'package:karkar_provider_app/design/widget/text_field_widget.dart';
import 'package:karkar_provider_app/l10n/l10n.dart';
import 'package:karkar_provider_app/network/api_manager/api_manager.dart';
import 'package:karkar_provider_app/network/response/common_response.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key, required this.phoneNumber}) : super(key: key);

  final String phoneNumber;

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  FocusNode phoneNumberFN = FocusNode();
  FocusNode fullNameFN = FocusNode();
  FocusNode emailAddressFN = FocusNode();
  bool isLoading = false;
  File? pickImageFilePath;

  @override
  void initState() {
    super.initState();
    phoneNumberController.text = widget.phoneNumber;
  }

  validateData() {
    if (pickImageFilePath == null) {
      Utility.showToast(msg: AppLocalizations.of(context).imageisrequired);
    } else if (fullNameController.text.trim().isEmpty) {
      Utility.showToast(msg: AppLocalizations.of(context).fullnameisrequired);
    } else if (emailAddressController.text.trim().isEmpty) {
      Utility.showToast(
          msg: AppLocalizations.of(context).emailaddressisrequired);
    } else if (emailAddressController.text.trim().isNotEmpty &&
        !Utility.isValidEmail(emailAddressController.text.trim())) {
      Utility.showToast(
          msg: AppLocalizations.of(context).enteravalidemailaddress);
    } else if (phoneNumberController.text.trim().isEmpty) {
      Utility.showToast(
          msg: AppLocalizations.of(context).phoneNumberisrequired);
    } else if (phoneNumberController.text.trim().isNotEmpty &&
        phoneNumberController.text.length < 10) {
      Utility.showToast(
          msg: AppLocalizations.of(context)
              .phoneNumbermusthaveatleast10digitNumber);
    } else {
      registerApi();
    }
  }

  Future registerApi() async {
    if (await ApiManager.checkInternet()) {
      _changeLoadingState(true);

      CommonResponse commonResponse = CommonResponse.fromJson(
        await ApiManager(context).multipartRequest(
          url: AppStrings.register,
          files: [
            if (pickImageFilePath != null) MapEntry('image', pickImageFilePath!)
          ],
          request: {
            "mobile_number": phoneNumberController.text.trim(),
            "name": fullNameController.text.trim(),
            "email": emailAddressController.text.trim(),
            'type': "PROVIDER",
          },
        ),
      );

      if (commonResponse.status == '1') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerificationPage(
              phoneNumber: phoneNumberController.text.trim(),
            ),
          ),
        );
      } else {
        Utility.showToast(msg: commonResponse.message);
      }
      _changeLoadingState(false);
    } else {
      Utility.showToast(msg: AppLocalizations.of(context).noInternet);
    }
  }

  _changeLoadingState(bool _loading) {
    isLoading = _loading;
    _notify();
  }

  _notify() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.userbgcolor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.userbgcolor,
        leading: Container(
          margin: const EdgeInsets.only(left: 15),
          child: BackArrowWidget(
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Text(
          AppLocalizations.of(context).register,
          style: const TextStyle(fontSize: 20),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    uploadDialogPopup();
                  },
                  child: Stack(
                    alignment: const Alignment(0.7, -0.8),
                    children: [
                      Container(
                        margin: const EdgeInsets.all(20.0),
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          color: AppColors.greyBorder,
                          borderRadius: BorderRadius.circular(300),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(300),
                          child: pickImageFilePath == null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      AppDimens.borderRadiusCard),
                                  child: Utility.imageLoader(
                                    '',
                                    AppAssets().logo,
                                    BoxFit.cover,
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      AppDimens.borderRadiusCard),
                                  child: Image.file(
                                    pickImageFilePath!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            gradient: AppColors.lineargradient),
                        child: Icon(
                          pickImageFilePath != null
                              ? Icons.check
                              : Icons.camera_alt,
                          size: 30,
                          color: AppColors.whiteColor,
                        ),
                      )
                    ],
                  ),
                ),
                form(),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                  ),
                  child: CommonButton(
                    text: AppLocalizations.of(context).registerNow,
                    onpressed: () {
                      validateData();
                    },
                  ),
                )
              ],
            ),
          ),
          isLoading ? Utility.progress(context) : Container(),
        ],
      ),
    );
  }

  form() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          TextFieldWidget(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 30,
            ),
            hintText: AppLocalizations.of(context).enterFullName,
            label: AppLocalizations.of(context).fullName,
            controller: fullNameController,
            keyboardType: TextInputType.text,
            focusNode: fullNameFN,
            maxLines: 1,
          ),
          TextFieldWidget(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 30,
            ),
            hintText: AppLocalizations.of(context).enterEmailAddress,
            label: AppLocalizations.of(context).emailAddress,
            controller: emailAddressController,
            keyboardType: TextInputType.emailAddress,
            focusNode: emailAddressFN,
            maxLines: 1,
          ),
          TextFieldWidget(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 30,
            ),
            hintText: AppLocalizations.of(context).enterPhonenumber,
            label: AppLocalizations.of(context).phoneNumber,
            enabled: false,
            controller: phoneNumberController,
            keyboardType: TextInputType.number,
            focusNode: phoneNumberFN,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  uploadDialogPopup() {
    DailogBox.cameraAndImagePickerDialog(
      context: context,
      onCameraTap: () {
        Navigator.pop(context);
        getImageFromCamera();
      },
      onGalleryTap: () async {
        Navigator.pop(context);
        pickImageFilePath = await Utility.pickImageFromStorage();
        if (pickImageFilePath == null) {
          Utility.showToast(
              msg: AppLocalizations.of(context).unabletoPickImage);
        }
        _notify();
      },
    );
  }

  Future getImageFromCamera() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    pickImageFilePath = pickedImage != null ? File(pickedImage.path) : null;
    if (pickImageFilePath == null) {
      Utility.showToast(msg: AppLocalizations.of(context).unabletoPickImage);
    }
    _notify();
  }
}
