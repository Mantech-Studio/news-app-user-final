import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/svg.dart';
class CovidDataPage extends StatefulWidget {
  @override
  _CovidDataPageState createState() => _CovidDataPageState();
}

class _CovidDataPageState extends State<CovidDataPage> {
  String countrycat = " ";
  var data;
  bool loading = false;
  String statecat = " ";
  var statedata;
  int statenumber = 0;
  List<String> states = [
    "Andaman and Nicobar Islands",
    "Andhra Pradesh",
    "Arunachal Pradesh ",
    "Assam",
    "Bihar",
    "Chandigarh",
    "Chhattisgarh",
    "Dadra and Nagar Haveli and Daman and Diu",
    "Delhi",
    "Goa",
    "Gujarat",
    "Haryana",
    "Himachal Pradesh",
    "Jammu and Kashmir",
    "Jharkhand",
    "Karnataka",
    "Kerala",
    "Ladakh",
    "Lakshadweep",
    "Madhya Pradesh",
    "Maharashtra",
    "Manipur",
    "Meghalaya",
    "Mizoram",
    "Nagaland",
    "Odisha",
    "Puducherry",
    "Punjab",
    "Rajasthan",
    "Sikkim",
    "Tamil Nadu",
    "Telangana",
    "Tripura",
    "Uttarakhand",
    "Uttar Pradesh",
    "West Bengal",
  ];
  Future fetchworldwidedata({countrycat = 'Worldwide'}) async {
    if (countrycat == 'Worldwide') {
      final response = await http.get(Uri.parse(
          'https://disease.sh/v3/covid-19/all?yesterday=false&twoDaysAgo=false&allowNull=false'));
      final response1 = await http.get(Uri.parse(
          'https://disease.sh/v3/covid-19/gov/India?allowNull=false'));
      setState(() {
        data = jsonDecode(response.body);
        statedata = jsonDecode(response1.body);
        loading = true;
      });
    } else {
      final response = await http.get(Uri.parse(
          'https://disease.sh/v3/covid-19/countries/$countrycat?strict=true&allowNull=false'));
      setState(() {
        data = jsonDecode(response.body);
        loading = true;
      });
    }
  }

  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchworldwidedata();
  }

  @override
  Widget build(BuildContext context) {
    if (loading == false) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Please wait we are fetching the data for you',style: TextStyle(fontSize: 16),),
              SizedBox(height: 10,),
              CircularProgressIndicator(backgroundColor: Colors.white,valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          controller: _controller,
          physics: BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              ClipPath(
                clipper: MyClipper(),
                child: Container(
                  padding: EdgeInsets.only(left: 40,top: 20,right: 20),
                  height: 350,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topRight,
                          colors: [
                          Color(0xFF3383CD),
                          Color(0xFF11249F),
                          ]
                      ),
                      image: DecorationImage(
                          image: AssetImage("assets/virus.png"))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                top: 30,
                                child: SvgPicture.asset("assets/Drcorona.svg",
                                  width: 230,
                                  fit: BoxFit.fitWidth,
                                  alignment: Alignment.topRight,
                                ),
                              ),
                              Positioned(
                                top: 20,
                                left: 150,
                                child: Text("All you need \nis stay at home.",style: TextStyle(color: Colors.white,fontSize: 18),),
                              ),
                              Container(),
                            ],
                          ))
                    ],
                  ),
                ),
              ),
              Text('Country wise data',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Color(0xFFE5E5E5),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: DropdownButton<String>(
                        hint: countrycat == " " ? Text('Please select',style: TextStyle(color: Colors.grey.shade700),) : Text(countrycat,style: TextStyle(color: Colors.grey.shade700)),
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Colors.black),
                        dropdownColor: Colors.white,
                        underline: Container(
                          height: 2,
                          color: Colors.white,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            countrycat = newValue!;
                          });
                          fetchworldwidedata(countrycat: countrycat);
                        },
                        items: <String>[
                          "Worldwide",
                          "Austria",
                          "Canada",
                          "Germany",
                          "India",
                          "Indonesia",
                          "Israel",
                          "Italy",
                          "Mexico",
                          "New Zealand",
                          "Nigeria",
                          "S.Korea",
                          "South Africa",
                          "Switzerland",
                          "UK",
                          "Vietnam"
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 30,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Counter(
                            color: Colors.orange,
                            number: data['cases'] ?? 0,
                            title: "Total Cases",
                            todaynum: data['todayCases'] ?? 0,
                          ),
                          Counter(
                            color: Colors.red,
                            number: data['deaths'] ?? 0,
                            title: "Deaths",
                            todaynum: data['todayDeaths'] ?? 0,
                          ),
                          Counter(
                            color: Colors.green,
                            number: data['recovered'] ?? 0,
                            title: "Recovered",
                            todaynum: data['todayRecovered'] ?? 0,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              Text('State wise data',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold)),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.only(left: 20,top: 10,bottom: 10),
                //padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Color(0xFFE5E5E5),
                  ),
                ),
                child: DropdownButton<String>(
                  hint: statecat == " " ? Text('Please select',style: TextStyle(color: Colors.grey.shade700)) : Text(statecat,style: TextStyle(color: Colors.grey.shade700)),
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 20,
                  elevation: 16,
                  dropdownColor: Colors.white,
                  style: const TextStyle(color: Colors.black),
                  underline: Container(
                    height: 2,
                    color: Colors.white,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      statecat = newValue!;
                      statenumber = states.indexOf(newValue);
                    });
                    print(statenumber);
                  },
                  items: <String>[
                    "Andaman and Nicobar Islands",
                    "Andhra Pradesh",
                    "Arunachal Pradesh ",
                    "Assam",
                    "Bihar",
                    "Chandigarh",
                    "Chhattisgarh",
                    "Dadra and Nagar Haveli and Daman and Diu",
                    "Delhi",
                    "Goa",
                    "Gujarat",
                    "Haryana",
                    "Himachal Pradesh",
                    "Jammu and Kashmir",
                    "Jharkhand",
                    "Karnataka",
                    "Kerala",
                    "Ladakh",
                    "Lakshadweep",
                    "Madhya Pradesh",
                    "Maharashtra",
                    "Manipur",
                    "Meghalaya",
                    "Mizoram",
                    "Nagaland",
                    "Odisha",
                    "Puducherry",
                    "Punjab",
                    "Rajasthan",
                    "Sikkim",
                    "Tamil Nadu",
                    "Telangana",
                    "Tripura",
                    "Uttarakhand",
                    "Uttar Pradesh",
                    "West Bengal",
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),

                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 30,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Counter(
                            color: Colors.orange,
                            number:
                                statedata['states'][statenumber]['cases'] ?? 0,
                            title: "Total Cases",
                            todaynum: statedata['states'][statenumber]
                                    ['todayCases'] ??
                                0,
                          ),
                          Counter(
                            color: Colors.red,
                            number:
                                statedata['states'][statenumber]['deaths'] ?? 0,
                            title: "Deaths",
                            todaynum: statedata['states'][statenumber]
                                    ['todayDeaths'] ??
                                0,
                          ),
                          Counter(
                            color: Colors.green,
                            number: statedata['states'][statenumber]
                                    ['recovered'] ??
                                0,
                            title: "Recovered",
                            todaynum: statedata['states'][statenumber]
                                    ['todayRecovered'] ??
                                0,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

class Counter extends StatelessWidget {
  final int number;
  final int todaynum;
  final Color color;
  final String title;
  const Counter({
    required this.number,
    required this.todaynum,
    required this.color,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(6),
          height: 25,
          width: 25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(.26),
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              border: Border.all(
                color: color,
                width: 2,
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          "$number",
          style: TextStyle(
            fontSize: 15,
            color: color,
          ),
        ),
        Text(
          "+$todaynum",
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 10),
        Text(
          title,
        ),
      ],
    );
  }
}

class MyClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0,size.height-80);
    path.quadraticBezierTo(size.width/2, size.height, size.width, size.height-80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }

}
