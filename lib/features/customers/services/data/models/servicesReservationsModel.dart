import 'package:equatable/equatable.dart';

class ServicesReservationsModel extends Equatable{
  //TODO::here change the nam of userName in front and back -end
  dynamic id,customer_id,serviceName,phoneNumber,status,cancelReason,service_reservation_price,userName,image;
  dynamic reserveDate;
  ServicesReservationsModel({required this.id,required this.customer_id,required this.serviceName,required this.reserveDate,required this.status,required this.userName,required this.phoneNumber,required this.service_reservation_price,required this.image,required this.cancelReason});

  factory ServicesReservationsModel.fromJson(Map<String,dynamic> reservationDetails){
    return ServicesReservationsModel(id:reservationDetails['id'],customer_id: reservationDetails['customer_id'],serviceName: reservationDetails['serviceName'],reserveDate:reservationDetails['reserveDate'],status: reservationDetails['status'],userName:reservationDetails['userName'],phoneNumber:reservationDetails['phoneNumber'],image: reservationDetails['image'],cancelReason: reservationDetails['cancelReason'],service_reservation_price: reservationDetails['service_reservation_price']);
  }

  ServicesReservationsModel fromJson(Map<String, dynamic> json){
    return ServicesReservationsModel.fromJson(json);
  }
  factory ServicesReservationsModel.init(){
    return ServicesReservationsModel(
        id: 0,
        customer_id:'',
        serviceName: '',
        reserveDate:DateTime.now(),
        status: 0,
        userName:'',
        phoneNumber:'',
        image: '',
      cancelReason: '',
        service_reservation_price:0
    );
  }

  fromJsonList(List<dynamic> jsonList) {
    List<ServicesReservationsModel> data = [];
    jsonList.forEach((post) {
      data.add(ServicesReservationsModel.fromJson(post));
    });
    return data;
  }
  Map<String,dynamic>toJson()=>{'id':id,'customer_id':customer_id,'serviceName':serviceName,'reserveDate':reserveDate,'status':status,'userName':userName,'phoneNumber':phoneNumber,'image':image,'cancelReason':cancelReason,'service_reservation_price':service_reservation_price};

  @override
  List<Object?> get props => [id,customer_id,serviceName,reserveDate,status,userName,phoneNumber,image,cancelReason,service_reservation_price];
}