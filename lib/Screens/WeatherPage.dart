import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherPage extends StatefulWidget {
  Position position;
  WeatherPage(this.position);
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  var weather;
  bool loading = false;
  static const String API_KEY = "f43fe4a3fb5a7b285f72ea7fec352919";
  Future fetchalldata() async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=${widget.position.latitude}&lon=${widget.position.longitude}&units=metric&appid=$API_KEY'));
    setState(() {
      loading = true;
      weather = jsonDecode(response.body);
    });
    print(weather);
    return jsonDecode(response.body);
  }

  String getClockInUtcPlus5Hours(int timeSinceEpochInSec) {
    final time = DateTime.fromMillisecondsSinceEpoch(timeSinceEpochInSec * 1000,
            isUtc: true)
        .add(const Duration(hours: 6));
    return '${time.hour}:${time.minute}:${time.second}';
  }

  @override
  void initState() {
    super.initState();
    fetchalldata();
  }

  @override
  Widget build(BuildContext context) {
    if (loading == true) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text(
              'मौसम',
              style: TextStyle(color: Colors.white),
            )),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/weather/${weather['weather'][0]['icon']}.png'),
                            fit: BoxFit.fill),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  /*
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: 'latitude: ',style: TextStyle(color: Colors.black.withOpacity(0.6),
                              fontWeight: FontWeight.bold,fontSize: 16)),
                          TextSpan(text: weather['coord']['lat'].toString(),style: TextStyle(
                              color: Colors.black.withOpacity(0.8),fontWeight: FontWeight.bold,fontSize: 18)),
                          TextSpan(text: '\nlongitude: ',style: TextStyle(
                              color: Colors.black.withOpacity(0.6),fontWeight: FontWeight.bold,fontSize: 16)),
                          TextSpan(text: weather['coord']['lon'].toString(),style: TextStyle(
                              color: Colors.black.withOpacity(0.8),fontWeight: FontWeight.bold,fontSize: 18)),
                        ],
                      ),
                    ),
                     */
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'Description: ',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        TextSpan(
                            text: weather['weather'][0]['description'],
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.8),
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'temperature :',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        TextSpan(
                            text: weather['main']['temp'].toString() + '°C',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.8),
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'feels_like : ',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        TextSpan(
                            text:
                                weather['main']['feels_like'].toString() + '°C',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.8),
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'temperature_min :',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        TextSpan(
                            text: weather['main']['temp_min'].toString() + '°C',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.8),
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'temperature_max :',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        TextSpan(
                            text: weather['main']['temp_max'].toString() + '°C',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.8),
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'pressure :',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        TextSpan(
                            text:
                                weather['main']['pressure'].toString() + ' hPa',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.8),
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'humidity :',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        TextSpan(
                            text: weather['main']['humidity'].toString() + '%',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.8),
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'visibility :',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        TextSpan(
                            text: weather['visibility'].toString(),
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.8),
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'wind_speed :',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        TextSpan(
                            text: weather['wind']['speed'].toString() +
                                ' meter/sec',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.8),
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'pressure :',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        TextSpan(
                            text:
                                weather['main']['pressure'].toString() + ' hPa',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.8),
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'sunrise :',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        TextSpan(
                            text: getClockInUtcPlus5Hours(
                                weather['sys']['sunrise']),
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.8),
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'sunset :',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        TextSpan(
                            text: getClockInUtcPlus5Hours(
                                weather['sys']['sunset']),
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.8),
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'location :',
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        TextSpan(
                            text: weather['name'],
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.8),
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
          appBar: AppBar(title: Text('Weather Page')),
          body: Center(child: CircularProgressIndicator()));
    }
  }
}
