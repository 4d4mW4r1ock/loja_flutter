import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_flutter/datas/produtc_data.dart';

class CartProduct{
  String cid;
  String category;
  String pid;
  int quantity;
  ProductData productData;


  CartProduct.fromDocument(DocumentSnapshot document){
    cid = document.documentID;
    category = document.data["category"];
    pid = document.data["pid"];
    quantity = document.data["quantity"];
  }

  CartProduct();

  Map<String, dynamic> toMap(){
    return {
      "category" : category,
      "pid" : pid,
      "quantity" : quantity,
      "product" : productData.toResumeMap()
    };
  }
}