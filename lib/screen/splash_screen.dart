import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/main');
    });

    return Scaffold(
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/icon.png', width: 300, height: 300,),
          SizedBox(height: 16),
          SizedBox(width: 200, height: 100, child: Shimmer.fromColors(child: Text(
            'Archive Idea', textAlign: TextAlign.center, style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ), baseColor: Colors.white54, highlightColor: Colors.blueAccent),),
        ],
      )),
    );
  }
}
