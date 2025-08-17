import 'package:equatable/equatable.dart';

abstract class RegistrationState extends Equatable{

  const RegistrationState();
}


class RegisterInitial extends RegistrationState{
  @override
  List<Object?> get props => [];

}

class RegisterLoading extends RegistrationState{

  @override
  List<Object?> get props => [];

}

class RegisterLoaded extends RegistrationState{
  dynamic message;

  RegisterLoaded({required this.message});

  @override
  List<Object?> get props => [message];

}

class RegisterError extends RegistrationState{
  String errorMessage;

  RegisterError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];

}