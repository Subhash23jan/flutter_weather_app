import 'dart:convert';
import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather_app/location_permission.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_weather_app/response_class.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: LocationAccess(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final double latitude;
  final double longitude;
  const MyHomePage(
      {super.key, required this.latitude, required this.longitude});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 1;
  static const imageList = [
    'lib/images/clear.png',
    'lib/images/clouds.png',
    'lib/images/drizzle.png',
    'lib/images/weatherImage.jpg',
    'lib/images/mist.png',
    'lib/images/rain.png',
    'lib/images/snow.png',
  ];
  TextStyle cardTextStyle = GoogleFonts.aBeeZee(
      fontWeight: FontWeight.w400,
      color: const Color.fromARGB(233, 9, 8, 8),
      fontSize: 16);
  WeatherData? weather;
  DateFormat timeFormat = DateFormat('HH:mm a');

  @override
  void initState() {
    super.initState();
    print(widget.longitude);
    getWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: weather == null
            ? const Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                      child: Text(
                    "Fetching Weather Data",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  )),
                  Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                      strokeWidth: 2,
                    ),
                  )
                ],
              )
            : Stack(alignment: Alignment.topCenter, children: [
                Opacity(
                  opacity: 0.6,
                  child: Image.asset(
                    imageList[index],
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.5,
                  ),
                ),
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: kToolbarHeight),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Colors.white,
                            size: 18,
                          ),
                          Text(
                            weather?.city ?? "Location name",
                            style: GoogleFonts.aBeeZee(
                                fontWeight: FontWeight.w300,
                                fontSize: 18,
                                color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.05,
                    ),
                    Text(
                      weather!.description,
                      style: GoogleFonts.actor(
                          fontWeight: FontWeight.w100,
                          fontSize: 35,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.22,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.2,
                        ),
                        Text(
                          kelvinToCelcius(weather!.temperature),
                          style: GoogleFonts.aBeeZee(
                              fontWeight: FontWeight.w100,
                              fontSize: 40,
                              color: Colors.white),
                        ),
                        const Text(
                          '\u00B0C', // Unicode for degree Celsius symbol
                          style: TextStyle(
                            fontSize: 25.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.42,
                          height: MediaQuery.sizeOf(context).height * 0.2,
                          child: Card(
                            color: const Color.fromARGB(238, 234, 226,
                                226), // Milk-colored background (white)
                            elevation: 4.0, // Add elevation for a shadow effect
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Weather Forecast',
                                    style: GoogleFonts.aBeeZee(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Row(
                                    children: [
                                      Text(
                                        'Feels Like : ${kelvinToCelcius(weather!.temperatureFeelsLike)}\u00B0C',
                                        style: GoogleFonts.robotoSerif(
                                          fontSize: 12.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.42,
                          height: MediaQuery.sizeOf(context).height * 0.2,
                          child: Card(
                            color: const Color.fromARGB(238, 234, 226,
                                226), // Milk-colored background (white)
                            elevation: 4.0, // Add elevation for a shadow effect
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Align(
                                    alignment: Alignment.center,
                                    child: const Text(
                                      '  On This Day',
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Row(
                                        children: [
                                          Icon(
                                            (Icons.arrow_upward),
                                            size: 18,
                                          ),
                                          Text(
                                            "Max :",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '${kelvinToCelcius(weather!.tempMax)}\u00B0C',
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const Row(
                                        children: [
                                          Icon(
                                            (Icons.arrow_downward),
                                            size: 18,
                                          ),
                                          Text(
                                            "Min :",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '${kelvinToCelcius(weather!.tempMin)}\u00B0C',
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.01,
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.9,
                      height: MediaQuery.sizeOf(context).height * 0.2,
                      child: Card(
                        color: const Color.fromARGB(238, 234, 226,
                            226), // Milk-colored background (white)
                        elevation: 4.0, // Add elevation for a shadow effect
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Wind Speed",
                                    style: cardTextStyle,
                                  ),
                                  Text(
                                    "Humidity",
                                    style: cardTextStyle,
                                  ),
                                  Text(
                                    "Visibility",
                                    style: cardTextStyle,
                                  ),
                                  Text(
                                    "Pressure",
                                    style: cardTextStyle,
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${weather!.windSpeed.toStringAsFixed(0)} km/h",
                                    style: cardTextStyle,
                                  ),
                                  Text(
                                    "${weather!.humidity.toStringAsFixed(0)}%",
                                    style: cardTextStyle,
                                  ),
                                  Text(
                                    '${weather!.visibility.toStringAsFixed(0)} Km',
                                    style: cardTextStyle,
                                  ),
                                  Text(
                                    "${weather!.pressure.toStringAsFixed(0)} mBar",
                                    style: cardTextStyle,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.01,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18)),
                      width: MediaQuery.sizeOf(context).width * 0.95,
                      child: Card(
                        color: const Color.fromARGB(238, 234, 226,
                            226), // Milk-colored background (white)
                        elevation: 4.0, // Add elevation for a shadow effect
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    CupertinoIcons.sunrise,
                                    color: Colors.black,
                                    size: 18,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 6),
                                    child: Text(
                                      "Sunrise : ",
                                      style: GoogleFonts.aBeeZee(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      timeFormat.format(weather!.sunrise),
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Icon(
                                    CupertinoIcons.sunset,
                                    color: Colors.black,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 10),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      "Sunset : ",
                                      style: GoogleFonts.aBeeZee(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      timeFormat.format(weather!.sunset),
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ]));
  }

  String kelvinToCelcius(double kelvin) {
    return (kelvin - 273).toStringAsFixed(2);
  }

  void getWeatherData() {
    Timer.periodic(Duration(seconds: 3), (timer) async {
      try {
        String url =
            "https://api.openweathermap.org/data/2.5/weather?lat=${widget.latitude}&lon=${widget.longitude}&appid=165ba0840d553149d8dd08825c4ea0ec";

        final response = await http.get(Uri.parse(url));
        print(url);
        if (response.statusCode == 200) {
          // Successfully fetched weather data
          final jsonResponse = jsonDecode(response.body);
          setState(() {
            weather = WeatherData.fromJson(jsonResponse);
            setImage(weather!.description);
            if (kDebugMode) {
              print(weather!.tempMax);
              print(weather!.tempMin);
            }
          });
        } else {
          // HTTP request failed
          print('Request failed with status: ${response.statusCode}');
        }
      } catch (e) {
        // Exception occurred during HTTP request
        print('Error: $e');
      }
    });
  }

  void setImage(String description) {
    if (description.contains("other")) {
      setState(() {
        index = 3;
      });
    } else if (description.contains("clear")) {
      setState(() {
        index = 0;
      });
    } else if (description.contains("cloud")) {
      setState(() {
        index = 1;
      });
    } else if (description.contains("drizzle")) {
      setState(() {
        index = 2;
      });
    } else if (description.contains("mist")) {
      setState(() {
        index = 4;
      });
    } else if (description.contains("rain")) {
      setState(() {
        index = 5;
      });
    } else if (description.contains("snow")) {
      setState(() {
        index = 6;
      });
    } else {
      setState(() {
        index = 3;
      });
    }
  }
}
