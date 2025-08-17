import 'package:equatable/equatable.dart';
import 'package:monasbah/features/customers/adds/data/model/addsModel.dart';
import 'package:monasbah/features/customers/home/data/models/mainMenuSectionsModel.dart';

abstract class AddsState extends Equatable{
  const AddsState();
}

class GetAddsInitial extends AddsState{
  @override
  List<Object?> get props => [];

}

class GetAddsLoading extends AddsState{
  @override
  List<Object?> get props => [];

}

class GetAddsLoaded extends AddsState{
  final List<AddsModel>  addsModel;

  GetAddsLoaded({required this.addsModel});

  @override
  List<Object> get props => [addsModel];
}

class GetAddsError extends AddsState {

  final String errorMessage;
  GetAddsError({required this.errorMessage});

  @override
  bool operator ==(Object other) {
    return false;
  }

  @override
  List<Object> get props => [errorMessage];

}
