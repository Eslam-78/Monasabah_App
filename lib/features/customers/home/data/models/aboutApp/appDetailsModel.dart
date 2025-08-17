import 'package:equatable/equatable.dart';

class AboutAppModel extends Equatable{
  //TODO::here change the nam of privicyPolicy in front and back -end
  String image,teamName,email,phoneNumber,snapshot,privicyPolicy;
  
  AboutAppModel({required this.image,required this.teamName,required this.email,required this.phoneNumber,required this.snapshot,required this.privicyPolicy});

  factory AboutAppModel.fromJson(Map<String,dynamic> appDetails){
    return AboutAppModel(image:appDetails['image'],teamName: appDetails['teamName'],email:appDetails['email'],phoneNumber: appDetails['phoneNumber'],snapshot: appDetails['snapshot'],privicyPolicy:appDetails['privicyPolicy']);
  }

  AboutAppModel fromJson(Map<String, dynamic> json){
    return AboutAppModel.fromJson(json);
  }
  factory AboutAppModel.init(){
    return AboutAppModel(
      image: '0',
      teamName:'',
      email:'',
      phoneNumber: '',
      snapshot:'0.0',
      privicyPolicy:'0.0',

    );
  }

  fromJsonList(List<dynamic> jsonList) {
    List<AboutAppModel> data = [];
    jsonList.forEach((post) {
      data.add(AboutAppModel.fromJson(post));
    });
    return data;
  }
  Map<String,dynamic>toJson()=>{'image':image,'teamName':teamName,'email':email,'phoneNumber':phoneNumber,'snapshot':snapshot,'privicyPolicy':privicyPolicy};

  @override
  List<Object?> get props => [image,teamName,email,phoneNumber,snapshot,privicyPolicy];
}