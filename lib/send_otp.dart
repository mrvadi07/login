import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login/homepage.dart';
import 'package:lottie/lottie.dart';

import 'email_with_Register.dart';
import 'otp_verifyed.dart';

class SendOtp extends StatefulWidget {
  const SendOtp({Key? key}) : super(key: key);

  @override
  State<SendOtp> createState() => _SendOtpState();
}

class _SendOtpState extends State<SendOtp> {
  final formkey = GlobalKey<FormState>();
  final box = GetStorage();
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController controller = TextEditingController();
  Country selectedCountry = Country(
    phoneCode: "91",
    countryCode: "In",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "In",
    e164Key: "",
  );
  int? token;

  FirebaseAuth auth1 = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 25,
              horizontal: 35,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Lottie.network(
                    "https://assets5.lottiefiles.com/packages/lf20_llbjwp92qL.json",
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  "Register",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Add your phone number. We'll send you a verification code",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black38,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 40,
                ),
                Form(
                  key: formkey,
                  child: TextFormField(
                    maxLength: 10,
                    cursorColor: Colors.purple,
                    keyboardType: TextInputType.number,
                    controller: controller,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter phone no";
                      } else {
                        return null;
                      }
                    },
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      hintText: "Enter phone number",
                      hintStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                      prefixIcon: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 10),
                        child: InkResponse(
                          onTap: () {
                            showCountryPicker(
                                context: context,
                                countryListTheme: const CountryListThemeData(
                                  bottomSheetHeight: 550,
                                ),
                                onSelect: (value) {
                                  setState(() {
                                    selectedCountry = value;
                                  });
                                });
                          },
                          child: Text(
                            "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      suffixIcon: controller.text.length > 9
                          ? const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      child: Text("Register"),
                      onPressed: () async {
                        if (formkey.currentState!.validate()) {
                          print(controller.text);
                          try {
                            await auth.verifyPhoneNumber(
                              phoneNumber: '+91 ${controller.text}',
                              verificationCompleted: (phoneAuthCredential) {
                                print('success');
                              },
                              verificationFailed: (error) {
                                print('Error');
                              },
                              codeSent: (verificationId, forceResendingToken) {
                                setState(() {
                                  token = forceResendingToken;
                                });
                                Get.to(
                                  OtpScreen(
                                    id: verificationId,
                                    mobile: controller.text,
                                    token: forceResendingToken,
                                  ),
                                );
                              },
                              codeAutoRetrievalTimeout:
                                  (String verificationId) {},
                            );
                          } on FirebaseAuthException catch (e) {
                            print('${e.code}');
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${e.message}')));
                          }
                        }
                      }),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkResponse(
                      onTap: () {
                        Get.to(resgister_with_email());
                      },
                      child: Text(
                        'Sign in with email',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                InkResponse(
                  onTap: () async {
                    GoogleSignInAccount? account = await googleSignIn.signIn();
                    GoogleSignInAuthentication authentication =
                        await account!.authentication;

                    OAuthCredential credential = GoogleAuthProvider.credential(
                        idToken: authentication.idToken,
                        accessToken: authentication.accessToken);

                    UserCredential userCredential =
                        await auth1.signInWithCredential(credential);

                    print('${userCredential.user!.uid}');
                    print('${userCredential.user!.displayName}');
                    print('${userCredential.user!.photoURL}');
                    print('${userCredential.user!.email}');
                    // Get.to(HomePage(userid: 'userid');
                  },
                  child: Container(
                    height: 60,
                    width: 420,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          child: Image.asset("assets/images/google.png"),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Text(
                          'Sign in with Google',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
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
