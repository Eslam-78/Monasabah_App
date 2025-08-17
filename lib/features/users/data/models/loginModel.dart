import 'package:flutter/cupertino.dart';

class LoginModel extends ChangeNotifier{

  late String email,password,userBrand;

  LoginModel({required this.email,required this.password,required this.userBrand});

  Map<String,dynamic>toJson()=>{'email':email,'password':password,'userBrand':userBrand};



  
}