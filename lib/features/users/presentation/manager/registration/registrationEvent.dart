import 'package:equatable/equatable.dart';
import 'package:monasbah/features/users/data/models/SignUpModel.dart';
import 'package:monasbah/features/users/data/models/loginModel.dart';

abstract class RegistrationEvent extends Equatable{

  const RegistrationEvent();
}


  class SignupRequest extends RegistrationEvent{
  SignUpModel signUpModel;
  SignupRequest({required this.signUpModel});

  @override
  List<Object?> get props => [signUpModel];

}


class LoginRequest extends RegistrationEvent{

  LoginModel loginModel;
  LoginRequest({required this.loginModel});

  @override
  List<Object?> get props => [loginModel];

}


class SendConfirmCodeEvent extends RegistrationEvent{
  String email,userBrand;

  SendConfirmCodeEvent({required this.email,required this.userBrand});

  @override
  List<Object?> get props =>[email,userBrand];

}

class CheckConfirmCodeEvent extends RegistrationEvent{
  String email,confirmCode,userBrand;

  CheckConfirmCodeEvent({required this.email,required this.confirmCode,required this.userBrand});

  @override
  List<Object?> get props =>[email,confirmCode,userBrand];

}

class EditPasswordEvent extends RegistrationEvent{
  String email,password,userBrand;

  EditPasswordEvent({required this.email,required this.password,required this.userBrand});

  @override
  List<Object?> get props =>[email,password,userBrand];

}

class LogoutEvent extends RegistrationEvent{
  String token;

  LogoutEvent({required this.token});

  @override
  List<Object?> get props => [token];

}

