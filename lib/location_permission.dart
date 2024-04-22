import 'package:flutter/material.dart';
import 'package:flutter_weather_app/main.dart';
import 'package:geolocator/geolocator.dart';


class LocationAccess extends StatefulWidget {
  const LocationAccess({super.key});

  @override
  State<LocationAccess> createState() => _LocationAccessState();
}

class _LocationAccessState extends State<LocationAccess> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body:Stack(
        children: [
          Center(child: Text("Location Permission")),
        ],
      ),
    );
  }

  void getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, show user a dialog
      return;
    }

    // Check for location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.

      return;
    }

    // Get current position
    await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high).then((value) =>{
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
            return MyHomePage(latitude: value.latitude, longitude: value.longitude);
          },))
    });
  }

}
