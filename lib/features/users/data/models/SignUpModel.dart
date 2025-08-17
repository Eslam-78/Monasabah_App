class SignUpModel{
  late String userName,managerName,phoneNumber,email,password,userBrand;

  SignUpModel({required this.userName,this.managerName='',required this.phoneNumber,required this.email,required this.password,required this.userBrand});

  Map<String,dynamic>toJson()=>{'userName':userName,'managerName':managerName,'phoneNumber':phoneNumber,'email':email,'password':password,'userBrand':userBrand};

/*  factory CustomerSignUpModel.fromJson(Map<String,dynamic> customerSignUpDate){
      return CustomerSignUpModel(userName:customerSignUpDate['username'],phoneNumber: customerSignUpDate['phoneNumber'],password: customerSignUpDate['password'],confirmPassword: customerSignUpDate['confirmPassword']);
  }*/
}