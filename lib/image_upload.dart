import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Image_upload extends StatefulWidget {
  const Image_upload({Key? key}) : super(key: key);

  @override
  State<Image_upload> createState() => _Image_uploadState();
}

class _Image_uploadState extends State<Image_upload> {
  ImagePicker picker = ImagePicker();

  FirebaseStorage storage = FirebaseStorage.instance;

  File? image;
  List allimage = [];
  CollectionReference upload1 = FirebaseFirestore.instance.collection('upload');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: allimage.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                      height: 200,
                      width: 200,
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      color: Colors.grey.shade200,
                      child: allimage == []
                          ? SizedBox()
                          : Image.file(
                              allimage[index]!,
                              fit: BoxFit.cover,
                            ));
                },
              ),
            ),
            InkResponse(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => SimpleDialog(
                    title: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkResponse(
                              onTap: () async {
                                XFile? file = await picker.pickImage(
                                    source: ImageSource.camera,
                                    imageQuality: 10);

                                allimage.add(File(file!.path));
                                setState(() {});
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                color: Colors.black,
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            GestureDetector(
                              onTap: () async {
                                XFile? file = await picker.pickImage(
                                    source: ImageSource.gallery,
                                    imageQuality: 10);

                                allimage.add(File(file!.path));
                                setState(() {});
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                color: Colors.black,
                                child: Icon(
                                  Icons.camera,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: Container(
                height: 80,
                width: 200,
                color: Colors.blue,
                child: Center(
                  child: Text(
                    'Select Image',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              child: Text('upload'),
              onPressed: () async {
                for (int i = 0; i < allimage.length; i++) {
                  storage
                      .ref('profile/image$i')
                      .putFile(allimage[i])
                      .then((p0) async {
                    String url = await p0.ref.getDownloadURL();
                    log('url $url');
                    upload1.add({'upimages': '${url}'});
                  });
                }
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
