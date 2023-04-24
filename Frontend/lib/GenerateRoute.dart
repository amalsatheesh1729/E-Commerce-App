import 'package:flutter/material.dart';
import 'package:simple_online_store/Screens/CartScreen.dart';
import 'package:simple_online_store/Screens/LogInScreen.dart';
import 'package:simple_online_store/Screens/LogUpscreen.dart';
import 'package:simple_online_store/Screens/MyOrderScreen.dart';
import 'package:simple_online_store/Screens/ProductScreen.dart';
import 'Screens/HomeScreen.dart';
import 'Screens/ProductDetailScreen.dart';


MaterialPageRoute generateRoutes(RouteSettings settings)
{

  if(settings.name=='/home') {
    return MaterialPageRoute(builder: (_)=>HomeScreen(),settings: settings
    );
  } else if(settings.name=='/logup') {
    return MaterialPageRoute(builder: (_)=>const LogUpScreen(),settings: settings);
  } else if(settings.name=='/user-detail') {
    return MaterialPageRoute(builder: (_)=>const LogUpScreen(),settings: settings);
  } else if(settings.name=='/myorders') {
    return MaterialPageRoute(builder: (_)=>MyOrderScreen(),settings: settings);
  } else if(settings.name=='/login') {
    return MaterialPageRoute(builder: (_)=>const LoginScreen(),settings:settings);
  } else if (settings.name=='/products') {
    return MaterialPageRoute(builder: (_)=>ProductScreen(),settings: settings);
  } else if (settings.name!=null && settings.name!.startsWith("/products/")){
    int productid=int.parse((settings.arguments as String));
    return MaterialPageRoute(builder: (_)=>ProductDetailScreen(productid:productid),
        settings: settings);
  }
  else if (settings.name=='/cart') {
    return MaterialPageRoute(builder: (_)=>const CartScreen(),settings: settings);
  } else {
    return MaterialPageRoute(builder: (_)=>HomeScreen(),settings: settings);
  }
}

