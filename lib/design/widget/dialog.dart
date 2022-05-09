import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:karkar_provider_app/constants/all_imports.dart';
import 'package:karkar_provider_app/constants/app_dimens.dart';
import 'package:karkar_provider_app/design/widget/custom_button.dart';
import 'package:karkar_provider_app/design/widget/g_icon.dart';
import 'package:karkar_provider_app/l10n/l10n.dart';

class DailogBox {
  static Future<Widget?> logoutDialog({
    required BuildContext context,
    required void Function() onNoTap,
    required void Function() onYesTap,
    String? title,
    message,
    noText,
    yesText,
  }) {
    return showDialog<Widget>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.zero,
          title: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4), topRight: Radius.circular(4)),
              gradient: AppColors.appGradient,
            ),
            child: Text(
              title ?? AppLocalizations.of(context).logout,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                letterSpacing: 0.6,
                color: AppColors.whiteColor,
                fontSize: 18.0,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  message ?? AppLocalizations.of(context).logouMsg,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    letterSpacing: 0.6,
                    color: AppColors.primaryColor,
                    fontSize: 18.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: CustomButton(
                      onPressed: onNoTap,
                      maxWidth: MediaQuery.of(context).size.width / 2,
                      // padding: const EdgeInsets.all(10),
                      text: Text(
                        noText ?? AppLocalizations.of(context).no,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Flexible(
                    child: CustomButton(
                      onPressed: onYesTap,
                      maxWidth: MediaQuery.of(context).size.width / 2,
                      padding: const EdgeInsets.all(10),
                      text: Text(
                        yesText ?? AppLocalizations.of(context).yes,
                      ),
                      backgroundColor: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<Widget?> cameraAndImagePickerDialog({
    required BuildContext context,
    required void Function() onCameraTap,
    required void Function() onGalleryTap,
  }) {
    return showDialog<Widget>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.zero,
          title: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4), topRight: Radius.circular(4)),
              gradient: AppColors.appGradient,
            ),
            // ignore: prefer_const_constructors
            child: Text(
              AppLocalizations.of(context).selectFile,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                letterSpacing: 0.6,
                color: AppColors.whiteColor,
                fontSize: 18.0,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: onCameraTap,
                      child: Column(
                        children: <Widget>[
                          const GIcon(
                            icon: CupertinoIcons.camera_fill,
                            size: 35,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            AppLocalizations.of(context).clickaPhoto,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              letterSpacing: 0.6,
                              color: AppColors.blackColor,
                              fontSize: 18.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: onGalleryTap,
                      child: Column(
                        children: <Widget>[
                          const GIcon(
                            icon: CupertinoIcons.photo,
                            size: 35,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            AppLocalizations.of(context).choosefromphotoGallery,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              letterSpacing: 0.6,
                              color: AppColors.blackColor,
                              fontSize: 18.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(AppDimens.borderRadiusCard),
                    color: AppColors.red,
                  ),
                  child: Text(
                    AppLocalizations.of(context).close,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      letterSpacing: 0.6,
                      color: AppColors.whiteColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  static Future<Widget?> addPrice({
    required BuildContext context,
    required void Function() onNoTap,
    required void Function() onYesTap,
    required TextEditingController controller,
    required FocusNode focusNode,
  }) {
    return showDialog<Widget>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.zero,
          title: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
              gradient: AppColors.appGradient,
            ),
            child: Text(
              AppLocalizations.of(context).addPrice,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                letterSpacing: 0.6,
                color: AppColors.whiteColor,
                fontSize: 18.0,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: controller,
                focusNode: focusNode,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).addAmount,
                  hintStyle: const TextStyle(color: AppColors.greyColor),
                  contentPadding: const EdgeInsets.only(
                    top: 6,
                    left: 16,
                  ),
                  prefixIcon: Container(
                    width: MediaQuery.of(context).size.width * 0.12,
                    height: MediaQuery.of(context).size.height * 0.06,
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.only(right: 16.0),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppDimens.borderRadiusCard),
                        bottomLeft: Radius.circular(AppDimens.borderRadiusCard),
                      ),
                    ),
                    child: Center(
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.center,
                        onPressed: () {},
                        icon: const Icon(
                          FontAwesomeIcons.euroSign,
                          color: AppColors.whiteColor,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                  filled: true,
                  fillColor: AppColors.greyBoxColor,
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimens.borderRadiusCard),
                    borderSide: const BorderSide(
                      width: 0.15,
                      color: AppColors.greyBoxColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimens.borderRadiusCard),
                    borderSide: const BorderSide(
                      width: 1,
                      color: AppColors.greyBoxColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: CustomButton(
                      onPressed: onNoTap,
                      maxWidth: MediaQuery.of(context).size.width / 2,
                      // padding: const EdgeInsets.all(10),
                      text: Text(
                        AppLocalizations.of(context).cancel,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Flexible(
                    child: CustomButton(
                      onPressed: onYesTap,
                      maxWidth: MediaQuery.of(context).size.width / 2,
                      padding: const EdgeInsets.all(10),
                      text: Text(
                        AppLocalizations.of(context).add,
                      ),
                      backgroundColor: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
