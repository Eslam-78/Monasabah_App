import 'package:equatable/equatable.dart';

class CustomerLocationsModel extends Equatable{
  dynamic locationName,description,long,lat,token;
  int id,customer_id;

  CustomerLocationsModel({required this.customer_id,required this.locationName,required this.description,required this.long,required this.lat,required this.id,required this.token});

  factory CustomerLocationsModel.fromJson(Map<String,dynamic> location){
    return CustomerLocationsModel(id:location['id'],customer_id: location['customer_id'],locationName: location['locationName'],description: location['description'],long:location['long'],lat: location['lat'],token: location['api_token']);
  }

  CustomerLocationsModel fromJson(Map<String, dynamic> json){
    return CustomerLocationsModel.fromJson(json);
  }

  fromJsonList(List<dynamic> jsonList) {
    List<CustomerLocationsModel> data = [];
    jsonList.forEach((post) {
      data.add(CustomerLocationsModel.fromJson(post));
    });
    return data;
  }


  factory CustomerLocationsModel.init(){
    return CustomerLocationsModel(
      id: 0,
      customer_id:0,
      locationName: '',
      description: '',
      long: '',
      lat: '',
      token: ''

    );
  }



  Map<String,dynamic>toJson()=>{'customer_id':customer_id,'locationName':locationName,'description':description,'long':long,'lat':lat,'api_token':token};

  @override
  List<Object?> get props => [id,customer_id,locationName,description,long,lat,token];
}