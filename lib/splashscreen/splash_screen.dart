import 'dart:async';
import 'package:flutter/material.dart';
import 'package:road_helper/main_screen/services_detail.dart';

class SplashScreen extends StatefulWidget {
   const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 50),
          () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ServicesDetail()),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepOrange,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                    'images/logoroadhelper.png',
                  fit:BoxFit.cover,

                ),
              ),
            ],
          ),
        ),
       );
  }
}
