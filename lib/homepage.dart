import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login/send_otp.dart';

import 'email_with_login.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.userid}) : super(key: key);

  final String userid;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DocumentReference? users;

  GoogleSignIn googleSignIn = GoogleSignIn();
  final box1 = GetStorage();

  @override
  void initState() {
    // TODO: implement initState
    users = FirebaseFirestore.instance.collection('users').doc(widget.userid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: FutureBuilder(
              future: users!.get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  var data = snapshot.data;
                  TextEditingController firstnamecontroller =
                      TextEditingController(text: data!['firstname']);
                  TextEditingController lastnamecontroller =
                      TextEditingController(text: data!['lastname']);
                  TextEditingController emailcontroller =
                      TextEditingController(text: data!['email']);
                  TextEditingController passcrolontler =
                      TextEditingController(text: data!['password']);
                  return Column(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        child: Image.network('${data['imagesss']}'),
                      ),
                      Text(
                        '${data['firstname']}',
                        style: const TextStyle(fontSize: 25),
                      ),
                      Text(
                        '${data['lastname']}',
                        style: const TextStyle(
                          fontSize: 25,
                        ),
                      ),
                      Text(
                        '${data['email']}',
                        style: const TextStyle(
                          fontSize: 25,
                        ),
                      ),
                      Text(
                        '${data['password']}',
                        style: const TextStyle(
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        child: const Text('Edit'),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                    child: Container(
                                      height: 300,
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TextField(
                                              controller: firstnamecontroller,
                                              decoration: InputDecoration(
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                labelText: "firstname",
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            TextField(
                                              controller: lastnamecontroller,
                                              decoration: InputDecoration(
                                                labelText: "lastname",
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            ElevatedButton(
                                              child: const Text('update'),
                                              onPressed: () {
                                                users?.update({
                                                  'firstname':
                                                      firstnamecontroller.text,
                                                  'lastname':
                                                      lastnamecontroller.text,
                                                });
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ));
                        },
                      )
                    ],
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextButton(
            onPressed: () async {
              await googleSignIn.signOut();
              await box1.erase();

              Get.to(const Login());
            },
            child: const Text(
              'Log Out',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
