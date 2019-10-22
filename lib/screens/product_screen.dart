import 'package:flutter/material.dart';
import 'package:loja_flutter/datas/produtc_data.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:loja_flutter/datas/cart_product.dart';
import 'package:loja_flutter/models/cart_model.dart';
import 'package:loja_flutter/models/user_model.dart';
import 'package:loja_flutter/screens/cart_screen.dart';
import 'package:loja_flutter/screens/login_screen.dart';

class ProductScreen extends StatefulWidget {
  final ProductData product;

  ProductScreen(this.product);

  @override
  _ProductScreenState createState() => _ProductScreenState(product);
}

class _ProductScreenState extends State<ProductScreen> {

  final ProductData product;

  _ProductScreenState(this.product);

  @override
  Widget build(BuildContext context) {

    final Color prymaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 0.9,
            child: Carousel(
              images: product.images.map((url){
                return NetworkImage(url);
              }).toList(),
              dotSize: 4.0,
              dotSpacing: 15.0,
              dotBgColor: Colors.transparent,
              dotColor: prymaryColor,
              autoplay: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  product.title,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500
                  ),
                  maxLines: 3,
                ),
                Text(
                  "R\$ ${product.price.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: prymaryColor
                  ),
                ),
                SizedBox(height: 16.0,),
                SizedBox(
                  height: 44.0,
                  child: RaisedButton(
                      onPressed: (){
                        if(UserModel.of(context).isLoggedIn()){
                          CartProduct cartProduct = CartProduct();

                          cartProduct.quantity = 1;
                          cartProduct.pid = product.id;
                          cartProduct.category = product.category;
                          cartProduct.productData = product;

                          CartModel.of(context).addCartItem(cartProduct);

                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => CartScreen())
                          );
                        }else{
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()
                            )
                          );
                        }
                      },
                      child: Text(
                          UserModel.of(context).isLoggedIn() ? "Adicionar a cesta" :
                          "Entre para comprar",
                          style: TextStyle(fontSize: 18.0),
                      ),
                      color: prymaryColor,
                      textColor: Colors.white,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  "Descrição",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  product.description,
                  style: TextStyle(
                    fontSize: 16.0
                  ),
                )
              ],
            ),
          )
        ],
      )
    );
  }
}
