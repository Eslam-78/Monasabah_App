import 'package:equatable/equatable.dart';

class EditServiceModel extends Equatable {
  dynamic id,
      address_id,
      name,
      phoneNumber,
      image,
      imageChanged,
      section_id,
      description,
      address,
      price,
      discount,
      scale,
      lat,
      long,
      city_id,
      facebook,
      instagram,
      twitter,
      youtube,
      token;

  //TODO::here add the required for token and id
  EditServiceModel(
      {this.id,
      required this.address_id,
      required this.section_id,
      required this.description,
      required this.name,
      required this.phoneNumber,
      required this.price,
      required this.scale,
      required this.address,
      required this.image,
      required this.imageChanged,
      required this.city_id,
      this.discount = '',
      required this.long,
      required this.lat,
      required this.facebook,
      required this.instagram,
      required this.twitter,
      required this.youtube,
      required this.token});

  factory EditServiceModel.init() {
    return EditServiceModel(
        id: 0,
        address_id: 0,
        section_id: '',
        description: '',
        name: '',
        image: '',
        imageChanged: '',
        phoneNumber: '',
        price: 0,
        discount: 0,
        scale: 0,
        long: 0.0,
        lat: 0.0,
        city_id: '',
        address: '',
        facebook: '',
        instagram: '',
        twitter: '',
        youtube: '',
        token: '');
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'address_id': address_id,
        'section_id': section_id,
        'description': description,
        'address': address,
        'name': name,
        'image': image,
        'imageChanged': imageChanged,
        'phoneNumber': phoneNumber,
        'price': price,
        'discount': discount,
        'scale': scale,
        'lat': lat,
        'long': long,
        'cities_id': city_id,
        'facebook': facebook,
        'instagram': instagram,
        'twitter': twitter,
        'youtube': youtube,
        'api_token': token
      };

  @override
  List<Object?> get props => [
        id,
        address_id,
        section_id,
        description,
        address,
        name,
        image,
        imageChanged,
        phoneNumber,
        price,
        discount,
        scale,
        lat,
        long,
        city_id,
        facebook,
        instagram,
        twitter,
        youtube,
        token
      ];
}
