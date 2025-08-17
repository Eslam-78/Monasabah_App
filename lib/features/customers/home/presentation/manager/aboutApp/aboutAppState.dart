import 'package:equatable/equatable.dart';
import 'package:monasbah/features/customers/home/data/models/aboutApp/appDetailsModel.dart';
import 'package:monasbah/features/customers/home/data/models/aboutApp/socialMediaAccountsModel.dart';
import 'package:monasbah/features/customers/home/data/models/categories/categoriesModel.dart';
import 'package:monasbah/features/customers/home/data/models/mainMenuSectionsModel.dart';

abstract class AboutAppState extends Equatable{
  const AboutAppState();
}

class GetAboutAppInitial extends AboutAppState{
  @override
  List<Object?> get props => [];

}

class GetAboutAppLoading extends AboutAppState{
  @override
  List<Object?> get props => [];

}

class GetAboutAppError extends AboutAppState {

  final String errorMessage;
  GetAboutAppError({required this.errorMessage});

  @override
  bool operator ==(Object other) {
    return false;
  }

  @override
  List<Object> get props => [errorMessage];

}


class GetAppDetailsLoaded extends AboutAppState{
  final List<AboutAppModel>  aboutAppModel;

  GetAppDetailsLoaded({required this.aboutAppModel});

  @override
  List<Object> get props => [aboutAppModel];
}

class GetSocialMediaAccountsLoaded extends AboutAppState{
  final List<SocialMediaAccountsModel>  socialMediaAccountsModel;

  GetSocialMediaAccountsLoaded({required this.socialMediaAccountsModel});

  @override
  List<Object> get props => [socialMediaAccountsModel];
}

