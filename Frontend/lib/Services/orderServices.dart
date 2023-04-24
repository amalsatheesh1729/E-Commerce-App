import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/DTO.dart';


Future<OrderModel> placeOrder(OrderModel order) async
{

  final prefs = await SharedPreferences.getInstance();
  String? token=prefs.getString("jwttoken");
  final response =await http.post(Uri.parse("https://ecommerceappamal.store/order-service/orders" ),
    body:jsonEncode(order.toJson()),
    headers: {
      "content-type" : "application/json",
      "accept" : "application/json",
      "charset":"UTF-8",
      'Authorization': 'Bearer $token'
    },
  );
  if(response.statusCode==200){
    order=OrderModel.fromJson( jsonDecode(response.body));
  }
  else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception(response.body);
  }

  return order;

}


Future<List<OrderModel>> getOrdersOfUser(int userid) async
{

  final prefs = await SharedPreferences.getInstance();
  String? token=prefs.getString("jwttoken");
  List<OrderModel> myorders=[];
  final response =await http.get(Uri.parse("https://ecommerceappamal.store/order-service/orders/users/$userid" ),
    headers: {
      "content-type" : "application/json",
      "accept" : "application/json",
      "charset":"UTF-8",
      'Authorization': 'Bearer $token'
    },
  );
  if(response.statusCode==200){
    for(var order in jsonDecode(response.body))
      {
        myorders.add(OrderModel.fromJson(order));
      }

  }
  else {

    throw Exception(response.body);
  }

  return myorders;

}

