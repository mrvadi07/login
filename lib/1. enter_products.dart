import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '2.products_view.dart';

class EnterProduct extends StatefulWidget {
  const EnterProduct({Key? key}) : super(key: key);

  @override
  State<EnterProduct> createState() => _EnterProductState();
}

class _EnterProductState extends State<EnterProduct> {
  TextEditingController productController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  CollectionReference products =
      FirebaseFirestore.instance.collection('Products');
  DocumentReference product = FirebaseFirestore.instance
      .collection('Products')
      .doc('GnufyTQffLxR5DvH85RH');

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductView(),
            ),
          );
        },
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              keyboardType: TextInputType.text,
              controller: productController,
              decoration: const InputDecoration(
                labelText: "product name",
                constraints: BoxConstraints(maxWidth: 300),
              ),
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: priceController,
              decoration: const InputDecoration(
                labelText: "price",
                constraints: BoxConstraints(maxWidth: 300),
              ),
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: discountController,
              decoration: const InputDecoration(
                labelText: "discount",
                constraints: BoxConstraints(maxWidth: 300),
              ),
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: quantityController,
              decoration: const InputDecoration(
                labelText: "quantity",
                constraints: BoxConstraints(maxWidth: 300),
              ),
            ),
            loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      products.add({
                        "Name": productController.text,
                        "Price": priceController.text,
                        "Discount": discountController.text,
                        "Quantity": quantityController.text,
                      });
                      productController.clear();
                      priceController.clear();
                      discountController.clear();
                      quantityController.clear();
                      setState(() {
                        loading = false;
                      });
                    },
                    child: Text("add"),
                  ),
            ElevatedButton(
              child: Text('update'),
              onPressed: () {
                product.update({
                  'products name': productController.text,
                  'price': priceController.text,
                  'discount': discountController.text,
                  'quantity': quantityController.text,
                });
              },
            )
          ],
        ),
      ),
    );
  }
}

///Demo
