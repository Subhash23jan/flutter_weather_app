import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather_app/GobalVariables/imagesList.dart';
import 'package:flutter_weather_app/location_permission.dart';
import 'package:geolocator/geolocator.dart';
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
  const MyHomePage({super.key, required this.latitude, required this.longitude});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const imageList=[
    'lib/images/clear.png',
    'lib/images/clouds.png',
    'lib/images/drizzle.png',
    'lib/images/weatherImage.jpg',
    'lib/images/humidity.png',
    'lib/images/mist.png',
    'lib/images/rain.png',
    'lib/images/snow.png',
    'lib/images/wind.png',
  ];
  static const cardTextStyle=TextStyle(color: Colors.black45,fontSize: 14);
   WeatherData ? weather;
  DateFormat timeFormat = DateFormat('HH:mm:ss');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.longitude);
    getWeatherData();
  }
  @override
  Widget build(BuildContext context) {
    return  weather==null ?const Center(child: CircularProgressIndicator(color: Colors.blue,strokeWidth: 2,)):Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Opacity(
            opacity: 0.6,
            child: Image.asset(
              imageList[3],fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              height:MediaQuery.of(context).size.height*0.5,),
          ),
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 30),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on_outlined,color: Colors.black,size: 16,),
                    Text(weather?.city??"Location name",style: const TextStyle(),)
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height*0.05,
              ),
              Text(weather!.description,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),),
              SizedBox(
                height: MediaQuery.sizeOf(context).height*0.25,
              ),
               Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width*0.2,
                  ),
                   Text(
                    kelvinToCelcius(weather!.temperature)??'25',
                    style: const TextStyle(
                      fontSize: 35.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    '\u00B0C', // Unicode for degree Celsius symbol
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            ],
          ),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: [
                   SizedBox(
                     width:MediaQuery.sizeOf(context).width*0.42,
                     height:MediaQuery.sizeOf(context).height*0.2,
                      child:  Card(
                        color: Colors.white12, // Milk-colored background (white)
                        elevation: 4.0, // Add elevation for a shadow effect
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                ' Temperature  Feels Like',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Row(
                                children: [
                                  Text(
                                    kelvinToCelcius(weather!.temperatureFeelsLike)??'25',
                                    style: const TextStyle(
                                      fontSize: 22.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    '\u00B0C', // Unicode for degree Celsius symbol
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
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
                     width:MediaQuery.sizeOf(context).width*0.42,
                     height:MediaQuery.sizeOf(context).height*0.2,
                     child:  Card(
                       color: Colors.white12, // Milk-colored background (white)
                       elevation: 4.0, // Add elevation for a shadow effect
                       child: Padding(
                         padding: const EdgeInsets.all(16.0),
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             const Text(
                               '  Temperature',
                               style: TextStyle(
                                 fontSize: 18.0,
                                 fontWeight: FontWeight.bold,
                               ),
                             ),

                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                               children: [
                                 const Row(
                                   children: [
                                     Icon((Icons.arrow_upward)),
                                     Text("Max :",style: TextStyle(fontSize: 14),),
                                   ],
                                 ),
                                 Text(
                                   '${kelvinToCelcius(weather!.tempMax)}\u00B0C',
                                   style: const TextStyle(
                                     fontSize: 16.0,
                                     color: Colors.black,
                                     fontWeight: FontWeight.bold,
                                   ),
                                 ),
                               ],
                             ),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceAround,
                               children: [
                                 const Row(
                                   children: [
                                     Icon((Icons.arrow_downward)),
                                     Text("Min :",style: TextStyle(fontSize: 14),),
                                   ],
                                 ),
                                 Text(
                                   '${kelvinToCelcius(weather!.tempMin)}\u00B0C',
                                   style: const TextStyle(
                                     fontSize: 16.0,
                                     color: Colors.black,
                                     fontWeight: FontWeight.bold,
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
                height: MediaQuery.sizeOf(context).height*0.01,
              ),
               SizedBox(
                width:MediaQuery.sizeOf(context).width*0.9,
                height:MediaQuery.sizeOf(context).height*0.2,
                child:  Card(
                  color: Colors.white, // Milk-colored background (white)
                  elevation: 4.0, // Add elevation for a shadow effect
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Wind Speed",style: cardTextStyle,),
                            Text("Humidity",style: cardTextStyle,),
                            Text("Visibility",style: cardTextStyle,),
                            Text("Pressure",style: cardTextStyle,),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${weather!.windSpeed.toStringAsFixed(0)} km/h",style: cardTextStyle,),
                            Text("${weather!.humidity.toStringAsFixed(0)}%",style: cardTextStyle,),
                            Text('${weather!.visibility.toStringAsFixed(0)} Km',style: cardTextStyle,),
                            Text("${weather!.pressure.toStringAsFixed(0)} mBar",style: cardTextStyle,),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height*0.01,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18)
                ),
                width:MediaQuery.sizeOf(context).width*0.95,
                child:   Card(
                  color: Colors.white12, // Milk-colored background (white)
                  elevation: 4.0, // Add elevation for a shadow effect
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                             const Icon(CupertinoIcons.sunrise,color: Colors.black,size: 18,),
                             const SizedBox(width: 10,),
                             const Padding(
                               padding: EdgeInsets.only(top: 6),
                               child: Text("Sunrise : ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                             ),
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text('${timeFormat.format(weather!.sunrise)} AM',style: const TextStyle(fontSize: 12),),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(CupertinoIcons.sunset,color: Colors.black,size: 18,),
                             const SizedBox(width: 10),
                            const Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Text("Sunset : ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text('${timeFormat.format(weather!.sunset)} PM',style: const TextStyle(fontSize: 12),),
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

      ]
      )
    );
  }
  String kelvinToCelcius(double kelvin)
  {
    return (weather!.temperature-273).toStringAsFixed(2);
  }
  void getWeatherData()  {
    Timer.periodic(Duration(seconds: 2), (timer) async {
      try {
        String url="https://api.openweathermap.org/data/2.5/weather?lat=${widget.latitude}&lon=${widget.longitude}&appid=165ba0840d553149d8dd08825c4ea0ec";
        print(url);
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          // Successfully fetched weather data
          final jsonResponse = jsonDecode(response.body);
          setState(() {
            weather = WeatherData.fromJson(jsonResponse);
            if (kDebugMode) {
              print(weather!.sunrise);
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

}

