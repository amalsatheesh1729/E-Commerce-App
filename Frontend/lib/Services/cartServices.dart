



import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/DTO.dart';


Future<CartDTO> getUserCartFromServer(int userid ) async
{
  final prefs = await SharedPreferences.getInstance();
  String? token=prefs.getString("jwttoken");
  CartDTO? cart;
  final response =await http.get(Uri.parse("https://ecommerceappamal.store/cart-service/$userid" ),
    headers: {
      "content-type" : "application/json",
      "accept" : "application/json",
      "charset":"UTF-8",
      'Authorization': 'Bearer $token'
    },
  );
  if(response.statusCode==200){
    cart=CartDTO.fromJson( jsonDecode(response.body));
  }
  else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception(response.body);
  }

  return cart;

}


Future<CartDTO> updateUserCartToServer(CartDTO cart) async
{

  final prefs = await SharedPreferences.getInstance();
  String? token=prefs.getString("jwttoken");
  final response =await http.put(Uri.parse("https://ecommerceappamal.store/cart-service/${cart.cart!.userId}" ),
    body:jsonEncode(cart.toJson()),
    headers: {
      "content-type" : "application/json",
      "accept" : "application/json",
      "charset":"UTF-8",
      'Authorization': 'Bearer $token'
    },
  );
  if(response.statusCode==200){
    cart= CartDTO.fromJson(jsonDecode(response.body));
  }
  else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception(response.body);
  }

  return cart;

}


