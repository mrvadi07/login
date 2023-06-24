import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login/send_otp.dart';
import 'package:lottie/lottie.dart';

class Spalsh extends StatefulWidget {
  const Spalsh({Key? key}) : super(key: key);

  @override
  State<Spalsh> createState() => _SpalshState();
}

class _SpalshState extends State<Spalsh> {
  @override
  void initState() {
    Timer timer = Timer(
      Duration(seconds: 2),
      () => Get.to(SendOtp()),
    );
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(
              "assets/images/spalsh.jpeg",
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 500,
            left: 50,
            right: 50,
            child: Column(
              children: [
                Container(
                  height: 60,
                  width: 350,
                  decoration: BoxDecoration(
                    color: Colors.pink.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                      child: Text(
                    'Welcome',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                ),
                SizedBox(height: 20),
                Text(
                  'Go to register',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
