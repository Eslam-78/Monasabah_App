import 'package:equatable/equatable.dart';

abstract class AddsEvent extends Equatable{
  const AddsEvent();
}

class GetAllAdds extends AddsEvent {
  @override
  List<Object> get props => [];
}

class GetSectionAdds extends AddsEvent {
 final String sections_id;

  const GetSectionAdds({required this.sections_id});

  @override
  List<Object> get props => [];
}