import 'package:equatable/equatable.dart';

class ReservationReportModel extends Equatable {

//TODO::here change the nam of userName in front and back -end
dynamic id,customer_id,serviceName,phoneNumber,status,cancelReason,service_reservation_price,userName,image;
dynamic reserveDate;
  ReservationReportModel({
    required this.id,required this.customer_id,required this.serviceName,required this.reserveDate,required this.status,required this.userName,required this.phoneNumber,required this.service_reservation_price,required this.image,required this.cancelReason
  });

  factory ReservationReportModel.fromJson(Map<String, dynamic> reservationDetails) {
    return ReservationReportModel(

        id:reservationDetails['id'],
        customer_id: reservationDetails['customer_id'],
        serviceName: reservationDetails['serviceName'],
        reserveDate:reservationDetails['reserveDate'],
        status: reservationDetails['status'],
        userName:reservationDetails['userName'],
        phoneNumber:reservationDetails['phoneNumber'],
        image: reservationDetails['image'],
        cancelReason: reservationDetails['cancelReason'],
        service_reservation_price: reservationDetails['service_reservation_price']
    );
  }
ReservationReportModel fromJson(Map<String, dynamic> json){
  return ReservationReportModel.fromJson(json);
}
factory ReservationReportModel.init(){
  return ReservationReportModel(
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
    List<ReservationReportModel> data = [];
    jsonList.forEach((post) {
      data.add(ReservationReportModel.fromJson(post));
    });
    return data;
  }

Map<String,dynamic>toJson()=>{'id':id,
  'customer_id':customer_id,
  'serviceName':serviceName,
  'reserveDate':reserveDate,
  'status':status,
  'userName':userName,
  'phoneNumber':phoneNumber,
  'image':image,
  'cancelReason':cancelReason,
  'service_reservation_price':service_reservation_price};

@override
List<Object?> get props => [id,customer_id,serviceName,reserveDate,status,userName,phoneNumber,image,cancelReason,service_reservation_price];
}