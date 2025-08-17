import 'package:equatable/equatable.dart';

abstract class EditUserDetailsState extends Equatable{

  const EditUserDetailsState();
}


class EditUserDetailsInitial extends EditUserDetailsState{
  @override
  List<Object?> get props => [];

}

class EditUserDetailsLoading extends EditUserDetailsState{

  @override
  List<Object?> get props => [];

}

class EditUserDetailsLoaded extends EditUserDetailsState{
  dynamic message;

  EditUserDetailsLoaded({required this.message});

  @override
  List<Object?> get props => [message];

}

class EditUserDetailsError extends EditUserDetailsState{
  String errorMessage;

  EditUserDetailsError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];

}