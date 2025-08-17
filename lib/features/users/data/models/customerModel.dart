class CustomerModel{
  int id;
  String userName,phoneNumber,email,image,token;

  CustomerModel({required this.id,required this.userName,required this.phoneNumber,required this.email,required this.image,required this.token});

  factory CustomerModel.fromJson(Map<String,dynamic> customer){
      return CustomerModel(id:customer['id'],token:customer['token'],phoneNumber: customer['phoneNumber'],email: customer['email'],image:customer['image'],userName:customer['userName'],);
  }

  CustomerModel fromJson(Map<String, dynamic> json) {
    return CustomerModel.fromJson(json);
  }

  factory CustomerModel.init(){
    return CustomerModel(
      id: 0,
      token: '',
      phoneNumber: '',
      image: '',
      userName: '',
      email: ''
    );
  }

  Map<String,dynamic>toJson()=>{'id':id,'token':token,'phoneNumber':phoneNumber,'email':email,'image':image,'userName':userName};

}