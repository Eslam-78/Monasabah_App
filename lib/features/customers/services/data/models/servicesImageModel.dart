import 'package:equatable/equatable.dart';

class ServicesImagesModel extends Equatable{
  String image;
  int id;

  ServicesImagesModel({required this.id,required this.image});

  factory ServicesImagesModel.fromJson(Map<String,dynamic> serviceImage){
    return ServicesImagesModel(id:serviceImage['id'],image: serviceImage['image']);
  }

  ServicesImagesModel fromJson(Map<String, dynamic> json){
    return ServicesImagesModel.fromJson(json);
  }

  factory ServicesImagesModel.init(){
    return ServicesImagesModel(
      id: 0,
      image:'',

  );
  }

  fromJsonList(List<dynamic> jsonList) {
    List<ServicesImagesModel> data = [];
    jsonList.forEach((post) {
      data.add(ServicesImagesModel.fromJson(post));
    });
    return data;
  }


  Map<String,dynamic>toJson()=>{'id':id,'image':image};

  @override
  List<Object?> get props => [id,image];
}