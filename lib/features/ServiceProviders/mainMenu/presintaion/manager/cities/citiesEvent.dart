import 'package:equatable/equatable.dart';

abstract class CitiesEvent extends Equatable{
  const CitiesEvent();
}

class GetCities extends CitiesEvent {
  final String token;

  GetCities({
    required this.token,
  });

  @override
  List<Object> get props => [token];
}