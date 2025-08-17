import 'package:equatable/equatable.dart';

class ServiceRatingModel extends Equatable{
  dynamic rating,numberOfRaters;

  ServiceRatingModel({required this.rating,required this.numberOfRaters});

  factory ServiceRatingModel.fromJson(Map<String,dynamic> serviceRating){
    return ServiceRatingModel(rating:serviceRating['rating'],numberOfRaters: serviceRating['numberOfRaters']);
  }

  ServiceRatingModel fromJson(Map<String, dynamic> json){
    return ServiceRatingModel.fromJson(json);
  }
  factory ServiceRatingModel.init(){
    return ServiceRatingModel(
        rating: '0',
        numberOfRaters:'0',
    );
  }

  fromJsonList(List<dynamic> jsonList) {
    List<ServiceRatingModel> data = [];
    jsonList.forEach((post) {
      data.add(ServiceRatingModel.fromJson(post));
    });
    return data;
  }
  Map<String,dynamic>toJson()=>{'rating':rating,'numberOfRaters':numberOfRaters};

  @override
  List<Object?> get props => [rating,numberOfRaters];
}