import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:karkar_provider_app/constants/app_colors.dart';
import 'package:karkar_provider_app/constants/app_strings.dart';
import 'package:karkar_provider_app/constants/utility.dart';
import 'package:karkar_provider_app/design/widget/back_arrow_widget.dart';
import 'package:karkar_provider_app/l10n/l10n.dart';
import 'package:karkar_provider_app/network/api_manager/api_manager.dart';
import 'package:karkar_provider_app/network/models/terms_condition_model.dart';
import 'package:karkar_provider_app/network/response/terms_condition_response.dart';
import 'package:flutter_html/style.dart';

class TearmAndConditionPage extends StatefulWidget {
  const TearmAndConditionPage({Key? key}) : super(key: key);

  @override
  State<TearmAndConditionPage> createState() => _TearmAndConditionPageState();
}

class _TearmAndConditionPageState extends State<TearmAndConditionPage> {
  List<TearmConditionModel> tearmandconditionlist = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getTearm();
  }

  getTearm() async {
    if (await ApiManager.checkInternet()) {
      _changeLoadingState(true);
      var request = <String, dynamic>{};
      request['type'] = 'TERM';

      TermsConditionResponse termsConditionResponse =
          TermsConditionResponse.fromJson(await ApiManager(context)
              .getCall(AppStrings.termsandconditionlist, request));
      // if (termsConditionResponse.status == "1" &&
      if (termsConditionResponse.status == "1" &&
          termsConditionResponse.data != null &&
          termsConditionResponse.data!.isNotEmpty) {
        tearmandconditionlist.addAll(termsConditionResponse.data!);
      }
      _changeLoadingState(false);
    } else {
      Utility.showToast(msg: AppLocalizations.of(context).noInternet);
    }
  }

  _changeLoadingState(bool _isLoading) {
    isLoading = _isLoading;
    nofity();
  }

  nofity() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appbarBgColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: AppColors.appbarBgColor,
        leading: BackArrowWidget(
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          AppLocalizations.of(context).termsCondition,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: tearmandconditionlist.isNotEmpty
                ? Html(
                    shrinkWrap: true,
                    data: tearmandconditionlist[0].value ?? "",
                    style: {
                        'body': Style(
                          maxLines: 8,
                          textOverflow: TextOverflow.ellipsis,
                          color: AppColors.whiteColor,
                          fontSize: const FontSize(14),
                          fontWeight: FontWeight.normal,
                          padding: EdgeInsets.zero,
                        ),
                      })
                : const SizedBox(),
          ),
          isLoading ? Utility.progress(context) : const SizedBox()
        ],
      ),
    );
  }
}
