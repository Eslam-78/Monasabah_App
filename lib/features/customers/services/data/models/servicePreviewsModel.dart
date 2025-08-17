import 'package:equatable/equatable.dart';

class ServicePreviewsModel extends Equatable{
  //TODO::here change the nam of userName in front and back -end
  dynamic id,customer_id,created_at,preview,userName,image;

  ServicePreviewsModel({required this.id,required this.customer_id,required this.created_at,required this.preview,required this.userName,required this.image});

  factory ServicePreviewsModel.fromJson(Map<String,dynamic> servicePreview){
    return ServicePreviewsModel(id:servicePreview['id'],customer_id: servicePreview['customer_id'],created_at:servicePreview['created_at'],preview: servicePreview['preview'],userName:servicePreview['userName'],image: servicePreview['image']);
  }

  ServicePreviewsModel fromJson(Map<String, dynamic> json){
    return ServicePreviewsModel.fromJson(json);
  }
  factory ServicePreviewsModel.init(){
    return ServicePreviewsModel(
      id: '0',
      customer_id:'',
      created_at:'0.0',
      preview: '',
      userName:'',
      image: ''
    );
  }

  fromJsonList(List<dynamic> jsonList) {
    List<ServicePreviewsModel> data = [];
    jsonList.forEach((post) {
      data.add(ServicePreviewsModel.fromJson(post));
    });
    return data;
  }
  Map<String,dynamic>toJson()=>{'id':id,'customer_id':customer_id,'created_at':created_at,'preview':preview,'userName':userName,'image':image};

  @override
  List<Object?> get props => [id,customer_id,created_at,preview,userName,image];
}