import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login/homepage.dart';
import 'package:lottie/lottie.dart';

import 'chat_screen.dart';
import 'email_with_Register.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final box1 = GetStorage();
  bool loading = false;

  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  FirebaseAuth auth1 = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Lottie.network(
                "https://assets5.lottiefiles.com/packages/lf20_llbjwp92qL.json",
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Login",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 50,
              ),
            ),
            SizedBox(
              height: 25,
            ),
            TextField(
              controller: emailcontroller,
              decoration: InputDecoration(
                  hintText: "Enter Email",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  )),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
                controller: passcontroller,
                decoration: InputDecoration(
                    hintText: "Enter Password",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ))),
            SizedBox(
              height: 20,
            ),
            Center(
              child: loading == true
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      child: const Text('Login'),
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        try {
                          UserCredential credential =
                              await auth.signInWithEmailAndPassword(
                                  email: emailcontroller.text,
                                  password: passcontroller.text);

                          print('${credential.user!.email}');
                          print('${credential.user!.uid}');

                          await box1.write(
                            'userid',
                            credential.user!.uid,
                          );
                          setState(() {
                            loading = false;
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(
                                  userid: credential.user!.uid,
                                ),
                              ));
                        } on FirebaseAuthException catch (e) {
                          print('${e.code}');
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('${e.message}'),
                          ));
                          setState(() {
                            loading = false;
                          });
                        }
                      },
                    ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "You dont't have an acoount?",
                ),
                SizedBox(
                  width: 5,
                ),
                InkResponse(
                  onTap: () {
                    Get.to(resgister_with_email());
                  },
                  child: Text(
                    "Sign up",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
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
                Get.to(HomePage(userid: 'BSW3pePB7mN2UHanN7arfrkcXV42'));
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
    );
  }
}
