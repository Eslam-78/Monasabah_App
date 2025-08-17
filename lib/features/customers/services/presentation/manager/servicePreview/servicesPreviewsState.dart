import 'package:equatable/equatable.dart';
import 'package:monasbah/features/customers/services/data/models/servicePreviewsModel.dart';
import 'package:monasbah/features/customers/services/data/models/servicesImageModel.dart';

abstract class ServicesPreviewsState extends Equatable {
  const ServicesPreviewsState();
}

///common
class ServicesPreviewInitial extends ServicesPreviewsState {
  @override
  List<Object?> get props => [];
}

class GetServicesPreviewsLoading extends ServicesPreviewsState {
  @override
  List<Object?> get props => [];
}

class GetServicesPreviewsLoaded extends ServicesPreviewsState {
  final List<ServicePreviewsModel> servicesPreviewsModel;

  GetServicesPreviewsLoaded({required this.servicesPreviewsModel});

  @override
  List<Object> get props => [servicesPreviewsModel];
}

class AddServicePreviewLoaded extends ServicesPreviewsState {
  final String message;

  AddServicePreviewLoaded({required this.message});

  @override
  List<Object?> get props => [message];
}

class DeleteServicePreviewLoaded extends ServicesPreviewsState {
  final String message;

  DeleteServicePreviewLoaded({required this.message});

  @override
  List<Object?> get props => [message];
}

class ServicesPreviewsError extends ServicesPreviewsState {
  final String errorMessage;
  ServicesPreviewsError({required this.errorMessage});

  @override
  bool operator ==(Object other) {
    return false;
  }

  @override
  List<Object> get props => [errorMessage];
}
