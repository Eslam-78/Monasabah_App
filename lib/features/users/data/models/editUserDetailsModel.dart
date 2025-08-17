class EditUserDetailsModel{
  late String userName,managerName,image,phoneNumber,email,password,userBrand,token,imageChanged;

  EditUserDetailsModel({this.userName='',this.managerName='',required this.image,required this.phoneNumber,required this.email,required this.password,required this.userBrand,required this.token,required this.imageChanged});

  Map<String,dynamic>toJson()=>{'userName':userName,'managerName':managerName,'image':image,'phoneNumber':phoneNumber,'email':email,'password':password,'userBrand':userBrand,'api_token':token,'imageChanged':imageChanged};

/*  factory CustomerSignUpModel.fromJson(Map<String,dynamic> customerSignUpDate){
      return CustomerSignUpModel(userName:customerSignUpDate['username'],phoneNumber: customerSignUpDate['phoneNumber'],password: customerSignUpDate['password'],confirmPassword: customerSignUpDate['confirmPassword']);
  }*/
}