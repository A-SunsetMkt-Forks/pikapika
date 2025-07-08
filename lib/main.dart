import 'package:event/event.dart';
import 'package:flutter/material.dart';
import 'package:pikapika/screens/InitScreen.dart';
import 'package:pikapika/basic/Navigator.dart';
import 'package:pikapika/screens/components/MouseAndTouchScrollBehavior.dart';

import 'basic/config/Themes.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';

import 'basic/define.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
        supportedLocales: supportedLocales,
        path: translationsPath,
        fallbackLocale: fallbackLocale,
        child: const PikapikaApp()
    ),
  );
}

class PikapikaApp extends StatefulWidget {
  const PikapikaApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PikapikaAppState();
}

class _PikapikaAppState extends State<PikapikaApp> {
  @override
  void initState() {
    themeEvent.subscribe(_onChangeTheme);
    super.initState();
  }

  @override
  void dispose() {
    themeEvent.unsubscribe(_onChangeTheme);
    super.dispose();
  }

  void _onChangeTheme(EventArgs? args) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: mouseAndTouchScrollBehavior,
      theme: currentLightThemeData(),
      darkTheme: currentDarkThemeData(),
      navigatorObservers: [navigatorObserver, routeObserver],
      home: const InitScreen(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
