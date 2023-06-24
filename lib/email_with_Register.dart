import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login/homepage.dart';

import 'chat_screen.dart';
import 'email_with_login.dart';
import 'email_with_register.dart';

class resgister_with_email extends StatefulWidget {
  const resgister_with_email({Key? key}) : super(key: key);

  @override
  State<resgister_with_email> createState() => _resgister_with_emailState();
}

class _resgister_with_emailState extends State<resgister_with_email> {
  final box1 = GetStorage();
  bool loading = false;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  TextEditingController firstnamecontroller = TextEditingController();
  TextEditingController lastmnamecontroller = TextEditingController();

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  ImagePicker picker = ImagePicker();
  File? images;
  String? url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkResponse(
              onTap: () async {
                XFile? file = await picker.pickImage(
                    source: ImageSource.gallery, imageQuality: 10);
                images = File(file!.path);
                setState(() {});
              },
              child: Container(
                height: 100,
                width: 100,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                ),
                child: images == null
                    ? const Center(child: Icon(Icons.image))
                    : Image.file(
                        images!,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Creat New Account",
              style: TextStyle(color: Colors.blue, fontSize: 50),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              keyboardType: TextInputType.text,
              controller: firstnamecontroller,
              decoration: const InputDecoration(
                hintText: "Fisrt Name",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 3, color: Colors.green),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              controller: lastmnamecontroller,
              decoration: const InputDecoration(
                hintText: "Last Name",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 3, color: Colors.green),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              controller: emailcontroller,
              decoration: const InputDecoration(
                hintText: "Enter Email",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 3, color: Colors.green),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              controller: passcontroller,
              decoration: const InputDecoration(
                hintText: "Enter Password",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 3, color: Colors.green),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 20),
            loading
                ? const CircularProgressIndicator()
                : Center(
                    child: ElevatedButton(
                      child: const Text('Sign in'),
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        try {
                          UserCredential credential =
                              await auth.createUserWithEmailAndPassword(
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
                          await storage
                              .ref('profile/user1ProfileImage')
                              .putFile(images!)
                              .then((p0) async {
                            url = await p0.ref.getDownloadURL();
                            print('url $url');
                          });
                          users.doc(credential.user!.uid).set(
                            {
                              'firstname': firstnamecontroller.text,
                              'lastname': lastmnamecontroller.text,
                              'email': emailcontroller.text,
                              'password': passcontroller.text,
                              'imagesss': url,
                            },
                          );

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    HomePage(userid: credential.user!.uid),
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
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Olredy you have account?",
                ),
                const SizedBox(width: 5),
                InkResponse(
                  onTap: () {
                    Get.to(const Login());
                  },
                  child: const Text(
                    "Log in",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
