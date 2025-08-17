import 'package:equatable/equatable.dart';
import 'package:monasbah/features/ServiceProviders/mainMenu/data/model/citiesModel.dart';

import '../../../data/model/citiesModel.dart';
import '../../../data/model/citiesModel.dart';

abstract class CitiesState extends Equatable{
  const CitiesState();
}

class GetCitiesInitial extends CitiesState{
  @override
  List<Object?> get props => [];

}

class GetCitiesLoading extends CitiesState{
  @override
  List<Object?> get props => [];

}

class GetCitiesLoaded extends CitiesState{
  final List<CitiesModel>  citiesModel;

  GetCitiesLoaded({required this.citiesModel});

  @override
  List<Object> get props => [CitiesModel];
}

class GetCitiesError extends CitiesState {

  final String errorMessage;
  GetCitiesError({required this.errorMessage});

  @override
  bool operator ==(Object other) {
    return false;
  }

  @override
  List<Object> get props => [errorMessage];

}
