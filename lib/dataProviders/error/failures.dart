import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
 const Failure([List properties = const <dynamic>[]]);
}

// general failures
class UnexpectedFailure extends Failure{
  @override
  List<Object> get props => [];
}

class ServerFailure extends Failure{
  @override
  List<Object> get props => [];
}

class ExpireFailure extends Failure {
  @override
  List<Object> get props => [];
}

class UserExistsFailure extends Failure {
  @override
  List<Object> get props => [];
}

class CacheFailure extends Failure {
  @override
  List<Object> get props => [];
}

class NotFoundFailure extends Failure {
  @override
  List<Object> get props => [];
}

class ConnectionFailure extends Failure {
  @override
  List<Object> get props => [];
}

class InvalidFailure extends Failure {
  @override
  List<Object> get props => [];
}

class UniqueFailure extends Failure {
  @override
  List<Object> get props => [];
}

class ReceiveFailure extends Failure {
  @override
  List<Object> get props => [];
}

class PasswordFailure extends Failure {
  @override
  List<Object> get props => [];
}

class UnauthenticatedFailure extends Failure {
  @override
  List<Object> get props => [];
}

class BlockedFailure extends Failure {
  @override
  List<Object> get props => [];
}

String mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return 'عذراً لم نتمكن من الاتصال بالخادم';
    case CacheFailure:
      return 'لاتوجد بيانات حتى الان حاول الإتصال بالإنترنت';
    case ConnectionFailure:
      return 'لايوجد اتصال بالانترنت!';
    case NotFoundFailure:
      return 'لاتوجد أي بيانات في الوقت الحالي!';
    case InvalidFailure:
      return 'هناك خطا في البيانات المدخلة';
    case ExpireFailure:
      return 'انتهت صلاحية الكود';
    case UserExistsFailure:
      return 'لايوجد حساب بهذه البيانات! تأكد من البيانات.';
    case UniqueFailure:
      return 'قد يكون هذا الحساب موجود مسبقاً! \nحاول تغيير اسم المستخجم أو رقم الهاتف ';
    case PasswordFailure:
      return 'كلمة المرور غير صحيحة';
    case ReceiveFailure:
      return 'حدث خطأ اثناء استقبال البيانات';
    case UnauthenticatedFailure:
      return 'عذرا ! أنت غير مخول لهذه العملية قم بتسجيل الدخول اولا ثم محاولة مرة أخرى ';
    case BlockedFailure:
      return 'عذرا ! لقد تم حظر حسابك. يرجى التواصل مع المسؤول لإزالة الحظر';
    default:
      return 'عذراً حدث خطأ غير متوقع';
  }
}
