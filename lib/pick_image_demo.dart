import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DemoImagePick extends StatefulWidget {
  const DemoImagePick({Key? key}) : super(key: key);

  @override
  State<DemoImagePick> createState() => _DemoImagePickState();
}

class _DemoImagePickState extends State<DemoImagePick> {
  ImagePicker picker = ImagePicker();

  FirebaseStorage storage = FirebaseStorage.instance;

  File? image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       GestureDetector(
      //         onTap: () async {
      //           XFile? file = await picker.pickImage(
      //               source: ImageSource.camera, imageQuality: 10);
      //
      //           image = File(file!.path);
      //           setState(() {});
      //         },
      //         child: Container(
      //           height: 300,
      //           width: 300,
      //           decoration: BoxDecoration(
      //             color: Colors.grey.withOpacity(0.3),
      //             borderRadius: BorderRadius.circular(10),
      //           ),
      //           child: image == null
      //               ? const Center(
      //                   child: Icon(
      //                     Icons.image,
      //                     size: 50,
      //                   ),
      //                 )
      //               : Image.file(image!, fit: BoxFit.cover),
      //         ),
      //       ),
      //       ElevatedButton(
      //         child: Text('upload'),
      //         onPressed: () async {
      //           storage
      //               .ref('profile/user1ProfileImage.png')
      //               .putFile(image!)
      //               .then(
      //             (p0) async {
      //               String url = await p0.ref.getDownloadURL();
      //
      //               print('URL $url');
      //             },
      //           );
      //         },
      //       )
      //     ],
      //   ),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                XFile? file = await picker.pickImage(
                    source: ImageSource.gallery, imageQuality: 10);

                image = File(file!.path);
                setState(() {});
              },
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                ),
                child: image == null
                    ? Center(child: Icon(Icons.image))
                    : Image.file(
                        image!,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            ElevatedButton(
              child: Text('upload'),
              onPressed: () async {
                storage
                    .ref('profile/user1ProfileImage')
                    .putFile(image!)
                    .then((p0) async {
                  String url = await p0.ref.getDownloadURL();
                  print('url $url');
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
