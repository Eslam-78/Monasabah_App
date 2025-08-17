import 'package:equatable/equatable.dart';

class ServiceAddressModel extends Equatable{
  dynamic address,description,long,lat;

  ServiceAddressModel({required this.address,required this.description,required this.long,required this.lat});

  factory ServiceAddressModel.fromJson(Map<String,dynamic> address){
    return ServiceAddressModel(address: address['address'],description: address['description'],long:address['long'],lat: address['lat']);
  }

  ServiceAddressModel fromJson(Map<String, dynamic> json){
    return ServiceAddressModel.fromJson(json);
  }

  fromJsonList(List<dynamic> jsonList) {
    List<ServiceAddressModel> data = [];
    jsonList.forEach((post) {
      data.add(ServiceAddressModel.fromJson(post));
    });
    return data;
  }


  factory ServiceAddressModel.init(){
    return ServiceAddressModel(
        address: '',
        description: '',
        long: '',
        lat: '',

    );
  }



  Map<String,dynamic>toJson()=>{'address':address,'description':description,'long':long,'lat':lat};

  @override
  List<Object?> get props => [address,description,long,lat];
}