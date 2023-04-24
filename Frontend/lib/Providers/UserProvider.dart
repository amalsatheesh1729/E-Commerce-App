import 'package:flutter/cupertino.dart';
import '../Models/DTO.dart';
import '../Services/userservices.dart';


class UserProvider extends ChangeNotifier{

   UserModel? userModel;

   setUserState(UserModel fromsharedpreferences){
   userModel=fromsharedpreferences;
   notifyListeners();
  }

  updateUserState(UserModel updatedfromapp){
    userModel=updatedfromapp;
    //update server
    updateUser(updatedfromapp);
    notifyListeners();
  }

}