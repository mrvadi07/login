// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:pinput/pinput.dart';
//
// class ChatScreen extends StatefulWidget {
//   const ChatScreen({Key? key}) : super(key: key);
//
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   TextEditingController controller = TextEditingController();
//   CollectionReference users = FirebaseFirestore.instance.collection('chat');
//   var message = FirebaseFirestore.instance
//       .collection('chat')
//       .orderBy('datetime', descending: false)
//       .snapshots();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           StreamBuilder(
//             stream: message,
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 return Expanded(
//                   child: ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: snapshot.data!.docs.length,
//                     itemBuilder: (context, index) {
//                       var data = snapshot.data!.docs[index].data()
//                           as Map<String, dynamic>;
//                       return data['sender_id'] == '1'
//                           ? Padding(
//                               padding: const EdgeInsets.only(left: 50),
//                               child: Text(
//                                 "${data['message']}",
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                 ),
//                               ),
//                             )
//                           : Padding(
//                               padding: const EdgeInsets.only(left: 450),
//                               child: Text('${data['message']}'),
//                             );
//                     },
//                   ),
//                 );
//               } else {
//                 return Center(
//                   child: Text('No Data'),
//                 );
//               }
//             },
//           ),
//           Row(
//             children: [
//               Container(
//                 height: 70,
//                 width: 400,
//                 decoration: BoxDecoration(
//                   color: Colors.blueGrey.shade200,
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 child: Center(
//                   child: TextField(
//                     controller: controller,
//                     decoration: InputDecoration(
//                       prefixIcon: Icon(Icons.emoji_emotions),
//                       hintText: "Enter your Text",
//                       enabledBorder: UnderlineInputBorder(
//                         borderSide: BorderSide.none,
//                       ),
//                       focusedBorder: UnderlineInputBorder(
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               InkWell(
//                 onTap: () {
//                   Map<String, dynamic> data = {
//                     "sender_id": 'Z3yhRvGrQpZW8XhrhitN',
//                     "msg": controller.text,
//                     "datetime": '${DateTime.now()}'
//                   };
//                 },
//                 child: CircleAvatar(
//                   radius: 40,
//                   child: Icon(Icons.send),
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _controller = TextEditingController();
  var message = FirebaseFirestore.instance.collection('chats');
  var messages = FirebaseFirestore.instance
      .collection('chats')
      .orderBy('datetime', descending: false)
      .snapshots();
  var selescted = '';
  final box1 = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Screen'),
      ),
      backgroundColor: Colors.green.shade100,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: messages,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      // reverse: true,
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var data = snapshot.data!.docs[index].data();
                        return data["sender_id"] == "pRMuD9oH2RGdtpNKExLk"
                            ? Text(
                                textAlign: TextAlign.right,
                                '${data['msg']}',
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              )
                            : Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  textAlign: TextAlign.left,
                                  '${data['msg']}',
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                              );
                      },
                    );
                  } else
                    return Center(
                      child: Text('No Text'),
                    );
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        selescted = value;
                      });
                    },
                    controller: _controller,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.emoji_emotions),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                InkResponse(
                  onTap: () {
                    Map<String, dynamic> data = {
                      "sender_id": "pRMuD9oH2RGdtpNKExLk",
                      "msg": _controller.text,
                      "datetime": "${DateTime.now()}"
                    };
                    message.add(data);
                  },
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: selescted.isEmpty
                        ? Icon(Icons.mic, color: Colors.white, size: 40)
                        : Icon(Icons.send, color: Colors.white, size: 40),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
