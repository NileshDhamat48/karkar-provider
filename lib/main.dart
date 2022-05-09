import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:karkar_provider_app/constants/all_imports.dart';
import 'package:karkar_provider_app/design/page/splash_page.dart';
import 'package:karkar_provider_app/l10n/l10n.dart';
import 'package:karkar_provider_app/network/firebase_messaging_services.dart';
import 'package:karkar_provider_app/network/models/language_state.dart';
import 'package:karkar_provider_app/network/models/user_data.dart';
import 'package:karkar_provider_app/network/response/user_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPreferences;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  await FirebaseMessagingService.initializeMain();
  await FirebaseMessagingService().initialize();
  await dotenv.load();
  runApp(
    DevicePreview(
      enabled: kDebugMode,
      builder: (context) => const MyApp(),
    ),
  );
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  UserData? user;
  UserResponse? userResponse;
  FocusNode fn = FocusNode();

  @override
  void initState() {
    super.initState();

    getUser();
  }

  Future getUser() async {
    userResponse = await Utility.getUserPref();
    if (userResponse != null) {
      _locale = await Utility.getLangauge();
      if (_locale?.languageCode == 'it') {
        _locale = AppLocalizations.supportedLocales[1];
      } else {
        _locale = AppLocalizations.supportedLocales[0];
      }
    } else {
      _locale = AppLocalizations.supportedLocales[1];
    }
    _notify();
  }

  _notify() {
    if (mounted) setState(() {});
  }

  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LanguageState(
      locale: _locale ?? AppLocalizations.supportedLocales[1],
      setLanuage: setLocale,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(fn);
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          locale: _locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
            Locale('it', ''), // Spanish, no country code
          ],

          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const SplashPage(),
          // home: const SelectLanguage(),
        ),
      ),
    );
  }
}
