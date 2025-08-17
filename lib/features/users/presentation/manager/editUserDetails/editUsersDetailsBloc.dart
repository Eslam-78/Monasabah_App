import 'package:bloc/bloc.dart';
import 'package:monasbah/dataProviders/error/failures.dart';
import 'package:monasbah/features/users/data/repositories/editUserDetailsRepository.dart';
import 'editUsersDetailsEvent.dart';
import 'editUsersDetailsState.dart';

class EditUserDetailsBloc extends Bloc<EditUserDetailsEvent,EditUserDetailsState>{
  final EditUserDetailsRepository repository;

  EditUserDetailsBloc({required this.repository})
      : assert(repository != null),
        super(EditUserDetailsInitial());

  @override
  Stream<EditUserDetailsState> mapEventToState(EditUserDetailsEvent event) async*{
    
    if(event is EditUserDetails){
      final failureOrData =await repository.editUserDetails(editUserDetailsModel: event.editUserDetailsModel);
      yield EditUserDetailsLoading();

      yield* failureOrData.fold(
            (failure) async* {
              print('yield error $failure');

              yield EditUserDetailsError(errorMessage: mapFailureToMessage(failure));
        },
            (data) async* {
              print('yield $data');
          yield EditUserDetailsLoaded(message: 'تم التعديل بنجاح');
        },
      );
    }
    
  }

}