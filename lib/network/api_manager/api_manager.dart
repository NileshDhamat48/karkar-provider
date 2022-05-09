import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:karkar_provider_app/constants/all_imports.dart';
import 'package:karkar_provider_app/constants/app_logs.dart';
import 'package:karkar_provider_app/constants/app_strings.dart';
import 'package:karkar_provider_app/main.dart';
import 'package:karkar_provider_app/network/response/common_response.dart';
import 'package:karkar_provider_app/network/response/user_response.dart';

class ApiManager {
  BuildContext? context;
  ApiManager(this.context);

  ApiManager.empty();

  static Future<bool> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }

// --- Post New Call ---

  Future<Map<String, dynamic>> postCallNew(
    String url,
    Map request, {
    Map<String, dynamic>? requestParams,
  }) async {
    try {
      var uri = Uri.parse(url);
      if (requestParams != null) {
        uri = uri.replace(queryParameters: requestParams);
      }
      Map<String, String> headers;
      headers = await getHeaders();
      AppLogs.debugging(headers);
      AppLogs.debugging(uri);
      AppLogs.debugging(request);
      http.Response response = await http.post(uri, body: request, headers: headers);
      if (response.statusCode == 401) {
        logoutUnauthenticated();
        CommonResponse commonResponse = CommonResponse(message: "Unauthenticated.", status: "0");
        return await json.decode(json.encode(commonResponse.toJson()));
      } else if (response.statusCode == 422) {
        CommonResponse commonResponse = CommonResponse.fromJson(json.decode(response.body));
        log(commonResponse.status);
        log(commonResponse.message);
        if (commonResponse.status == "0") {
          String message = commonResponse.message;

          Utility.showToast(msg: message);
        }
        return await json.decode(response.body);
      } else {
        AppLogs.debugging("${response.statusCode}");
        AppLogs.debugging(response.body);

        final data = await json.decode(response.body);
        log(data);
        return data;
      }
    } catch (e) {
      debugPrint("crashed " + e.toString(), wrapWidth: 1024);
      CommonResponse commonResponse = CommonResponse(message: e.toString(), status: "0");
      return await json.decode(json.encode(commonResponse.toJson()));
    }
  }

// --- Post Call ---
  Future<Map<String, dynamic>> postCall(
    String url,
    Map request, {
    Map<String, dynamic>? requestParams,
  }) async {
    try {
      var uri = Uri.parse(url);

      if (requestParams != null) {
        uri = uri.replace(queryParameters: requestParams);
      }

      Map<String, String> headers;
      headers = await getHeaders();
      AppLogs.debugging(headers);
      AppLogs.debugging(uri);
      AppLogs.debugging(request);

      http.Response response = await http.post(uri, body: request, headers: headers);
      AppLogs.debugging("${response.statusCode}");
      AppLogs.debugging(response.body);

      if (response.statusCode == 401) {
        logoutUnauthenticated();
        CommonResponse commonResponse = CommonResponse(message: "Unauthenticated.", status: "0");
        return await json.decode(json.encode(commonResponse.toJson()));
      } else if (response.statusCode == 422) {
        CommonResponse commonResponse = CommonResponse.fromJson(json.decode(response.body));

        if (commonResponse.status == "0") {
          String message = commonResponse.message;

          Utility.showToast(msg: message);
        }
        return await json.decode(response.body);
      } else {
        final data = await json.decode(response.body);
        return data;
      }
    } catch (e) {
      debugPrint("Crashed " + e.toString(), wrapWidth: 1024);
      CommonResponse commonResponse = CommonResponse(
        message: e.toString(),
        status: "0",
      );
      return await jsonDecode(json.encode(commonResponse.toJson()));
    }
  }

  // --- delete call ---

  deleteCall(
    String url,
  ) async {
    try {
      Map<String, String> headers;
      headers = await getHeaders();
      AppLogs.debugging(headers);
      AppLogs.debugging(url);
      http.Response response = await http.delete(Uri.parse(url), headers: headers);
      if (response.statusCode == 401) {
        logoutUnauthenticated();
        CommonResponse commonResponse = CommonResponse(message: "Unauthenticated.", status: "0");
        return await json.decode(json.encode(commonResponse.toJson()));
      } else {
        AppLogs.debugging("${response.statusCode}");
        AppLogs.debugging(response.body);
        final data = await json.decode(response.body);
        log(data.toString());
        return data;
      }
    } catch (e, s) {
      AppLogs.debugging("crashed ::::$e ::::::$s");

      CommonResponse commonResponse = CommonResponse(message: e.toString(), status: "0");
      return await json.decode(json.encode(commonResponse.toJson()));
    }
  }

  // --- GEt Call ---
  Future<Map<String, dynamic>> getCall(
    String url, [
    Map<String, dynamic>? request,
  ]) async {
    try {
      Map<String, String> headers;

      headers = await getHeaders();

      var uri = Uri.parse(url);
      uri = uri.replace(queryParameters: request ?? {});

      AppLogs.debugging(uri);
      AppLogs.debugging(headers);

      http.Response response = await http.get(uri, headers: headers);

      AppLogs.debugging("${response.statusCode}");
      AppLogs.debugging(response.body);
      if (response.statusCode == 401) {
        logoutUnauthenticated();
        CommonResponse commonResponse = CommonResponse(message: "Unauthenticated.", status: "0");
        return await json.decode(json.encode(commonResponse.toJson()));
      } else {
        final data = await json.decode(response.body);
        return data;
      }
    } catch (e, s) {
      AppLogs.debugging("crashed ::::$e ::::::$s");

      CommonResponse commonResponse = CommonResponse(message: e.toString(), status: "0");
      return await json.decode(commonResponse.toJson().toString());
    }
  }

  // --- MultiPart ---
  Future<Map<String, dynamic>> multipartRequest({
    required String url,
    String method = 'POST',
    Map<String, String> request = const {},
    required List<MapEntry<String, File>> files,
  }) async {
    try {
      // log(url.toString());
      // log(method.toString());
      // log(request.toString());
      // log(files.toString());

      final headers = await getHeaders();
      // log(headers.toString());
      final uri = Uri.parse(url);

      AppLogs.debugging(headers);
      AppLogs.debugging(uri);
      AppLogs.debugging(request);
      AppLogs.debugging(method);
      AppLogs.debugging(files);

      var multipartRequest = http.MultipartRequest(
        method,
        uri,
      );

      multipartRequest.headers.addAll(headers);

      if (files.isNotEmpty) {
        for (var fileData in files) {
          multipartRequest.files.add(
            await http.MultipartFile.fromPath(
              fileData.key,
              fileData.value.path,
            ),
          );
        }
      }

      multipartRequest.fields.addAll(request);

      final multiPartResponse = await multipartRequest.send();
      final response = await http.Response.fromStream(multiPartResponse);

      AppLogs.debugging('responseData: ${response.body}');
      AppLogs.debugging('responseData: ${response.statusCode}');
      if (response.statusCode == 401) {
        logoutUnauthenticated();
        CommonResponse commonResponse = CommonResponse(message: "Unauthenticated.", status: "0");
        return await json.decode(json.encode(commonResponse.toJson()));
      } else if (response.statusCode != 200) {
        CommonResponse commonResponse = CommonResponse.fromJson(json.decode(response.body));
        log(commonResponse.status);
        log(commonResponse.message);
        if (commonResponse.status == "0") {
          String message = commonResponse.message;

          Utility.showToast(msg: message);
        }
        return await json.decode(response.body);
      } else {
        AppLogs.debugging("${response.statusCode}");
        AppLogs.debugging(response.body);

        final data = await json.decode(response.body);
        AppLogs.debugging('responseData: $data');
        return data;
      }
    } catch (e) {
      debugPrint("crashed " + e.toString(), wrapWidth: 1024);
      CommonResponse commonResponse = CommonResponse(message: e.toString(), status: "0");
      return await json.decode(json.encode(commonResponse.toJson()));
    }
  }

// --- Headers ---
  Future<Map<String, String>> getHeaders() async {
    Map<String, String> headers = <String, String>{};

    Locale lag = await Utility.getLangauge();

    try {
      if (sharedPreferences.getString(AppStrings.userPrefKey) == null) {
        headers['Accept'] = 'application/json';
        headers['X-App-Locale'] = lag.languageCode;
      } else {
        UserResponse user =
            UserResponse.fromJson(jsonDecode(sharedPreferences.getString(AppStrings.userPrefKey) ?? ''));

        if (user.token != null) {
          headers['Authorization'] = 'Bearer ' + user.token!.trim();
        }
        headers['Accept'] = 'application/json';
        headers['X-App-Locale'] = lag.languageCode;
      }
    } catch (e) {
      log(e.toString());
    }
    return headers;
  }

  logoutUnauthenticated() {
    sharedPreferences.clear();
    navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
        (route) => false);
  }
}
