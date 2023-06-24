import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({Key? key, this.product}) : super(key: key);

  final product;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  void initState() {
    // TODO: implement initState

    productDetails =
        FirebaseFirestore.instance.collection('Products').doc(widget.product);

    super.initState();
  }

  DocumentReference? productDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: productDetails?.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var dataStore = snapshot.data!.data() as Map<String, dynamic>;

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Products Name : ${dataStore!['Name']}"),
                  Text("Products Price : ${dataStore!['Price']}"),
                  Text("Products Discount : ${dataStore!['Discount']}"),
                  Text("Products Quantity : ${dataStore!['Quantity']}"),
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
