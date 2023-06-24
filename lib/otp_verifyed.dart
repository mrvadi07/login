import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:login/homepage.dart';
import 'package:pinput/pinput.dart';

import 'email_with_register.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen(
      {Key? key,
      required this.id,
      required this.mobile,
      this.token,
      this.resendingToken})
      : super(key: key);

  final String id;
  final token;
  final mobile;
  final resendingToken;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otpController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  String? otpCode;
  int second = 15;
  bool isResend = false;
  void start() {
    Timer timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
      second--;
      if (second == 0) {
        timer.cancel();
        setState(() {});
        second = 15;
        isResend = true;
      }
    });
  }

  @override
  void initState() {
    start();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 25,
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(Icons.arrow_back),
                  ),
                ),
                Container(
                  width: 200,
                  height: 200,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.purple.shade50,
                      image: DecorationImage(
                        image:
                            AssetImage('assets/images/poly-3295856__340.jpg'),
                        fit: BoxFit.cover,
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Verification",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Enter the OTP send to your phone number",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black38,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(widget.mobile),
                const SizedBox(
                  height: 20,
                ),
                Pinput(
                  controller: otpController,
                  length: 6,
                  showCursor: true,
                  defaultPinTheme: PinTheme(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(color: Colors.purple.shade200, width: 1.5),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onSubmitted: (value) {
                    setState(() {
                      otpCode = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                isResend
                    ? ElevatedButton(
                        onPressed: () async {
                          await auth.verifyPhoneNumber(
                            phoneNumber: '+91 ${widget.mobile}',
                            verificationCompleted: (phoneAuthCredential) {
                              print('DONE');
                            },
                            verificationFailed: (error) {
                              print('FAILED');
                            },
                            codeSent: (verificationId, forceResendingToken) {
                              print('SENDING OTP');
                              setState(() {});
                              Get.to(OtpScreen(
                                id: verificationId,
                                token: forceResendingToken,
                                resendingToken: 4,
                                mobile: otpController,
                              ));
                            },
                            codeAutoRetrievalTimeout: (verificationId) {
                              print('TIMEOUT');
                            },
                            forceResendingToken: widget.resendingToken,
                          );
                        },
                        child: Text('Resend otp'),
                      )
                    : Text("Resend New Code $second s"),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        PhoneAuthCredential phoneCredential =
                            PhoneAuthProvider.credential(
                                verificationId: widget.id,
                                smsCode: otpController.text);
                        UserCredential credentials =
                            await auth.signInWithCredential(phoneCredential);
                        print('PHONE ${credentials.user!.phoneNumber}');
                        print('NAME ${credentials.user!.displayName}');
                      } on FirebaseAuthException catch (e) {
                        print('${e.code}');
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${e.message}')));
                      }
                      Get.to(
                        HomePage(userid: 'userid'),
                      );
                    },
                    child: Text('Verify'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
