import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:diagnostics_patient/Models/lab_model.dart';
import 'package:diagnostics_patient/componant/custome_appBar.dart';
import 'package:diagnostics_patient/controller/add_address_controller.dart';
import 'package:diagnostics_patient/utils/api.dart';

class MapScreen extends StatefulWidget {
  LabModelList? labModelList;
  MapScreen({super.key, this.labModelList});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;

  // late double _originLatitude = 26.912434, _originLongitude = 75.787270;
  // late double _destLatitude = 26.88843, _destLongitude = 75.83447;

  late double _originLatitude = Get.find<AddAddressController>().center!.latitude, _originLongitude = Get.find<AddAddressController>().center!.longitude; // Bardoli
  late double _destLatitude = widget.labModelList!.location!.lat!, _destLongitude = widget.labModelList!.location!.lng!;

  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = googleApiKey;

  // @override
  // void initState() {
  //   super.initState();
  //   _addMarker(LatLng(_originLatitude, _originLongitude), "origin", BitmapDescriptor.defaultMarker);
  //   _addMarker(LatLng(_destLatitude, _destLongitude), "destination", BitmapDescriptor.defaultMarkerWithHue(90));
  //   _getPolyline();
  // }

  @override
  void initState() {
    super.initState();
    // Initial position pe marker add karo
    _addMarker(LatLng(_originLatitude, _originLongitude), "origin", BitmapDescriptor.defaultMarker);
    _addMarker(LatLng(_destLatitude, _destLongitude), "destination", BitmapDescriptor.defaultMarkerWithHue(90));
    // Map ko initially origin location pe show karne ke liye zoom level set karte hain
    Future.delayed(Duration.zero, () {
      mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(_originLatitude, _originLongitude), zoom: 14),
      ));
    });
    _getPolyline();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        CustomAppBar(title: 'Map', isArrow: true, isAction: false),
        Expanded(
          child: GoogleMap(
            initialCameraPosition: CameraPosition(target: LatLng(_originLatitude, _originLongitude), zoom: 6),
            myLocationEnabled: false,
            tiltGesturesEnabled: true,
            compassEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            onMapCreated: _onMapCreated,
            markers: Set<Marker>.of(markers.values),
            polylines: Set<Polyline>.of(polylines.values),
          ),
        ),
      ],
    ));
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  // _getPolyline() async {
  //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //     googleApiKey: googleApiKey,
  //     request: PolylineRequest(
  //       origin: PointLatLng(_originLatitude, _originLongitude),
  //       destination: PointLatLng(_destLatitude, _destLongitude),
  //       mode: TravelMode.driving,
  //       // Removed the unrelated waypoint
  //     ),
  //   );
  //   if (result.points.isNotEmpty) {
  //     result.points.forEach((PointLatLng point) {
  //       polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  //     });
  //     _addPolyLine(); // Draw the polyline on the map

  //     // Adjust the camera position and zoom level
  //     LatLngBounds bounds = LatLngBounds(
  //       southwest: LatLng(_originLatitude, _originLongitude),
  //       northeast: LatLng(_destLatitude, _destLongitude),
  //     );

  //     CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 50);
  //     await mapController!.animateCamera(cameraUpdate);
  //   } else {
  //     print("No polyline points returned"); // Log error if no route is returned
  //   }
  // }
  // Future<void> _getPolyline() async {
  //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //     googleApiKey: googleApiKey,
  //     request: PolylineRequest(
  //       origin: PointLatLng(_originLatitude, _originLongitude),
  //       destination: PointLatLng(_destLatitude, _destLongitude),
  //       mode: TravelMode.driving,
  //     ),
  //   );

  //   if (result.points.isNotEmpty) {
  //     polylineCoordinates = result.points.map((point) => LatLng(point.latitude, point.longitude)).toList();
  //     _addPolyLine();

  //     if (mapController != null) {
  //       // Dynamically determine southwest and northeast points
  //       double southLat = _originLatitude < _destLatitude ? _originLatitude : _destLatitude;
  //       double northLat = _originLatitude > _destLatitude ? _originLatitude : _destLatitude;
  //       double westLng = _originLongitude < _destLongitude ? _originLongitude : _destLongitude;
  //       double eastLng = _originLongitude > _destLongitude ? _originLongitude : _destLongitude;

  //       LatLngBounds bounds = LatLngBounds(
  //         southwest: LatLng(southLat, westLng),
  //         northeast: LatLng(northLat, eastLng),
  //       );

  //       CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 50);
  //       await mapController!.animateCamera(cameraUpdate);
  //     }
  //   } else {
  //     print("No polyline points returned");
  //   }
  // }
  Future<void> _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: googleApiKey,
      request: PolylineRequest(
        origin: PointLatLng(_originLatitude, _originLongitude),
        destination: PointLatLng(_destLatitude, _destLongitude),
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isNotEmpty) {
      polylineCoordinates = result.points.map((point) => LatLng(point.latitude, point.longitude)).toList();
      _addPolyLine();

      if (mapController != null) {
        // Dynamically determine southwest and northeast points for bounds
        double southLat = _originLatitude < _destLatitude ? _originLatitude : _destLatitude;
        double northLat = _originLatitude > _destLatitude ? _originLatitude : _destLatitude;
        double westLng = _originLongitude < _destLongitude ? _originLongitude : _destLongitude;
        double eastLng = _originLongitude > _destLongitude ? _originLongitude : _destLongitude;

        LatLngBounds bounds = LatLngBounds(
          southwest: LatLng(southLat, westLng),
          northeast: LatLng(northLat, eastLng),
        );

        // Polyline draw hone ke baad camera ko adjust karne ke liye animate kare
        CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 50);
        await mapController!.animateCamera(cameraUpdate);
      }
    } else {
      print("No polyline points returned");
    }
  }
}
