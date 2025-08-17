import 'package:equatable/equatable.dart';
import 'package:monasbah/features/customers/services/data/models/servicePreviewsModel.dart';

abstract class ServicesPreviewsEvent extends Equatable {
  const ServicesPreviewsEvent();
}

class GetServicePreview extends ServicesPreviewsEvent {
  final String service_id;
  GetServicePreview({
    required this.service_id,
  });

  @override
  List<Object> get props => [service_id];
}

class AddServicePreview extends ServicesPreviewsEvent {
  final String service_id, api_token, preview;
  AddServicePreview({
    required this.service_id,
    required this.api_token,
    required this.preview,
  });

  @override
  List<Object> get props => [service_id, api_token, preview];
}

class DeleteServicePreview extends ServicesPreviewsEvent {
  final String service_id, api_token;
  DeleteServicePreview({
    required this.service_id,
    required this.api_token,
  });

  @override
  List<Object> get props => [service_id, api_token];
}
