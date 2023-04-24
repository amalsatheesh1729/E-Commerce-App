


import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_online_store/Models/DTO.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:simple_online_store/Providers/UserProvider.dart';

Future<List<NotificationModel>> getNotificationsForUser(int userid) async
{
    final prefs = await SharedPreferences.getInstance();
    String? token=await prefs.getString("jwttoken");
    List<NotificationModel> notifications=[];
    final response =await http.get(Uri.parse("https://ecommerceappamal.store/notification-service/notifications/$userid" ),
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
        notifications.add(NotificationModel.fromJson(order));
      }

    }
    else {

      throw Exception(response.body);
    }

    return notifications.toList();

}


Future<void> updateNotificationsForUser(int notifid) async
{
  final prefs = await SharedPreferences.getInstance();
  String? token=await prefs.getString("jwttoken");
  final response =await http.put(Uri.parse("https://ecommerceappamal.store/notification-service/notifications/$notifid"),
    headers: {
      "content-type" : "application/json",
      "accept" : "application/json",
      "charset":"UTF-8",
      'Authorization': 'Bearer $token'
    },
  );
}


