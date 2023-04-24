import 'package:flutter/material.dart';
import 'package:flutter_awesome_buttons/flutter_awesome_buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_online_store/DRY.dart';
import 'package:simple_online_store/Models/DTO.dart';
import '../Services/userservices.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailc;
  late TextEditingController passc;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    emailc = TextEditingController();
    passc = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    super.dispose();
    super.dispose();
    emailc.dispose();
    passc.dispose();
  }

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
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Flexible(
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage("./lib/assets/home_made.jpg"),
                ),
              ),
              Flexible(
                  child: getFormField(emailc, 'Please Enter Your E-Mail :')),
              Flexible(
                  child: getFormField(passc, 'Please Enter Your Password :')),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(value: true, onChanged: (value) {}),
                        const Text('Remember me '),
                      ],
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Forgot Password ?',
                        style: TextStyle(color: Colors.blue, fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
              SuccessButton(
                title: "       Log In       ",
                onPressed: () async {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    try {
                      UserModel usermodel = await signIn(
                          AuthModel(email: emailc.text, password: passc.text));
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setInt("userid", usermodel.userId!);
                      await prefs.setString("jwttoken", usermodel.jwttoken!);
                      Navigator.pushNamed(context, '/products');
                    } catch (e) {
                      showSnack(context, e.toString(), Colors.red);
                    }
                  }
                },
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/logup');
                },
                child: const Text(
                  'Don\'t have an account Yet ? Sign Up !!! ',
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
