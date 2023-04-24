import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_online_store/DRY.dart';
import '../Models/DTO.dart';




Future<UserModel> signIn  (AuthModel authModel) async
{

  final response =await http.post(Uri.parse("https://ecommerceappamal.store/login" ),
    body: jsonEncode(authModel.toJson()),
    headers: {
      "content-type" : "application/json",
      "accept" : "application/json",
      "charset":"UTF-8",
    },
  );


  if(response.statusCode==200)
  {

    return  UserModel.fromJson(jsonDecode(response.body));
  }
  else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception(jsonDecode(response.body));
  }

}

Future<void> signUp  (UserModel userModel,BuildContext context) async
{

  final isexist= await http.post(Uri.parse("https://ecommerceappamal.store/user-service/users/${userModel.email}"));
  if(!isexist.body.isEmpty) {
    showSnack(context, "User with same email address already exists in the database !! ",Colors.red);
    return ;
  }

  final response =await http.post(Uri.parse("https://ecommerceappamal.store/logup" ),
    body: jsonEncode(userModel.toJson()),
    headers: {
      "content-type" : "application/json",
      "accept" : "application/json",
      "charset":"UTF-8",
    },
  );
  Navigator.pushNamed(context, '/login');
  showSnack(
      context, 'Succesfully Signed Up ', Colors.green);
}






Future<UserModel> updateUser  (UserModel userModel) async
{
  final prefs = await SharedPreferences.getInstance();
  String? token=prefs.getString("jwttoken");
  final response =await http.put(Uri.parse("https://ecommerceappamal.store/user-service/users" ),
    body: jsonEncode(userModel.toJson()),
    headers: {
      "content-type" : "application/json",
      "accept" : "application/json",
      "charset":"UTF-8",
      'Authorization': 'Bearer $token'
    },
  );

  if(response.statusCode==200)
  {
    return  UserModel.fromJson(jsonDecode(response.body));
  }
  else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception(response.body);
  }

}


Future<UserModel> getUser  (int userid ) async
{
  final prefs = await SharedPreferences.getInstance();
  String? token=prefs.getString("jwttoken");
  final response =await http.get(Uri.parse("https://ecommerceappamal.store/user-service/$userid"),
    headers: {
      "content-type" : "application/json",
      "accept" : "application/json",
      "charset":"UTF-8",
      'Authorization': 'Bearer $token'
    },
  );

  if(response.statusCode==200)
  {
    return  UserModel.fromJson(jsonDecode(response.body));
  }
  else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception(response.body);
  }

}