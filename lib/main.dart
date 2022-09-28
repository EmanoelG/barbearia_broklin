import 'package:barbearia_adriano/source/model/agenda_model.dart';
import 'package:barbearia_adriano/source/splash_screnn/splash_screnn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AgendaServiceModel>(
          create: (context) => AgendaServiceModel(),
          // dispose: (context, bloc) => bloc.dispose(),
        ),
      ],
      child: MaterialApp(
        title: 'Barber Shop',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.brown,
            scaffoldBackgroundColor: Colors.white.withAlpha(190)),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // Inglês
          Locale('pt', 'BR'), // Português
          Locale.fromSubtags(
              languageCode: 'zh'), // Chinês *Veja os locais avançados abaixo *
          // ... outras localidades que o aplicativo suporta
        ],
        home: SplashScreen(),
      ),
    );
  }
}
