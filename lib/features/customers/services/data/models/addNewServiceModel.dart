import 'package:equatable/equatable.dart';

class AddNewServiceModel extends Equatable {
  dynamic section_id,
      name,
      phoneNumber,
      image,
      price,
      discount,
      scale,
      city_id,
      address,
      description,
      lat,
      long,
      facebook,
      instagram,
      twitter,
      youtube,
      token;

  //TODO::here add the required for token and id
  AddNewServiceModel(
      {required this.section_id,
      required this.name,
      required this.phoneNumber,
      required this.price,
      required this.scale,
      required this.image,
      this.discount = '',
      required this.address,
      required this.description,
      required this.city_id,
      required this.long,
      required this.lat,
      required this.facebook,
      required this.instagram,
      required this.twitter,
      required this.youtube,
      required this.token});

  factory AddNewServiceModel.fromJson(Map<String, dynamic> service) {
    return AddNewServiceModel(
        section_id: service['section_id'],
        city_id: service['cities_id'],
        description: service['description'],
        name: service['name'],
        image: service['image'],
        phoneNumber: service['phoneNumber'],
        price: service['price'],
        discount: service['discount'],
        scale: service['scale'],
        address: service['address'],
        lat: service['lat'],
        long: service['long'],
        facebook: service['facebook'],
        instagram: service['instagram'],
        youtube: service['youtube'],
        twitter: service['twitter'],
        token: service['token']);
  }

  AddNewServiceModel fromJson(Map<String, dynamic> json) {
    return AddNewServiceModel.fromJson(json);
  }

  fromJsonList(List<dynamic> jsonList) {
    List<AddNewServiceModel> data = [];
    jsonList.forEach((post) {
      data.add(AddNewServiceModel.fromJson(post));
    });
    return data;
  }

  factory AddNewServiceModel.init() {
    return AddNewServiceModel(
        section_id: 0,
        city_id: 0,
        description: '',
        name: '',
        image: '',
        phoneNumber: '',
        price: 0,
        discount: 0,
        scale: 0,
        long: 0.0,
        lat: 0.0,
        address: '',
        facebook: '',
        instagram: '',
        twitter: '',
        youtube: '',
        token: '');
  }

  Map<String, dynamic> toJson() => {
        'section_id': section_id,
        'cities_id': city_id,
        'description': description,
        'address': address,
        'name': name,
        'image': image,
        'phoneNumber': phoneNumber,
        'price': price,
        'discount': discount,
        'scale': scale,
        'lat': lat,
        'long': long,
        'facebook': facebook,
        'instagram': instagram,
        'twitter': twitter,
        'youtube': youtube,
        'api_token': token
      };

  @override
  List<Object?> get props => [
        description,
        address,
        name,
        image,
        phoneNumber,
        price,
        discount,
        scale,
        lat,
        facebook,
        instagram,
        twitter,
        youtube,
        long,
      ];
}
