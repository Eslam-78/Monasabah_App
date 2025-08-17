import 'package:equatable/equatable.dart';

class CategoriesModel extends Equatable{
  String categoryName,categoryImage;
  int id;

  CategoriesModel({required this.categoryName,required this.categoryImage,required this.id});

  factory CategoriesModel.fromJson(Map<String,dynamic> category){
    return CategoriesModel(id:category['id'],categoryName: category['categoryName'],categoryImage:category['categoryImage'],);
  }

  CategoriesModel fromJson(Map<String, dynamic> json){
    return CategoriesModel.fromJson(json);
  }



  factory CategoriesModel.init(){
    return CategoriesModel(
      id: 0,
      categoryName: '',
      categoryImage: '',

    );
  }

  fromJsonList(List<dynamic> jsonList) {
    List<CategoriesModel> data = [];
    jsonList.forEach((post) {
      data.add(CategoriesModel.fromJson(post));
    });
    return data;
  }


  Map<String,dynamic>toJson()=>{'id':id,'categoryName':categoryName,'categoryImage':categoryImage,};

  @override
  List<Object?> get props => [id,categoryName,categoryImage];
}