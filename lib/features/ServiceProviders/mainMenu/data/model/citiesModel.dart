import 'package:equatable/equatable.dart';

class CitiesModel extends Equatable{
  String city;
  int id;

  CitiesModel({required this.city,required this.id});

  factory CitiesModel.fromJson(Map<String,dynamic> section){
    return CitiesModel(id:section['id'],city: section['city']);
  }

  CitiesModel fromJson(Map<String, dynamic> json) {
    return CitiesModel.fromJson(json);
  }



  factory CitiesModel.init(){
    return CitiesModel(
      id: 0,
      city: '',
    );
  }

  fromJsonList(List<dynamic> jsonList) {
    List<CitiesModel> data = [];
    // ignore: non_constant_identifier_names
    jsonList.forEach((post) {
      data.add(CitiesModel.fromJson(post));
    });
    return data;
  }


  Map<String,dynamic>toJson()=>{'id':id,'city':city,};

  @override
  List<Object?> get props => [id,city];
}