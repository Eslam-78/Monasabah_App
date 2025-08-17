import 'package:equatable/equatable.dart';
import 'package:monasbah/features/customers/home/data/models/mainMenuSectionsModel.dart';
import 'package:monasbah/features/customers/services/data/models/servicesModel.dart';

abstract class MainMenuState extends Equatable{
  const MainMenuState();
}

class MainMenuInitial extends MainMenuState{
  @override
  List<Object?> get props => [];

}

class MainMenuLoading extends MainMenuState{
  @override
  List<Object?> get props => [];

}

class GetMainMenuSectionsLoaded extends MainMenuState{
  final List<MainMenuSectionsModel>  mainMenuSectionsModel;

  GetMainMenuSectionsLoaded({required this.mainMenuSectionsModel});

  @override
  List<Object> get props => [mainMenuSectionsModel];
}

class GetMainMenuMostBookedServiceLoaded extends MainMenuState{
  final List<ServicesModel>  servicesModel;

  GetMainMenuMostBookedServiceLoaded({required this.servicesModel});

  @override
  List<Object> get props => [servicesModel];
}

class GetMainMenuMostRatedServiceLoaded extends MainMenuState{
  final List<ServicesModel>  servicesModel;

  GetMainMenuMostRatedServiceLoaded({required this.servicesModel});

  @override
  List<Object> get props => [servicesModel];
}

class MainMenuError extends MainMenuState {

  final String errorMessage;
  MainMenuError({required this.errorMessage});

  @override
  bool operator ==(Object other) {
    return false;
  }

  @override
  List<Object> get props => [errorMessage];

}
