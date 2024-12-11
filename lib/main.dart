import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ui/screens/authentication_screen.dart';
import 'ui/screens/onboarding_screen.dart';
import 'ui/screens/splash_screen.dart';

import 'config/config.dart';
import 'package:flutter/material.dart' as flutter;

void main() async {
  flutter.WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Config.loadConfig();
  
  final account = Config.getAccount();
  final databases = Config.getDatabases();
  final functions = Config.getFunctions();

  runApp(
    EasyLocalization(
      supportedLocales: [flutter.Locale('en'), flutter.Locale('fr'), flutter.Locale('ar'), flutter.Locale('es')],
      path: 'assets/translations',
      fallbackLocale: flutter.Locale('en'),
      child: MyApp(account: account, databases: databases, functions: functions),
    ),
  );
}

class MyApp extends flutter.StatelessWidget {
  final Account account;
  final Databases databases;
  final Functions functions;

  const MyApp({
    Key? key,
    required this.account,
    required this.databases,
    required this.functions,
  }) : super(key: key);

  @override
  flutter.Widget build(flutter.BuildContext context) {
    return flutter.MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'app_name'.tr(),
      theme: Config.themeData,
      home: SplashScreen(
        account: account,
        databases: databases,
        functions: functions,
      ),
    );
  }
}

