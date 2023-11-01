import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:travel_care/pages/login.dart';
import 'package:travel_care/pages/notification.dart';
import 'package:travel_care/pages/profile.dart';
import 'package:travel_care/pages/travel.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const keyApplicationId = 'PCI6KioZu7Bn19Z9Ihm04T5cObNRELhDtYsR0EM4';
  const keyClientKey = '2U9r2HUlPKG3jDxOw0lMyuopIxSG6dys7IZxZU3y';
  const keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, debug: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginPage(),
      routes: {
        '/notification': (context) => const NotificationPage(),
        '/profile': (context) => const ProfilePage(),
        '/travel': (context) => const TravelPage(),
      },
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [Locale('pt', 'BR')],
    );
  }
}
