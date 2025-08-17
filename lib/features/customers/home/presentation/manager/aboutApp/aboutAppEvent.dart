import 'package:equatable/equatable.dart';

abstract class AboutAppEvent extends Equatable{
  const AboutAppEvent();
}

class GetAppDetails extends AboutAppEvent {
  @override
  List<Object> get props => [];
}

class GetSocialMediaAccounts extends AboutAppEvent {
  @override
  List<Object> get props => [];
}