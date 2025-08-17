import 'package:equatable/equatable.dart';

abstract class MainMenuEvent extends Equatable{
  const MainMenuEvent();
}

class GetMainMenuSections extends MainMenuEvent {
  final String token;

  GetMainMenuSections({
    required this.token,
  });

  @override
  List<Object> get props => [token];
}

class GetMainMenuMostBookedServices extends MainMenuEvent {
  final String token;

  GetMainMenuMostBookedServices({
    required this.token,
  });

  @override
  List<Object> get props => [token];
}

class GetMainMenuMostRatedServices extends MainMenuEvent {
  final String token;

  GetMainMenuMostRatedServices({
    required this.token,
  });

  @override
  List<Object> get props => [token];
}