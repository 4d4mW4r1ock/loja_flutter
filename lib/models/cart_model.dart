import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_flutter/datas/cart_product.dart';
import 'package:loja_flutter/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class CartModel extends Model{
  UserModel user;

  List<CartProduct> products = [];

  String couponCode;
  int discountPercentage = 0;



  CartModel(this.user){
    if(user.isLoggedIn()){
      print("111");
      _loadCartItems();
    }
  }

  bool isLoading = false;

  static CartModel of(BuildContext context){
    return ScopedModel.of<CartModel>(context);
  }

  void addCartItem(CartProduct cartProduct){
    products.add(cartProduct);

    Firestore.instance.collection("users").document(user.firebaseUser.uid).
    collection("cart").add(cartProduct.toMap()).then(
        (doc){
          cartProduct.cid = doc.documentID;
        }
    );

    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct){
    Firestore.instance.collection("users").document(user.firebaseUser.uid).
    collection("cart").document(cartProduct.cid).delete();
    
    products.remove(cartProduct);

    notifyListeners();
  }

  void decProduct(CartProduct cartProduct){
    cartProduct.quantity --;
    Firestore.instance.collection("users").document(user.firebaseUser.uid).
    collection("cart").document(cartProduct.cid).updateData(cartProduct.toMap());

    notifyListeners();
  }

  void incProduct(CartProduct cartProduct){
    cartProduct.quantity ++;
    Firestore.instance.collection("users").document(user.firebaseUser.uid).
    collection("cart").document(cartProduct.cid).updateData(cartProduct.toMap());

    notifyListeners();
  }

  double getProductPrice(){
    double price = 0.0;
    for(CartProduct c in products){
      if(c.productData != null){
        price += c.quantity * c.productData.price;
      }
    }

    return price;
  }

  double getDiscount(){
    return getProductPrice() * discountPercentage / 100;
  }

  double getShipPrice(){
    return 9.99;
  }

  void updatePrices(){
    notifyListeners();
  }

  void setCoupon(String couponCode, int discountPercentage){
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  Future<String> finishOrder() async{

    if(products.length == 0){
      return null;
    }

    isLoading = true;
    notifyListeners();

    double productsPrice = getProductPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();

    DocumentReference refOrder = await Firestore.instance.collection("orders").add(
      {
       "clientId" : user.firebaseUser.uid,
       "products" : products.map((cartProduct) => cartProduct.toMap()).toList(),
       "shipPrice" : shipPrice,
       "productsPrice" : productsPrice,
       "discountPrice" : discount,
       "totalPrice" : productsPrice + shipPrice - discount,
       "status" : 1
      }
    );
    
    await Firestore.instance.collection("users").document(user.firebaseUser.uid).
    collection("orders").document(refOrder.documentID).
    setData({"orderId" : refOrder.documentID});

    QuerySnapshot query = await Firestore.instance.collection("users").document(user.firebaseUser.uid).
    collection("cart").getDocuments();

    for(DocumentSnapshot doc in query.documents){
      doc.reference.delete();
    }

    products.clear();

    couponCode = null;
    discountPercentage = 0;

    isLoading = false;
    notifyListeners();

    return refOrder.documentID;

  }

  void _loadCartItems() async{
    QuerySnapshot query = await Firestore.instance.collection("users").
    document(user.firebaseUser.uid).
    collection("cart").getDocuments();

    products = query.documents.map((doc) => CartProduct.fromDocument(doc)).toList();

    notifyListeners();
  }
}