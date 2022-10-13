import 'package:barbearia_adriano/source/model/agenda.dart';
import 'package:flutter/material.dart';

import '../home/home_main_page.dart';

import '../home/main_page.dart';
import '../service/sql/db_helper.dart';
import '../utils/push_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // Future.delayed(Duration(seconds: 15), () {
    //     push(context, LoginPage());
    //   });

    //Inicializa banco de dados.
    Future futureA = DatabaseHelper.getInstance().db;
    Future futureB = Future.delayed(Duration(seconds: 3));
    // Verifica se o usuario manteve logado.

    Future.wait([futureA, futureB]).then((List values) {
      push(
        context,
        MainPage(),
        // Calendar(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(38, 0, 0, 0),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              Container(
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: Image.asset('Barbe_Shop.png'),
              ),
              Container(
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 243, 243, 243),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
