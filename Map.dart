import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;

class BusMapScreen extends StatefulWidget {
  const BusMapScreen({super.key});

  @override
  State<BusMapScreen> createState() => _BusMapScreenState();
}

class _BusMapScreenState extends State<BusMapScreen> {
  GoogleMapController? mapController;
  StreamSubscription<Position>? positionStream;

  final LatLng collegeLocation = LatLng(17.6765, 75.9010); // NK Orchid College
  LatLng currentLocation = LatLng(17.6599, 75.9064);

  final Set<Marker> markers = {};
  final Set<Polyline> polylines = {};

  final String googleApiKey = "AIzaSyBbVfavpvsR1JWw8Q3S_bcFrG0fAoQuC0M";

  double distance = 0.0;
  String duration = "";

  @override
  void initState() {
    super.initState();
    _startLiveTracking();
  }

  Future<void> _startLiveTracking() async {
    await _checkPermission();

    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 5,
      ),
    ).listen((Position position) {
      currentLocation = LatLng(position.latitude, position.longitude);

      _updateMarkers();
      _drawRoute();
      _calculateDistance();
      _getETA();

      mapController?.animateCamera(
        CameraUpdate.newLatLng(currentLocation),
      );
    });
  }

  /// 🔐 Location Permission
  Future<void> _checkPermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw "Location service disabled";
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
  }

  /// 📌 Update Markers
  void _updateMarkers() {
    markers.clear();

    markers.add(
      Marker(
        markerId: const MarkerId("user"),
        position: currentLocation,
        infoWindow: const InfoWindow(title: "Your Location"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );

    markers.add(
      Marker(
        markerId: const MarkerId("college"),
        position: collegeLocation,
        infoWindow: const InfoWindow(title: "NK Orchid College"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );

    setState(() {});
  }

  /// 🛣️ Draw Route (Polyline)
  Future<void> _drawRoute() async {
    PolylinePoints polylinePoints = PolylinePoints(apiKey: googleApiKey);

    PolylineResult result =
    await polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(
            currentLocation.latitude, currentLocation.longitude),
        destination:
        PointLatLng(collegeLocation.latitude, collegeLocation.longitude),
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isNotEmpty) {
      polylines.clear();

      polylines.add(
        Polyline(
          polylineId: const PolylineId("route"),
          color: Colors.blue,
          width: 5,
          points: result.points
              .map((p) => LatLng(p.latitude, p.longitude))
              .toList(),
        ),
      );

      setState(() {});
    }
  }

  /// 📏 Distance
  void _calculateDistance() {
    distance = Geolocator.distanceBetween(
      currentLocation.latitude,
      currentLocation.longitude,
      collegeLocation.latitude,
      collegeLocation.longitude,
    );
  }

  Future<void> _getETA() async {
    final url =
        "https://maps.googleapis.com/maps/api/directions/json?"
        "origin=${currentLocation.latitude},${currentLocation.longitude}"
        "&destination=${collegeLocation.latitude},${collegeLocation.longitude}"
        "&key=$googleApiKey";

    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);

    if (data["routes"].isNotEmpty) {
      duration = data["routes"][0]["legs"][0]["duration"]["text"];
      setState(() {});
    }
  }

  @override
  void dispose() {
    positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Live Bus Tracking")),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:
            CameraPosition(target: currentLocation, zoom: 14),
            myLocationEnabled: true,
            markers: markers,
            polylines: polylines,
            onMapCreated: (controller) => mapController = controller,
          ),

          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Distance: ${(distance / 1000).toStringAsFixed(2)} km | ETA: $duration",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}
