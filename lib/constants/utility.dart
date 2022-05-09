// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:karkar_provider_app/constants/app_colors.dart';
import 'package:karkar_provider_app/constants/app_strings.dart';
import 'package:karkar_provider_app/l10n/l10n.dart';
import 'package:karkar_provider_app/network/response/user_response.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

extension DateTimeExtension on DateTime {
  DateTime applied(TimeOfDay time) {
    return DateTime(time.hour, time.minute);
  }
}

class Utility {
  static String? showToast({required String msg}) {
    Fluttertoast.showToast(msg: msg);
    return null;
  }

  static bool isValidEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(p);
    return regExp.hasMatch(em);
  }

  static bool isValidName(String em) {
    String p = r'^[a-zA-Z0-9 ]+$';
    RegExp regExp = RegExp(p);
    return regExp.hasMatch(em);
  }

  static bool isValidNumber(String em) {
    String p = r'^[0-9]+$';
    RegExp regExp = RegExp(p);
    return regExp.hasMatch(em);
  }

  static bool isValidDouble(String em) {
    String p = r'^[0-9]+\d+\.?\d*\d,';
    RegExp regExp = RegExp(p);
    return regExp.hasMatch(em);
  }

  static Future setLangauage(Locale langauge) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(AppStrings.languageKey, langauge.languageCode);
  }

  static Future<Locale> getLangauge() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final langaugeString = pref.getString(AppStrings.languageKey);
      print('-------------');
      print(langaugeString);
      print('-------------');

      if (langaugeString != null) {
        return langaugeString == 'en' ? AppLocalizations.supportedLocales[0] : AppLocalizations.supportedLocales[1];
      }
      return AppLocalizations.supportedLocales[1];
    } catch (e) {
      return AppLocalizations.supportedLocales[1];
    }
  }

  // --- getUserPref ---

  static Future<UserResponse?> getUserPref() async {
    UserResponse? userResponse;

    final sharedPreferences = await SharedPreferences.getInstance();
    try {
      if (sharedPreferences.getString(AppStrings.userPrefKey) != null) {
        userResponse = UserResponse.fromJson(
          jsonDecode(
            sharedPreferences.getString(AppStrings.userPrefKey)!,
          ),
        );

        if (userResponse.data != null) {
          return userResponse;
        } else {
          return null;
        }
      }
    } catch (e) {
      return null;
    }
    return null;
  }
  // --- Pick Image --- from Storage ---

  static Future<File?> pickImageFromStorage() async {
    File? filepath;

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jepg'],
      );

      if (result != null) {
        filepath = File(result.files.single.path!);
        print('-------------------');
        print(filepath.path);
        print('-------------------');
        return filepath;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
  // --- Pick Image --- from Storage ---

  //static bool isSwitchOn() {}

  List<DateTime> getDaysInBeteween(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }

  String getDateTimeFromTimestamp(String? timeStamp) {
    try {
      if (timeStamp != null) {
        var dt = DateTime.fromMillisecondsSinceEpoch(int.tryParse(timeStamp) ?? 0);
        var formatedDate = DateFormat('dd MMM, yyyy-hh:mm a').format(dt);
        return formatedDate;
      }
      return '';
    } catch (e) {
      print("ERROR IN DATE TIME FROM TIME STAMP::::");
      return '';
    }
  }

  // removeListScrollingEffect({Widget? child}) {
  //   return NotificationListener<OverscrollIndicatorNotification>(
  //       onNotification: (OverscrollIndicatorNotification overscroll) {
  //         overscroll.disallowGlow();
  //       },
  //       child: child);
  // }

  static Theme datePickerTheme(Widget child) {
    return Theme(
      data: ThemeData.light().copyWith(
        primaryColor: AppColors.primaryColor,
        colorScheme: const ColorScheme.light(primary: AppColors.primaryColor),
        buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
      ),
      child: child,
    );
  }

  Future<bool> hasAuth({bool gotoLogin = false, required BuildContext context}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString(AppStrings.userPrefKey) != null) {
      return true;
    }
    return false;
  }

  // Future<UserResponse?> getPrefUser() async {
  //   if (sharedPreferences.getString(AppStrings.userPrefKey) != null) {
  //     return UserResponse.fromJson(
  //       jsonDecode(sharedPreferences.getString(AppStrings.userPrefKey)!),
  //     );
  //   }
  //   return null;
  // }

  // static Image imageLoaderImage(String url, String placeholder) {
  //   return url == null || url == ""
  //       ? Image.asset(placeholder)
  //       : Image.network(
  //           // url,
  //           (url.startsWith("http")) ? url : AppStrings.FILE_URL + url,
  //           //AppStrings.IMAGE_BASE_URL + url,
  //           fit: BoxFit.contain,
  //           loadingBuilder: (BuildContext context, Widget child,
  //               ImageChunkEvent loadingProgress) {
  //             if (loadingProgress == null) return child;
  //             return progress(context);
  //           },
  //         );
  // }

  static Future<void> urlLauncher(String url) async {
    if (url != '') {
      await launch(url.startsWith('http') ? url : 'http://$url');
    }
  }

  static String dateForDisplay(DateTime date) {
    return DateFormat('dd MMM, yyyy') //this format is for returning
        .format(date);
  }

  BoxDecoration getBoxDecoration({double? radius, Color? color}) {
    return BoxDecoration(
        color: color ?? Colors.white,
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 4,
            color: Colors.black26,
          ),
        ],
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 5)));
  }

  // BoxDecoration getGreyBoxDecoration({double? radius, Color? color}) {
  //   return BoxDecoration(
  //       color: color ?? AppColors.geryBoxColor,
  //       // boxShadow: [
  //       //   BoxShadow(
  //       //     offset: Offset(0, 1),
  //       //     blurRadius: 4,
  //       //     color: Colors.black26,
  //       //   ),
  //       // ],
  //       borderRadius: BorderRadius.all(Radius.circular(radius ?? 5)));
  // }

  static Widget progress(BuildContext context, {double? width, double? height}) {
    return Container(
      color: Colors.transparent,
      alignment: Alignment.center,
      child: Container(
        color: AppColors.primaryColor,
        width: width ?? MediaQuery.of(context).size.width / 4,
        child: const LinearProgressIndicator(
          color: AppColors.blackColor,
        ),
      ),
    );
  }

  static Widget imageLoader(String url, String placeholder, BoxFit fit) {
    // if (url != null || url != "null" || url.trim() != "") {
    //   if (!url.startsWith("http")) {
    //     url = AppStrings.STORAGE_URL + url;
    //   }
    // }
    return (url == "null" || url.trim() == "")
        ? Image.asset(placeholder)
        : CachedNetworkImage(
            imageUrl: url,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: fit,
                ),
              ),
            ),
            placeholder: (context, url) => progress(context),
            errorWidget: (context, url, error) => Image.asset(placeholder),
          );
  }

  static Image imageLoaderImage(String url, String placeholder) {
    return url == ""
        ? Image.asset(placeholder)
        : Image.network(
            // url,
            (url.startsWith('http')) ? url : AppStrings.userPrefKey + url,
            //AppStrings.IMAGE_BASE_URL + url,
            fit: BoxFit.contain,
            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return progress(context);
            },
          );
  }
  // static progressWithPercentage(
  //     double width, bool isLoading, int value, AppDimens appDimens,
  //     {bool isDownloading, String text}) {
  //   return isLoading
  //       ? Material(
  //           type: MaterialType.transparency,
  //           child: Container(
  //             height: double.infinity,
  //             width: double.infinity,
  //             color: Color(0x80ffffff),
  //             alignment: Alignment.center,
  //             child: Container(
  //               alignment: Alignment.center,
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(4),
  //                 border: Border.all(
  //                   color: AppColors.blackColor,
  //                 ),
  //                 color: Colors.white,
  //               ),
  //               height: width,
  //               width: width,
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 children: <Widget>[
  //                   Container(
  //                     padding:
  //                         EdgeInsets.symmetric(horizontal: appDimens.paddingw8),
  //                     child: Text(
  //                       text != null && text != ""
  //                           ? text
  //                           : isDownloading != null
  //                               ? isDownloading ? "Downloading" : "Uploading"
  //                               : "Uploading",
  //                       textAlign: TextAlign.center,
  //                       style: TextStyle(
  //                           fontSize: appDimens.text16,
  //                           color: AppColors.greyText),
  //                     ),
  //                   ),
  //                   Text(
  //                     (value.toString() + " %"),
  //                     textAlign: TextAlign.center,
  //                     style: TextStyle(
  //                         fontSize: appDimens.text24,
  //                         fontWeight: FontWeight.w700,
  //                         color: AppColors.blackColor),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         )
  //       : Container();
  // }

  // static Image imageLoaderImage(String url, String placeholder) {
  //   return url == null || url == ""
  //       ? Image.asset(placeholder)
  //       : Image.network(
  //           // url,
  //           (url.startsWith("http")) ? url : AppStrings.IMAGE_BASE_URL + url,
  //           fit: BoxFit.contain,
  //           loadingBuilder: (BuildContext context, Widget child,
  //               ImageChunkEvent loadingProgress) {
  //             if (loadingProgress == null) return child;
  //             return progress(context);
  //           },
  //         );
  // }

  // static bool isMobile(AppDimens appDimens) {
  //   return (appDimens.deviceType == DeviceType.ANDROIDPHONE ||
  //       appDimens.deviceType == DeviceType.IOSDEVICE);
  // }

  static String getStarFromRating(int rating) {
    return rating == 0 ? ('☆' * 5) : (rating >= 5 ? ('★' * 5) : (('★' * rating) + ('☆' * (5 - rating))));
  }

  static void fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static checkPermission({
    required void Function() onSucess,
    required Permission permission,
  }) async {
    PermissionStatus permissionStatus = await permission.status;
    switch (permissionStatus) {
      case PermissionStatus.granted:
        print('-------');
        print('Permission Granted');
        print('-------');
        onSucess();

        break;

      case PermissionStatus.denied:
        print('-------');
        print('Permission Denied');
        print('-------');

        await permission.request().then((value) {
          if (value == PermissionStatus.granted) {
            onSucess();
          }
        });
        break;

      case PermissionStatus.permanentlyDenied:
        print('--------');
        print('Permission Never Ask Again');
        print('--------');
        openAppSettings();
        break;

      // case 4 for Permission Unknown

      case PermissionStatus.limited:
        print('--------');
        print('Permission Unknown');
        print('--------');

        await permission.request().then((value) {
          if (value == PermissionStatus.granted) {
            onSucess();
          }
        });
        break;

      // case 5 for Permission Restricted

      case PermissionStatus.restricted:
        print('--------');
        print('Permission Restricted');
        print('--------');
        openAppSettings();
        break;

      // default open setting

      default:
        await permission.request().then((value) {
          if (value == PermissionStatus.granted) {
            onSucess();
          }
        });
    }
  }

  static String getMapUrl(String latitude, String longitude) {
    if (latitude == '' || longitude == '') {
      return '';
    }
    String width = "512";
    String height = "512";
    // print(AppStrings.mapBaseUrl +
    //     "?zoom=9&size=" +
    //     width +
    //     "x" +
    //     height +
    //     "&maptype=roadmap&markers=" +
    //     latitude +
    //     "," +
    //     longitude +
    //     "&key=" +
    //     AppStrings.mapAPIKEY);
    return AppStrings.staticMapBaseUrl +
        "?zoom=9&size=" +
        width +
        "x" +
        height +
        "&maptype=roadmap&markers=" +
        latitude +
        "," +
        longitude +
        "&key=" +
        AppStrings.mapAPIKEY;
  }
}
