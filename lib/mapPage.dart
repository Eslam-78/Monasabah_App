import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';




class MapPage extends StatefulWidget {
  String lat, long;
  String locationName,locationDescription;


  MapPage({required this.lat, required this.long,this.locationName='locationName',this.locationDescription='locationDescription'});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  var marker = HashSet<Marker>();
  Completer<GoogleMapController> _controller = Completer();

  bool requestPending = false;
  @override
  Widget build(BuildContext context) {
    print(widget.lat.runtimeType);
    print(widget.lat);
    print(widget.long.runtimeType);
    print(widget.long);

    return SafeArea(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          /// start google map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(double.parse(widget.lat), double.parse(widget.long)),
              zoom: 28.4746,
            ),
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              setState(() {
                marker.add(
                  Marker(
                    markerId: MarkerId('1'),
                    position: LatLng(double.parse(widget.lat), double.parse(widget.long)),
                    infoWindow: InfoWindow(
                      title:widget.locationName,
                      snippet: widget.locationDescription
                    )
                  ),
                );
              });
              _controller.complete(controller);
            },
            markers: marker,
          ),
        ],
      ),
    );
  }
}
