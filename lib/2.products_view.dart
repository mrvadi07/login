import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '3.products_details.dart';

class ProductView extends StatefulWidget {
  const ProductView({Key? key}) : super(key: key);

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  CollectionReference products =
      FirebaseFirestore.instance.collection('Products');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: products.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var dataStore =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;

                return InkResponse(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetail(
                          product: '${snapshot.data!.docs[index].id}',
                        ),
                      ),
                    );
                  },
                  child: Container(
                    color: Colors.green.shade200,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ListTile(
                            leading: Text("Name : "),
                            title: Text('${dataStore['Name']}'),
                          ),
                          ListTile(
                            leading: Text("Price : "),
                            title: Text('${dataStore['Price']}'),
                          ),
                          ListTile(
                            leading: Text("Discount : "),
                            title: Text('${dataStore['Discount']}'),
                          ),
                          ListTile(
                            leading: Text("Quantity : "),
                            title: Text('${dataStore['Quantity']}'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

///Demo

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class ProductView extends StatefulWidget {
//   const ProductView({Key? key}) : super(key: key);
//
//   @override
//   State<ProductView> createState() => _ProductViewState();
// }
//
// class _ProductViewState extends State<ProductView> {
//   CollectionReference product = FirebaseFirestore.instance.collection('Demo');
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder(
//         future: product.get(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return ListView.builder(
//               itemCount: snapshot.data!.docs.length,
//               itemBuilder: (context, index) {
//                 var record = snapshot.data!.docs[index];
//
//                 return Container(
//                   height: 200,
//                   width: double.infinity,
//                   color: Colors.redAccent,
//                   margin: EdgeInsets.all(25),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(record['Name']),
//                       Text(record['Price']),
//                       Text(record['Quantity']),
//                       Text(record['Discount']),
//                     ],
//                   ),
//                 );
//               },
//             );
//           } else {
//             return Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//     );
//   }
// }
