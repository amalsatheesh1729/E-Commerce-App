import 'package:flutter/material.dart';
import 'package:flutter_awesome_buttons/flutter_awesome_buttons.dart';
import 'package:provider/provider.dart';
import 'package:simple_online_store/DRY.dart';
import 'package:simple_online_store/Models/DTO.dart';
import '../Providers/UserProvider.dart';
import '../Services/ProductServices.dart';
import '../Services/userservices.dart';

class LogUpScreen extends StatefulWidget {
  const LogUpScreen({super.key});

  @override
  State<LogUpScreen> createState() => _LogUpScreenState();
}

class _LogUpScreenState extends State<LogUpScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController emailc;
  late TextEditingController passc;
  late TextEditingController phonec;
  late TextEditingController addressc;
  late TextEditingController namec;
  String? defaulturl= 'https://firebasestorage.googleapis.com/v0/b/divine-bloom-383508.appspot.com/o/profileimages%2Fdefaultprofileimage.png?alt=media&token=e5df4a09-8380-42dc-9c9a-0f75a98fa372';
  String? url ;

  @override
  void initState() {
    super.initState();
    emailc =  TextEditingController();
    namec =  TextEditingController();
    passc =  TextEditingController();
    phonec =  TextEditingController();
    addressc =  TextEditingController();
    url=defaulturl;
  }

  @override
  void dispose() {
    super.dispose();
    emailc.dispose();
    passc.dispose();
    phonec.dispose();
    addressc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user=context.watch<UserProvider>().userModel;
    if(user!=null){
    namec.text=user.name;
    emailc.text=user.email;
    passc.text=user.password;
    phonec.text=user.phonenumber;
    addressc.text=user.address;
    url=user.profileimage;
    }

    return Scaffold(
      body:Container(
        width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    decoration: const BoxDecoration(
    image: DecorationImage(
    fit: BoxFit.cover,
    image: AssetImage("./lib/assets/cover3.jpg")),
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
                Flexible(
                  child: Stack(
                    children: [
                      url != null
                          ? CircleAvatar(
                              radius: 75,
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(url!))
                          : const CircularProgressIndicator(),
                      IconButton(
                          onPressed: () async {
                            setState(() {
                              url = null;
                            });
                            String ans = await uploadToObjectStorage();
                            ans.isEmpty?
                              setState(() {
                                url=defaulturl;
                              }):setState((){
                                  url = ans;
                                  });
                            },
                          icon: const Icon(Icons.add_a_photo))
                    ],
                  ),
                ),
                Flexible(child: getFormField(namec, 'Enter Your Name :')),
                Flexible(child: getFormField(emailc, 'Enter Your E-Mail :')),
                if(user==null)Flexible(child: getFormField(passc, 'Enter Your Password :')),
                Flexible(
                    child:
                        getFormField(addressc, 'Enter Your Delivery Address :')),
                Flexible(
                    child: getFormField(
                        phonec, 'Enter Your Indian Mobile Number :')),
                Flexible(
                    child:SuccessButton(
                      title: user==null? "    Sign Up     ":" Update User Details",
                  onPressed: () async {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      try {
                        if(user!=null) {
                          await updateUser(UserModel(
                              userId: user!.userId,
                              email: emailc.text,
                              password: passc.text,
                              name: namec.text,
                              address: addressc.text,
                              profileimage: url!,
                              phonenumber: phonec.text));
                          Navigator.pushNamed(context, '/products');
                          showSnack(
                              context, 'Succesfully Updated User Details ', Colors.green);


                        }
                        else{
                          await signUp(UserModel(
                              email: emailc.text,
                              password: passc.text,
                              name: namec.text,
                              address: addressc.text,
                              profileimage: url!,
                              phonenumber: phonec.text),context);

                        }
                      } catch (e) {
                        showSnack(context, e.toString(), Colors.red);
                      }
                    }
                  },
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
