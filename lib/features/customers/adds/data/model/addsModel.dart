import 'package:equatable/equatable.dart';

class AddsModel extends Equatable{
  String description,image,url;


  AddsModel({required this.description,required this.image,required this.url});

  factory AddsModel.fromJson(Map<String,dynamic> category){
    return AddsModel(description:category['description'],image: category['image'],url:category['url'],);
  }

  AddsModel fromJson(Map<String, dynamic> json){
    return AddsModel.fromJson(json);
  }



  factory AddsModel.init(){
    return AddsModel(
      description: '0',
      image: '',
      url: '',

    );
  }

  fromJsonList(List<dynamic> jsonList) {
    List<AddsModel> data = [];
    jsonList.forEach((post) {
      data.add(AddsModel.fromJson(post));
    });
    return data;
  }


  Map<String,dynamic>toJson()=>{'description':description,'image':image,'url':url,};

  @override
  List<Object?> get props => [description,image,url];
}