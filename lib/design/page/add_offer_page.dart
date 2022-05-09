import 'package:karkar_provider_app/constants/all_imports.dart';
import 'package:karkar_provider_app/constants/app_strings.dart';
import 'package:karkar_provider_app/design/page/add_credit_card_screen.dart';
import 'package:karkar_provider_app/design/widget/text_field_widget.dart';
import 'package:karkar_provider_app/l10n/l10n.dart';
import 'package:karkar_provider_app/network/api_manager/api_manager.dart';
import 'package:karkar_provider_app/network/models/offer_plan_model.dart';
import 'package:karkar_provider_app/network/response/offer_plan_response.dart';

class AddOfferPage extends StatefulWidget {
  const AddOfferPage({Key? key}) : super(key: key);

  @override
  State<AddOfferPage> createState() => AddOfferPageState();
}

class AddOfferPageState extends State<AddOfferPage> {
  bool isLoading = false;
  List<OfferPlan> offerPlan = [];

  @override
  void initState() {
    super.initState();
    getpOffersPlan();
  }

  getpOffersPlan() async {
    if (await ApiManager.checkInternet()) {
      _changeLoadingState(true);

      var request = <String, dynamic>{};

      OfferPlanResponse offerPlanResponse = OfferPlanResponse.fromJson(
        await ApiManager(context).getCall(
          AppStrings.offerPlan,
          request,
        ),
      );
      if (offerPlanResponse.status == "1" && offerPlanResponse.data != null && offerPlanResponse.data!.isNotEmpty) {
        offerPlan.addAll(offerPlanResponse.data!);
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

  @override
  Widget build(BuildContext context) {
    TextEditingController offercontroller = TextEditingController();
    FocusNode offerFN = FocusNode();
    return Scaffold(
      backgroundColor: AppColors.scaffoldbgcolor,
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
          AppLocalizations.of(context).addOffer,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).describeTheOffer,
                    style: TextStyle(color: AppColors.greyText, fontSize: 16),
                  ),
                  TextFieldWidget(
                    hintText: '',
                    label: '',
                    controller: offercontroller,
                    keyboardType: TextInputType.text,
                    minLines: 1,
                    maxLines: 8,
                    focusNode: offerFN,
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(
                    height: 180,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: Text(
                      AppLocalizations.of(context).publishFor,
                      style: TextStyle(color: AppColors.greyText, fontSize: 16),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ...List.generate(
                    offerPlan.length,
                    (index) {
                      return CommonButton(
                        text: offerPlan[index].title ?? '',
                        onpressed: () async {
                          if (offercontroller.text.trim() == '') {
                            Utility.showToast(msg: AppLocalizations.of(context).pleaseDescribeTheOffer);
                          } else {
                            final refresh = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddCreditcard(
                                  offerDescription: offercontroller.text.trim(),
                                  planId: offerPlan[index].id.toString(),
                                  price: offerPlan[index].price.toString(),
                                ),
                              ),
                            );
                            if (refresh != null) {
                              Navigator.pop(context, 'refresh');
                            }
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          if (isLoading) Utility.progress(context),
        ],
      ),
    );
  }
}
