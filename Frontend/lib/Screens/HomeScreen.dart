import 'package:flutter/material.dart';
import 'package:flutter_awesome_buttons/flutter_awesome_buttons.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final Uri _url = Uri.parse(
      'https://firebasestorage.googleapis.com/v0/b/divine-bloom-383508.appspot.com/o/arch.pdf?alt=media&token=9f55f165-a2a3-42cc-a8ae-7c1d059ad2be');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
        width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    decoration: const BoxDecoration(
    image: DecorationImage(
    fit: BoxFit.cover, image: AssetImage("./lib/assets/cover3.jpg")),
    ),
    child: Container(
    margin: EdgeInsets.symmetric(
    horizontal: MediaQuery.of(context).size.width>=600?MediaQuery.of(context).size.width / 5:1,
    vertical: MediaQuery.of(context).size.height / 15),
    decoration: BoxDecoration(
    border: Border.all(width: 1, color: Colors.purple),
    borderRadius: BorderRadius.circular(60)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage("./lib/assets/home_made.jpg"),
                ),
                const Text(
                  'Welcome to Home Made !!\n An exclusive platform for home made items.',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontStyle: FontStyle.italic,
                    color: Colors.purple,
                    height: 2.5,
                    letterSpacing: 0.7,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                       PrimaryButton(
                      onPressed:_launchUrl,
                      title: "Architecture",
                    ),
                    PrimaryButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      title: "Log In",
                    ),
                  ],
                )
              ],
            ))));
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

}
