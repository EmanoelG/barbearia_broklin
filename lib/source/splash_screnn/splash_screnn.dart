import 'package:flutter/material.dart';

import '../home/home_main_page.dart';

import '../utils/push_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // criar a regra de firebase etc.
    super.initState();
    Future.delayed(
      const Duration(seconds: 5),
    ).then(
      (value) => push(context, Calendar()),
    );
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
