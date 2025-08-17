import 'package:equatable/equatable.dart';

class ServicesModel extends Equatable{
  dynamic id,address_id,city_id,section_id,
      name,phoneNumber,image,sectionName,
      description,address,price,discount,
      scale,lat,long,city,abroval,facebook,
      instagram,twitter,youtube;

  //TODO::here add the required for token and id
  ServicesModel({required this.id,required this.section_id,required this.city_id,this.address_id,
    required this.sectionName,required this.description,required this.name,required this.phoneNumber,
    required this.price,required this.scale,required this.address,required this.image,
    required this.city,this.discount='',required this.long,
    required this.lat,required this.abroval,required this.facebook,required this.instagram,required this.twitter,required this.youtube});

  factory ServicesModel.fromJson(Map<String,dynamic> service){
    return ServicesModel(id:service['id'],section_id: service['section_id'],
        city_id: service['cities_id'],address_id:service['address_id'],sectionName: service['sectionName'],
        description: service['description'],name: service['name'],image:service['image'],
        phoneNumber:service['phoneNumber'],price: service['price'],
        discount: service['discount'],scale: service['scale'],address: service['address'],
        city: service['city'],lat: service['lat'],long: service['long'],abroval:service['abroval'],
      facebook: service['facebook'],instagram: service['instagram'],twitter: service['twitter'],youtube: service['youtube'],
    );
  }

  ServicesModel fromJson(Map<String, dynamic> json){
    return ServicesModel.fromJson(json);
  }

  factory ServicesModel.init(){
    return ServicesModel(
      id: 0,
      address_id:0,
      section_id: 0,
      city_id: 0,
      sectionName:'',
      description:  '',
      name: '',
      image:'',
      phoneNumber: '',
      price: 0,
      discount: 0,
      scale: 0,
      long: 0.0,
      lat: 0.0,
      city: '',
      address: '',
      abroval: 0,
      facebook: '',
      instagram: '',
      twitter: '',
      youtube: ''
    );
  }

  fromJsonList(List<dynamic> jsonList) {
    List<ServicesModel> data = [];
    jsonList.forEach((post) {
      data.add(ServicesModel.fromJson(post));
    });
    return data;
  }


  Map<String,dynamic>toJson()=>{
    'id':id,'section_id':section_id,'cities_id':city_id,
    'address_id':address_id,'sectionName':sectionName,
    'description':description,'address':address,'name':name,'image':image,
    'phoneNumber':phoneNumber,'price':price,'discount':discount,'scale':scale,
    'lat':lat,'long':long,'city':city,'abroval':abroval,
    'facebook':facebook,'instagram':instagram,'twitter':twitter,'youtube':youtube};

  @override
  List<Object?> get props => [id,address_id,sectionName,description,address,name,image,phoneNumber,price,discount,scale,lat,long,city,abroval,facebook,instagram,twitter,youtube];
}