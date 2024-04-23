import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_weather_app/main.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

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

  void redirectToAppSettings() {
    openAppSettings();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
              child: Text(
            "Accessing Location",
            style: TextStyle(color: Colors.white),
          )),
          Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
              strokeWidth: 2,
            ),
          )
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
      // Show a dialog or message to inform the user about the need to enable location permissions
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Location Permissions Required"),
            content: const Text(
                "Please enable location permissions in app settings to use this feature."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  redirectToAppSettings(); // Redirect to app settings
                },
                child: Text(
                  "Open Settings",
                  style: GoogleFonts.aBeeZee(),
                ),
              ),
            ],
          );
        },
      );
      return; // Exit the function or method
    }

    // Get current position
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((value) => {
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) {
                  return MyHomePage(
                      latitude: value.latitude, longitude: value.longitude);
                },
              ))
            });
  }
}
