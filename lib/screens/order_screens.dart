import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  
  final String orderId;
  
  OrderScreen(this.orderId);
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedido Realizado"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.check,
                size: 80.0,
                color: Theme.of(context).primaryColor,
              ),
              Text(
                "Pedido Realizado com sucesso!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),),
              SizedBox(height: 18.0,),
              Text("Código do pedido:", style: TextStyle(fontSize: 16.0),),
              Text("$orderId", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),)
            ],
          ),
        )
      ),
    );
  }
}
