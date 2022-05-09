import 'package:karkar_provider_app/constants/all_imports.dart';
import 'package:karkar_provider_app/design/widget/button.dart';
import 'package:karkar_provider_app/l10n/l10n.dart';
import 'package:karkar_provider_app/network/models/language_state.dart';

class SelectLanguage extends StatefulWidget {
  const SelectLanguage({Key? key}) : super(key: key);

  @override
  _SelectLanguageState createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  String selectSortRadioTile = '';
  Locale? locale;

  @override
  void initState() {
    super.initState();
    getLanguage();
  }

  Future getLanguage() async {
    locale = await Utility.getLangauge();
    selectSortRadioTile = locale!.languageCode;
    _notify();
  }

  _notify() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldbgcolor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: AppColors.appbarBgColor,
        leading: BackArrowWidget(
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          AppLocalizations.of(context).changeLanguage,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          Theme(
            data: ThemeData(unselectedWidgetColor: AppColors.whiteColor),
            child: Container(
              color: AppColors.languageBgcolor,
              child: RadioListTile(
                activeColor: AppColors.whiteColor,
                title: Text(
                  AppLocalizations.of(context).english,
                  style: const TextStyle(
                      fontSize: 18, color: AppColors.whiteColor),
                ),
                value: "en",
                groupValue: selectSortRadioTile,
                onChanged: (newValue) {
                  selectSortRadioTile = newValue.toString();

                  _notify();
                },
              ),
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Theme(
            data: ThemeData(unselectedWidgetColor: AppColors.whiteColor),
            child: Container(
              color: AppColors.languageBgcolor,
              child: RadioListTile(
                activeColor: AppColors.whiteColor,
                tileColor: AppColors.whiteColor,
                title: Text(
                  AppLocalizations.of(context).italian,
                  style: const TextStyle(
                      fontSize: 18, color: AppColors.whiteColor),
                ),
                value: "it",
                groupValue: selectSortRadioTile,
                onChanged: (newValue) {
                  selectSortRadioTile = newValue.toString();

                  _notify();
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CommonButton(
        text: AppLocalizations.of(context).save,
        onpressed: () {
          Utility.setLangauage(Locale(selectSortRadioTile));
          LanguageState.of(context).setLanuage(Locale(selectSortRadioTile, ''));
          Navigator.pop(context);
          _notify();
          Utility.showToast(msg: AppLocalizations.of(context).languageUpdated);
        },
      ),
    );
  }
}
