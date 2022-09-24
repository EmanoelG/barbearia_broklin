import 'package:barbearia_adriano/source/home/home_main_page.dart';
import 'package:barbearia_adriano/source/splash_screnn/splash_screnn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''), // Inglês
        Locale('pt', 'BR'), // Português
        Locale.fromSubtags(
            languageCode: 'zh'), // Chinês *Veja os locais avançados abaixo *
        // ... outras localidades que o aplicativo suporta
      ],
      home: SplashScreen(),
    );
  }
}
