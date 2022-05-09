// ignore_for_file: unnecessary_raw_strings

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/formatter_utils.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:karkar_provider_app/constants/app_colors.dart';
import 'package:karkar_provider_app/constants/app_strings.dart';
import 'package:karkar_provider_app/constants/utility.dart';
import 'package:karkar_provider_app/design/widget/back_arrow_widget.dart';
import 'package:karkar_provider_app/design/widget/button.dart';
import 'package:karkar_provider_app/design/widget/text_field_widget.dart';
import 'package:karkar_provider_app/l10n/l10n.dart';
import 'package:karkar_provider_app/network/api_manager/api_manager.dart';
import 'package:karkar_provider_app/network/response/begin_checkout_response.dart';
import 'package:karkar_provider_app/network/response/common_response.dart';
import 'package:karkar_provider_app/network/response/setting_response.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AddCreditcard extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const AddCreditcard({
    required this.planId,
    required this.price,
    required this.offerDescription,
  });
  final String planId;
  final String price;

  final String offerDescription;

  @override
  _AddCreditcardState createState() => _AddCreditcardState();
}

class _AddCreditcardState extends State<AddCreditcard> {
  Size? size;
  TextEditingController cardnumber = TextEditingController();
  TextEditingController expirydatecontroller = TextEditingController();
  TextEditingController cvcController = TextEditingController();
  TextEditingController cardholdername = TextEditingController();
  FocusNode cardholdernamefn = FocusNode();
  FocusNode cardnumberfn = FocusNode();
  FocusNode expirydatefn = FocusNode();
  FocusNode cvcFn = FocusNode();
  String expirytext = '', nametext = '', numbertext = '', cvcText = '';
  bool isLoading = false;
  BeginCheckoutResponse? setupIntentData;

  CustomCreditCardExpirationDateFormatter creditCardExpirationDateFormatter = CustomCreditCardExpirationDateFormatter();
  // PaymentMethod _paymentMethod;
  // List<AppointmentData> cartDetails = [];

  MaskTextInputFormatter maskFormattercardnumber =
      MaskTextInputFormatter(mask: 'X### #### #### ####', filter: {'#': RegExp(r'[0-9]'), 'X': RegExp(r'[1-9]')});
  MaskTextInputFormatter maskFormatterdate = MaskTextInputFormatter(mask: 'XA/A###', filter: {
    '#': RegExp(r'[0-9]'),
    'X': RegExp(r'[0-1]'),
    'A': RegExp(r'[1-9]'),
  });
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.userbgcolor,
          appBar: AppBar(
            backgroundColor: AppColors.userbgcolor,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: const Text(
              'Pay',
              style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: BackArrowWidget(
              onTap: () {
                Navigator.pop(context);
              },
            ),
            elevation: 0,
          ),
          body: _body(),
        ),
        if (isLoading) Utility.progress(context) else Container()
      ],
    );
  }

  SafeArea _body() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width, minHeight: MediaQuery.of(context).size.height),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[_upperField()],
          ),
        ),
      ),
    );
  }

  // ignore: always_declare_return_types
  _upperField() {
    return Container(
      margin: EdgeInsets.only(
        left: MediaQuery.of(context).size.height * 0.019,
        right: MediaQuery.of(context).size.height * 0.012,
      ),
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: Container(
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.gradiant1,
                        AppColors.gradiant2,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 5,
                        color: Colors.white,
                        offset: Offset(2, 2),
                      )
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        nametext == '' ? AppLocalizations.of(context).cardHolderName : nametext,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: nametext == '' ? Colors.white60 : Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        numbertext == '' ? 'XXXX XXXX XXXX XXXX' : numbertext,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: numbertext == '' ? Colors.white60 : Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: <Widget>[
                                          const SizedBox(height: 10),
                                          Text(
                                            expirytext == '' ? 'MM/YYYY' : expirytext,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: expirytext == '' ? Colors.white60 : Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                          const SizedBox(
                                            width: 60,
                                          ),
                                          Text(
                                            cvcText == '' ? AppLocalizations.of(context).cvc : cvcText,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: expirytext == '' ? Colors.white60 : Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          TextFieldWidget(
            controller: cardholdername,
            focusNode: cardholdernamefn,
            label: AppLocalizations.of(context).cardHolderName,
            hintText: '',
            keyboardType: TextInputType.text,
            maxLines: 1,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            onChanged: (val) {
              if (mounted) {
                setState(() {
                  nametext = val.toString();
                });
              }
            },
            onFieldSubmitted: (va) {
              Utility.fieldFocusChange(context, cardholdernamefn, cardnumberfn);
            },
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(
            height: 10,
          ),
          TextFieldWidget(
            controller: cardnumber,
            focusNode: cardnumberfn,
            hintText: '',
            label: AppLocalizations.of(context).cardNumber,
            inputFormatters: [maskFormattercardnumber],
            keyboardType: TextInputType.number,
            maxLines: 1,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            onFieldSubmitted: (a) {
              Utility.fieldFocusChange(context, cardnumberfn, expirydatefn);
            },
            onChanged: (value) {
              if (mounted) {
                setState(() {
                  numbertext = value.toString();
                });
              }
            },
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(
            height: 10,
          ),
          TextFieldWidget(
            controller: expirydatecontroller,
            focusNode: expirydatefn,
            inputFormatters: [creditCardExpirationDateFormatter],
            hintText: '',
            label: AppLocalizations.of(context).expiryDate,
            keyboardType: TextInputType.number,
            maxLines: 1,
            textInputAction: TextInputAction.done,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            onChanged: (value) {
              if (mounted) {
                setState(() {
                  expirytext = value.toString();
                });
              }
            },
          ),
          const SizedBox(
            height: 10,
          ),
          TextFieldWidget(
            controller: cvcController,
            focusNode: cvcFn,
            hintText: '',
            label: AppLocalizations.of(context).cvc,
            inputFormatters: [
              LengthLimitingTextInputFormatter(3),
            ],
            onChanged: (value) {
              if (mounted) {
                setState(() {
                  cvcText = value.toString();
                });
              }
            },
            padding: const EdgeInsets.symmetric(horizontal: 16),
            keyboardType: TextInputType.number,
            maxLines: 1,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(
            height: 16,
          ),
          CommonButton(
            text: AppLocalizations.of(context).pay,
            onpressed: () {
              payTap();
            },
          ),
        ],
      ),
    );
  }

  // ignore: always_declare_return_types, type_annotate_public_apis
  payTap() {
    if (numbertext.trim() == '') {
      Utility.showToast(msg: AppLocalizations.of(context).enterCardNumber);
    } else if (numbertext.trim().length < 16) {
      Utility.showToast(msg: AppLocalizations.of(context).invalidCardNumber);
    } else if (expirytext.split('/').first.trim() == '' || expirytext.split('/').last.trim() == '') {
      Utility.showToast(msg: AppLocalizations.of(context).enterExpiryDate);
    } else if (cvcText.trim() == '') {
      Utility.showToast(msg: AppLocalizations.of(context).enterCvc);
    } else if (cvcText.trim().length < 3) {
      Utility.showToast(msg: AppLocalizations.of(context).invalidCvc);
    } else {
      getStripeKey();
    }
  }

  getStripeKey() async {
    if (await ApiManager.checkInternet()) {
      _changeLoadingState(true);
      var request = <String, dynamic>{};
      request['type'] = "STRIPE";
      SettingResponse settingResponse = SettingResponse.fromJson(
        await ApiManager(context).getCall(
          AppStrings.setting,
          request,
        ),
      );

      if (settingResponse.status == '1' && settingResponse.data != null && settingResponse.data!.isNotEmpty) {
        createPayment(
          numbertext,
          expirytext.split('/').first,
          cvcText,
          expirytext.split('/').last,
          context,
          settingResponse.data!.first.value ?? '',
        );
      } else {
        Utility.showToast(msg: settingResponse.message);
      }
      _changeLoadingState(false);
    } else {
      Utility.showToast(msg: AppLocalizations.of(context).noInternet);
    }
  }

  // ignore: always_declare_return_types, type_annotate_public_apis
  createPayment(String cardNo, String month, String cvc, String year, BuildContext context, String stripeKey) async {
    try {
      _changeLoadingState(true);
      Stripe.publishableKey = stripeKey;
      Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
      Stripe.urlScheme = 'flutterstripe';
      await Stripe.instance.applySettings();
      await callSetupIntent();

      final _card = CardDetails(
        number: cardNo,
        expirationMonth: int.parse(month),
        expirationYear: int.parse(year),
        cvc: cvc,
      );

      await Stripe.instance.dangerouslyUpdateCardDetails(_card);
      PaymentMethod? paymentMethod;
      await Stripe.instance
          .createPaymentMethod(
        const PaymentMethodParams.card(),
      )
          .then((value) {
        paymentMethod = value;
      }).catchError((error) {
        _changeLoadingState(false);
        Utility.showToast(msg: error?.error?.message ?? '');
      });
      if (setupIntentData?.data != null && paymentMethod?.id != null) {
        await createOffer(paymentMethod!.id);
      }
    } catch (e, s) {
      _changeLoadingState(false);
      print('ERROR________--------');
      print(e.toString());
      print(s.toString());
    }
  }

  Future<void> createOffer(String paymentMethodId) async {
    try {
      _changeLoadingState(true);

      var request = <String, dynamic>{};
      request['plan_id'] = widget.planId;
      request['amount'] = widget.price;
      request['payment_method_id'] = paymentMethodId;
      request['description'] = widget.offerDescription;
      request['client_secret'] = setupIntentData?.data ?? '';

      CommonResponse commonResponse = CommonResponse.fromJson(
        await ApiManager(context).postCall(
          AppStrings.createOffer,
          request,
        ),
      );

      Utility.showToast(msg: commonResponse.message);
      if (commonResponse.status == '1') {
        Navigator.pop(context, 'refresh');
      }
    } catch (e) {
      setError('error in setupIntent : $e');
      _changeLoadingState(false);
    }
  }

  Future<void> callSetupIntent() async {
    try {
      _changeLoadingState(true);

      var request = <String, dynamic>{};
      request['plan_id'] = widget.planId;
      request['amount'] = widget.price;
      BeginCheckoutResponse beginCheckoutResponse = BeginCheckoutResponse.fromJson(
        await ApiManager(context).postCall(
          AppStrings.beginCheckOut,
          request,
        ),
      );

      if (beginCheckoutResponse.status == '1' && beginCheckoutResponse.data != null) {
        setupIntentData = beginCheckoutResponse;
        _notify();
      } else {
        _changeLoadingState(false);
        Utility.showToast(msg: beginCheckoutResponse.message ?? '');
      }
    } catch (e) {
      setError('error in setupIntent : $e');
      _changeLoadingState(false);
    }
  }

  // ignore: always_declare_return_types
  _notify() {
    if (mounted) setState(() {});
  }

  void setError(dynamic error) {
    // ignore: avoid_print
    print(error.toString());
  }

  // ignore: always_declare_return_types
  _changeLoadingState(bool _isLoading) {
    isLoading = _isLoading;
    _notify();
  }
}

class CustomCreditCardExpirationDateFormatter extends MaskedInputFormatter {
  CustomCreditCardExpirationDateFormatter() : super('00/0000');

  @override
  FormattedValue applyMask(String text) {
    var fv = super.applyMask(text);
    var result = fv.toString();
    var numericString = toNumericString(result);
    var numAddedLeadingSymbols = 0;
    String? ammendedMonth;
    if (numericString.isNotEmpty) {
      var allDigits = numericString.split('');
      var stringBuffer = StringBuffer();
      var firstDigit = int.parse(allDigits[0]);

      if (firstDigit > 1) {
        stringBuffer.write('0');
        stringBuffer.write(firstDigit);
        ammendedMonth = stringBuffer.toString();
        numAddedLeadingSymbols = 1;
      } else if (firstDigit == 1) {
        if (allDigits.length > 1) {
          stringBuffer.write(firstDigit);
          var secondDigit = int.parse(allDigits[1]);
          if (secondDigit > 2) {
            stringBuffer.write(2);
          } else {
            stringBuffer.write(secondDigit);
          }
          ammendedMonth = stringBuffer.toString();
        }
      }
    }
    if (ammendedMonth != null) {
      if (result.length < ammendedMonth.length) {
        result = ammendedMonth;
      } else {
        var sub = result.substring(2, result.length);
        result = '$ammendedMonth$sub';
      }
    }
    fv = super.applyMask(result);

    /// a little hack to be able to move caret by one
    /// symbol to the right if a leading zero was added automatically
    for (var i = 0; i < numAddedLeadingSymbols; i++) {
      fv.increaseNumberOfLeadingSymbols();
    }
    return fv;
  }
}
