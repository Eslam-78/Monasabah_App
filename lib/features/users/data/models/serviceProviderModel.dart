class ServiceProviderModel{
  late int id;
  late String email,managerName,phoneNumber,image,token;

  ServiceProviderModel({required this.id,required this.email,required this.managerName,required this.phoneNumber, required this.image, required this.token});


  factory ServiceProviderModel.fromJson(Map<String,dynamic> serviceProvider){
      return ServiceProviderModel(id: serviceProvider['id'],email:serviceProvider['email'],managerName: serviceProvider['managerName'],phoneNumber: serviceProvider['phoneNumber'],image:serviceProvider['image'],token:serviceProvider['token']);
  }

  ServiceProviderModel fromJson(Map<String, dynamic> json) {
    return ServiceProviderModel.fromJson(json);
  }
  factory ServiceProviderModel.init(){
    return ServiceProviderModel(
      id: 0,
      email: '',
      managerName: '',
      phoneNumber: '',
      image: '',
      token: '',
    );
  }

  Map<String,dynamic>toJson()=>{'id':id,'email':email,'managerName':managerName,'phoneNumber':phoneNumber,'image':image,'token':token};

}