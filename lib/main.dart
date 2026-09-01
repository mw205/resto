import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/app.dart';
import 'core/di/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Set preferred screen orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize DI
  await initServiceLocator();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('ar', 'EG'),
        Locale('ar'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar', 'EG'),
      startLocale: const Locale('ar', 'EG'),
      useOnlyLangCode: true,
      child: const RestoApp(),
    ),
  );
}
