import 'package:flutter/material.dart';
// import '/screens/home_screen.dart';
import '/screens/first_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3)).then((value){
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LandingPage(),
        ), 
        (route) => false);
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(  
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, 
          crossAxisAlignment: CrossAxisAlignment.center, 
          children: [
            Image.asset(
              'assets/images/curativo_splash.png',
              width: 200,  
              height: 200, 
              fit: BoxFit.contain, 
            ),
          ],
        ),
      ),
    );
  }
}
