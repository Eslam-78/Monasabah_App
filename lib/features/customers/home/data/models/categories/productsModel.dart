import 'package:equatable/equatable.dart';

class ProductsModel extends Equatable{

  //TODO:: change the name to name in front and back end

  //TODO::here change the amount to quantity
  dynamic name,unit,Image;
  int id,category_id,unitPrice,quantity,totalPrice;

  ProductsModel({required this.id,required this.category_id,required this.name,required this.unit,required this.unitPrice,required this.Image,this.quantity=1,this.totalPrice=0});

  factory ProductsModel.fromJson(Map<String,dynamic> subCategory){
    return ProductsModel(id:subCategory['id'],category_id:subCategory['category_id'],name: subCategory['name'],unit: subCategory['unit'],unitPrice: subCategory['unitPrice'],Image:subCategory['Image'] );
  }

  ProductsModel fromJson(Map<String, dynamic> json){
    return ProductsModel.fromJson(json);
  }



  factory ProductsModel.init(){
    return ProductsModel(
      id: 0,
      category_id: 0,
      name: '',
      unit: '',
      unitPrice: 0,
        Image: '',
      totalPrice: 0,
      quantity: 0
    );
  }

  fromJsonList(List<dynamic> jsonList) {
    List<ProductsModel> data = [];
    jsonList.forEach((post) {
      data.add(ProductsModel.fromJson(post));
    });
    return data;
  }


  Map<String,dynamic>toJson()=>{'id':id,'category_id':category_id,'name':name,'unit':unit,'unitPrice':unitPrice,'Image':Image,'totalPrice':totalPrice,'amount':quantity};

  @override
  List<Object?> get props => [id,category_id,name,unit,unitPrice,Image,totalPrice,quantity];
}