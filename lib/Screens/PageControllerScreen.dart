import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app_user/Database.dart';
import 'package:news_app_user/HomePage.dart';
import 'package:news_app_user/Screens/BookmarkPage.dart';
import 'package:news_app_user/Screens/BuisnessPage.dart';
import 'package:news_app_user/Screens/ChuruPage.dart';
import 'package:news_app_user/Screens/CovidDataPage.dart';
import 'package:news_app_user/Screens/CricketnewsPage.dart';
import 'package:news_app_user/Screens/EntertainmentPage.dart';
import 'package:news_app_user/Screens/HoroscopeNewsPage.dart';
import 'package:news_app_user/Screens/HoroscopePage.dart';
import 'package:news_app_user/Screens/InternationalPage.dart';
import 'package:news_app_user/Screens/LiveScorePage.dart';
import 'package:news_app_user/Screens/LoginPage.dart';
import 'package:news_app_user/Screens/NationalPage.dart';
import 'package:news_app_user/Screens/PhoneAuth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:news_app_user/Screens/RajasthanPage.dart';
import 'package:news_app_user/Screens/SportsPage.dart';
import 'package:news_app_user/Screens/WeatherPage.dart';
import 'package:flutter_svg/avd.dart';
import 'package:news_app_user/Theme.dart';
import 'package:provider/provider.dart';

class PageControllerScreen extends StatefulWidget {
  @override
  _PageControllerScreenState createState() => _PageControllerScreenState();
}

class _PageControllerScreenState extends State<PageControllerScreen> {
  late Position position;
  getcurrentlocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    print(position.latitude.toString() + ', ' + position.longitude.toString());
  }

  late List bookmarkid = [];
  var db;
  var id;
  fetchids() async {
    db = await FirebaseDb().main2();
    id = await FirebaseDb().bookmarksids(db);
    for (int i = 0; i < id.length; i++) {
      bookmarkid.add(id[i]['id']);
    }
  }

  String District = ' ';
  String username = 'loading';

  getusername() async {
    String uid = await FirebaseDb().getuid();

    await FirebaseFirestore.instance
        .collection('User Data')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          username = documentSnapshot['user_name'];
        });
        print(documentSnapshot['user_name']);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getusername();
    getcurrentlocation();
    fetchids();
  }

  List<String> Districts = [
    'श्रीगंगानगर',
    'हनुमानगढ़',
    'चुरू',
    'झुंझुनू',
    'बीकानेर',
    'बाड़मेर',
    'जैसलमेर',
    'सिरोही',
    'सीकर',
    'नगोर',
    'पाली',
    'बांसवाड़ा',
    'जोधपुर',
    'जयपुर',
    'अजमेर',
    'भीलवाड़ा',
    'चित्तौड़गढ़',
    'टोंक',
    'धौलपुर',
    'अलवर',
    'भरतपुर',
    'डूंगरपुर',
    'सवाई माधोपुर',
    'कोटा',
    'बूंदी',
    'बारां',
    'झालावाड़',
    'उदयपुर',
    'राजसमंद',
    'करोली',
    'जालौर',
    'प्रतापगढ़',
    'दौसा',
  ];
  late String weather;
  //insert username at line 95
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, ThemeNotifier notifier, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: notifier.darkTheme ? light : dark,
            home: DefaultTabController(
              length: 11,
              child: Scaffold(
                  drawer: Drawer(
                    child: Container(
                      width: double.infinity,
                      child: SingleChildScrollView(
                        physics: ScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //pass username in this box
                            Container(
                              color: Colors.black12,
                              height: 150,
                              width: double.infinity,
                              padding: EdgeInsets.only(left: 20, bottom: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome Back',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    username,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400),
                                  ), //user name
                                  SizedBox(
                                    height: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Icon(
                                            EvaIcons.fileAddOutline,
                                            size: 18,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text('Share News'),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
//Log out button
                            InkWell(
                              onTap: () async {
                                await FirebaseDb().signout();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => PhoneAuth()),
                                    (Route<dynamic> route) => false);
                              },
                              splashColor: Theme.of(context).accentColor,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                decoration: BoxDecoration(
                                    border: Border(
                                  bottom: BorderSide(
                                      color: Colors.black26, width: 1),
                                )),
                                child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Log Out',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    )),
                              ),
                            ),
//Settings Box
                            Container(
                              padding: EdgeInsets.only(top: 20),
                              decoration: BoxDecoration(
                                  border: Border(
                                bottom:
                                    BorderSide(color: Colors.black26, width: 1),
                              )),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'SETTINGS',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: SwitchListTile(
                                        //value: false,
                                        value: notifier.darkTheme, //change it
                                        onChanged: (val) {
                                          setState(() {
                                            notifier.toggleTheme();
                                          });
                                        },
                                        title: Row(
                                          children: [
                                            Icon(notifier.darkTheme
                                                ? EvaIcons.moonOutline
                                                : EvaIcons.sunOutline),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(notifier.darkTheme
                                                ? 'Light Mode'
                                                : 'Dark Mode'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 20, top: 10, bottom: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.notifications_none,
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              child: AutoSizeText(
                                                'Notifications',
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 16),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //latest features
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              decoration: BoxDecoration(
                                  border: Border(
                                bottom:
                                    BorderSide(color: Colors.black26, width: 1),
                              )),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'LATEST FEATURES',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color:
                                                Theme.of(context).accentColor),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 20, top: 10, bottom: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            EvaIcons.questionMarkCircleOutline,
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              child: AutoSizeText(
                                                'Learn More',
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 16),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
//about
                            GestureDetector(
                              onTap: () {
                                //Navigator.push(context, CupertinoPageRoute(builder: (context)=>AboutPage()));
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                padding: EdgeInsets.only(
                                    left: 20, top: 10, bottom: 20),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      EvaIcons.infoOutline,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: AutoSizeText(
                                          'About',
                                          style: GoogleFonts.montserrat(
                                              fontSize: 16),
                                        )),
                                  ],
                                ),
                              ),
                            ),
//disclaimer
                            GestureDetector(
                              onTap: () {
//Navigator.push(context, CupertinoPageRoute(builder: (context)=>DisclaimerPage()));
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 20, top: 10, bottom: 20),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        EvaIcons.alertTriangleOutline,
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        'Disclaimer',
                                        style: GoogleFonts.montserrat(
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ), //support
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 20, top: 10, bottom: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        EvaIcons.headphonesOutline,
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: AutoSizeText(
                                            'Support',
                                            style: GoogleFonts.montserrat(
                                                fontSize: 16),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  appBar: PreferredSize(
                    preferredSize:
                        Size(MediaQuery.of(context).size.width.toDouble(), 80),
                    child: AppBar(
                      title: Text('जयपुर टाइम्स'),
                      centerTitle: true,
                      actions: [
                        /*
                        Container(
                          child: IconButton(
                            icon: Icon(
                              Icons.logout,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              await FirebaseDb().signout();
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (context) => PhoneAuth()),
                                      (Route<dynamic> route) => false);
                            },
                          ),
                        ),
                         */
                        GestureDetector(
                          onTap: () async {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) =>
                                        WeatherPage(position)));
                          },
                          child: WeatherIcon('Sunny'),
                        ),
                      ],
                      bottom: TabBar(
                        isScrollable: true,
                        physics: ScrollPhysics(),
                        automaticIndicatorColorAdjustment: true,
                        tabs: <Widget>[
                          Tab(
                            child: Container(
                              width: 120,
                              child: DropdownButton<String>(
                                hint: District == " "
                                    ? Text('Please select', style: TextStyle())
                                    : Text(District,
                                        style: TextStyle(fontSize: 18)),
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
                                    District = newValue!;
                                    //statenumber = states.indexOf(newValue);
                                  });
                                  //print(statenumber);
                                },
                                items: Districts.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          /*
                          Tab(
                            child: Container(
                              child: Text(
                                'चुरू',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          */
                          Tab(
                            child: Container(
                              child: Text(
                                'राजस्थान',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          Tab(
                            child: Container(
                              child: Text('कोविड डेटा'),
                            ),
                          ),
                          Tab(
                            child: Container(
                              child: Text('राष्ट्रीय'),
                            ),
                          ),
                          Tab(
                            child: Container(
                              child: Text('अंतरराष्ट्रीय'),
                            ),
                          ),
                          Tab(
                            child: Container(
                              child: Text('खेल'),
                            ),
                          ),
                          Tab(
                            child: Container(
                              child: Text('मनोरंजन'),
                            ),
                          ),
                          Tab(
                            child: Container(
                              child: Text('व्यापार'),
                            ),
                          ),
                          /*
                          Tab(
                            child: Container(
                              child: Text("आज का राशिफल"),
                            ),
                          ),
                           */
                          Tab(
                            child: Container(
                              child: Text('राशिफल'),
                            ),
                          ),
                          Tab(
                            child: Container(
                              child: Text('बुकमार्क'),
                            ),
                          ),
                          Tab(
                            child: Container(
                              child: Text('क्रिकेट स्कोर'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  body: TabBarView(
                    physics: ScrollPhysics(),
                    children: <Widget>[
                      ChuruPage(bookmarkid, District),
                      RajasthanPage(bookmarkid),
                      CovidDataPage(),
                      NationalPage(bookmarkid),
                      InternationalPage(bookmarkid),
                      SportsPage(bookmarkid),
                      EntertainmentPage(bookmarkid),
                      BuisnessPage(bookmarkid),
                      //HoroscopeNewsPage(bookmarkid),
                      HoroscopePage(bookmarkid),
                      BookmarkPage(bookmarkid),
                      CricketNews(),
                    ],
                  )),
            ),
          );
          ;
        },
      ),
    );
  }

  Widget WeatherIcon(String weather) {
    switch (weather) {
      case 'Cold':
        {
          return Container(
            width: 30,
            height: 30,
            color: Colors.white,
            margin: EdgeInsets.only(right: 10),
            child: SvgPicture.asset(
              'assets/Icons/cold.svg',
              height: 30,
              width: 30,
              fit: BoxFit.fill,
            ),
          );
        }
      case 'Windy':
        {
          return Container(
            width: 30,
            height: 30,
            color: Colors.white,
            margin: EdgeInsets.only(right: 10),
            child: SvgPicture.asset(
              'assets/Icons/Windy.svg',
              height: 30,
              width: 30,
              fit: BoxFit.fill,
            ),
          );
        }
        break;
      case 'Sunny':
        {
          return Container(
            width: 30,
            height: 30,
            color: Colors.white,
            margin: EdgeInsets.only(right: 10),
            child: SvgPicture.asset(
              'assets/Icons/sunny.svg',
              height: 30,
              width: 30,
              fit: BoxFit.fill,
            ),
          );
          break;
        }
      case 'Raining':
        {
          return Container(
            width: 30,
            height: 30,
            color: Colors.white,
            margin: EdgeInsets.only(right: 10),
            child: SvgPicture.asset(
              'assets/Icons/raining.svg',
              height: 30,
              width: 30,
              fit: BoxFit.fill,
            ),
          );
          break;
        }
      case 'Thunder':
        {
          return Container(
            width: 30,
            height: 30,
            //color: Colors.white,
            margin: EdgeInsets.only(right: 10),
            child: SvgPicture.asset(
              'assets/Icons/Thunder.svg',
              height: 30,
              width: 30,
              fit: BoxFit.fill,
            ),
          );
          break;
        }
      case 'Cloudy':
        {
          return Container(
            width: 30,
            height: 30,
            color: Colors.white,
            margin: EdgeInsets.only(right: 10),
            child: SvgPicture.asset(
              'assets/Icons/CloudySunny.svg',
              height: 30,
              width: 30,
              fit: BoxFit.fill,
            ),
          );
          break;
        }
    }
    return Container();
  }
}
