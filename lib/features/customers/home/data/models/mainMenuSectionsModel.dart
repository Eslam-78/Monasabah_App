import 'package:equatable/equatable.dart';

class MainMenuSectionsModel extends Equatable{
  String sectionName,sectionImage;
  int id;

  MainMenuSectionsModel({required this.sectionName,required this.sectionImage,required this.id});

  factory MainMenuSectionsModel.fromJson(Map<String,dynamic> section){
    return MainMenuSectionsModel(id:section['id'],sectionName: section['sectionName'],sectionImage:section['sectionImage'],);
  }

  MainMenuSectionsModel fromJson(Map<String, dynamic> json) {
    return MainMenuSectionsModel.fromJson(json);
  }



  factory MainMenuSectionsModel.init(){
    return MainMenuSectionsModel(
      id: 0,
      sectionName: '',
      sectionImage: '',

    );
  }

  fromJsonList(List<dynamic> jsonList) {
    List<MainMenuSectionsModel> data = [];
    // ignore: non_constant_identifier_names
    jsonList.forEach((post) {
      data.add(MainMenuSectionsModel.fromJson(post));
    });
    return data;
  }


  Map<String,dynamic>toJson()=>{'id':id,'sectionName':sectionName,'sectionImage':sectionImage,};

  @override
  List<Object?> get props => [id,sectionName,sectionImage];
}