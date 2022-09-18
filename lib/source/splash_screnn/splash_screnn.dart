import 'package:flutter/material.dart';

import '../model/home_page.dart';
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
      (value) => push(context, const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 5, 5, 5),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              SizedBox(
                // padding: EdgeInsets.only(top: 115, bottom: 0),
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: Image.asset('Barbe_Shop.png'),
              ),
              Container(
                color: const Color.fromARGB(32, 75, 75, 75),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
