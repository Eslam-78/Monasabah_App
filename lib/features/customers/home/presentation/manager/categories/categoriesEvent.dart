import 'package:equatable/equatable.dart';

abstract class CategoriesEvent extends Equatable{
  const CategoriesEvent();
}

class GetCategoriesEvent extends CategoriesEvent {
  final String token;

  GetCategoriesEvent({
    required this.token,
  });

  @override
  List<Object> get props => [token];
}