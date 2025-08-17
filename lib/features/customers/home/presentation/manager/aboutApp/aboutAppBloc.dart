import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:monasbah/dataProviders/error/failures.dart';
import 'package:monasbah/features/customers/home/data/repositories/aboutAppRepository.dart';
import 'package:monasbah/features/customers/home/presentation/manager/aboutApp/aboutAppEvent.dart';
import 'package:monasbah/features/customers/home/presentation/manager/aboutApp/aboutAppState.dart';


class AboutAppBloc extends Bloc<AboutAppEvent,AboutAppState>{

  final AboutAppRepository repository;
  AboutAppBloc({required this.repository})
      : assert(repository != null),
        super(GetAboutAppInitial());

  @override
  Stream<AboutAppState> mapEventToState(AboutAppEvent event) async*{

    if(event is GetAppDetails){
      yield GetAboutAppLoading();
      final failureOrData = await repository.getAboutAppDetails();
      yield* failureOrData.fold(
            (failure) async* {
          log('yield is error');

          yield GetAboutAppError(errorMessage: mapFailureToMessage(failure));
        },
            (data) async* {
          log('yield is loaded');
          yield GetAppDetailsLoaded(aboutAppModel:data);
        },
      );
    }

    if(event is GetSocialMediaAccounts){
      yield GetAboutAppLoading();
      final failureOrData = await repository.getSocialMediaAccounts();
      yield* failureOrData.fold(
            (failure) async* {
          log('yield is error');

          yield GetAboutAppError(errorMessage: mapFailureToMessage(failure));
        },
            (data) async* {
          log('yield is loaded');
          yield GetSocialMediaAccountsLoaded(socialMediaAccountsModel:data);
        },
      );
    }
  }



}