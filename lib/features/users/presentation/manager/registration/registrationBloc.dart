import 'package:bloc/bloc.dart';
import 'package:monasbah/dataProviders/error/failures.dart';
import 'package:monasbah/features/users/data/models/customerModel.dart';
import 'package:monasbah/features/users/data/repositories/registrationRepository.dart';
import 'package:monasbah/features/users/presentation/manager/registration/registrationEvent.dart';
import 'package:monasbah/features/users/presentation/manager/registration/registrationState.dart';

class RegistrationBloc extends Bloc<RegistrationEvent,RegistrationState>{
  final RegistrationRepository repository;

  RegistrationBloc({required this.repository})
      : assert(repository != null),
        super(RegisterInitial());

  @override
  Stream<RegistrationState> mapEventToState(RegistrationEvent event) async*{
    print('map terned on ');
    if(event is SignupRequest){
      final failureOrData =await repository.signup(signUpModel: event.signUpModel);
      yield RegisterLoading();

      yield* failureOrData.fold(
            (failure) async* {
              print('yield error $failure');

              yield RegisterError(errorMessage: mapFailureToMessage(failure));
        },
            (data) async* {
              print('yield $data');
          yield RegisterLoaded(message: data);
        },
      );
    }

    if(event is LoginRequest){
      print('login event');
      yield RegisterLoading();
      final failureOrData=await repository.sendLoginRequest(loginModel: event.loginModel);

      yield* failureOrData.fold(
              (failure)async*{
            yield RegisterError(errorMessage: mapFailureToMessage(failure));
          },
              (data)async*{

                print('yield $data,,,,,,,,,,,,');
            yield RegisterLoaded(message: "تم تسجيل الدخول بنجاح");
          }
      );
    }

    if(event is SendConfirmCodeEvent){
      print('login event');
      yield RegisterLoading();
      final failureOrData=await repository.sendConfirmCode(email: event.email);

      yield* failureOrData.fold(
              (failure)async*{
            yield RegisterError(errorMessage: mapFailureToMessage(failure));
          },
              (data)async*{

                print('yield $data,,,,,,,,,,,,');
            yield RegisterLoaded(message:data);
          }
      );
    }

    if(event is CheckConfirmCodeEvent){
      print('login event');
      yield RegisterLoading();
      final failureOrData=await repository.checkConfirmCode(email: event.email,confirmCode: event.confirmCode,userBrand: event.userBrand);

      yield* failureOrData.fold(
              (failure)async*{
            yield RegisterError(errorMessage: mapFailureToMessage(failure));
          },
              (data)async*{

                print('yield $data,,,,,,,,,,,,');
            yield RegisterLoaded(message: data);
          }
      );
    }

    if(event is EditPasswordEvent){
      print('login event');
      yield RegisterLoading();
      final failureOrData=await repository.editPassword(email: event.email,password: event.password,userBrand: event.userBrand);

      yield* failureOrData.fold(
              (failure)async*{
            yield RegisterError(errorMessage: mapFailureToMessage(failure));
          },
              (data)async*{

                print('yield $data,,,,,,,,,,,,');
            yield RegisterLoaded(message: data);
          }
      );
    }

    if(event is LogoutEvent){
      print('login event');
      yield RegisterLoading();
      final failureOrData=await repository.logout(token: event.token);

      yield* failureOrData.fold(
              (failure)async*{
            yield RegisterError(errorMessage: mapFailureToMessage(failure));
          },
              (data)async*{

                print('yield $data,,,,,,,,,,,,');
            yield RegisterLoaded(message: data);
          }
      );
    }
  }

}