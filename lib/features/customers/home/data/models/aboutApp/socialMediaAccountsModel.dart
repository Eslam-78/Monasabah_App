import 'package:equatable/equatable.dart';

class SocialMediaAccountsModel extends Equatable{
  //TODO::here change the nam of privicyPolicy in front and back -end
  String image,name,url;

  SocialMediaAccountsModel({required this.image,required this.name,required this.url});

  factory SocialMediaAccountsModel.fromJson(Map<String,dynamic> appDetails){
    return SocialMediaAccountsModel(image:appDetails['image'],name: appDetails['name'],url:appDetails['url']);
  }

  SocialMediaAccountsModel fromJson(Map<String, dynamic> json){
    return SocialMediaAccountsModel.fromJson(json);
  }



  factory SocialMediaAccountsModel.init(){
    return SocialMediaAccountsModel(
        image: '',
        name: '',
        url: '',
    );
  }

  fromJsonList(List<dynamic> jsonList) {
    List<SocialMediaAccountsModel> data = [];
    jsonList.forEach((post) {
      data.add(SocialMediaAccountsModel.fromJson(post));
    });
    return data;
  }

  Map<String,dynamic>toJson()=>{'image':image,'name':name,'url':url,};

  @override
  List<Object?> get props => [image,name,url];
}