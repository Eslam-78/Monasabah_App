import 'package:equatable/equatable.dart';
import 'package:monasbah/features/users/data/models/SignUpModel.dart';
import 'package:monasbah/features/users/data/models/editUserDetailsModel.dart';

abstract class EditUserDetailsEvent extends Equatable{

  const EditUserDetailsEvent();
}

class EditUserDetails extends EditUserDetailsEvent{
  final EditUserDetailsModel editUserDetailsModel;

  EditUserDetails({required this.editUserDetailsModel});

  @override
  List<Object?> get props => [editUserDetailsModel];

}


