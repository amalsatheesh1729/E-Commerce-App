import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_online_store/Providers/CartProvider.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:firebase_core/firebase_core.dart';
import 'GenerateRoute.dart';
import 'Providers/UserProvider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setPathUrlStrategy();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (_) => CartProvider())
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  String? jwttoken;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isValidJWT();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home Made',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: (settings) => generateRoutes(settings),
      initialRoute: jwttoken == null ? '/home' : '/products',
    );
  }

  void isValidJWT() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("jwttoken")) {
      jwttoken = prefs.getString("jwttoken");
    } else {
      jwttoken = null;
    }
  }
}
