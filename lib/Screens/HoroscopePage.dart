import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app_user/Database.dart';
import 'package:news_app_user/Screens/HoroscopeDataPage.dart';
import 'package:shimmer/shimmer.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'BlogDataPage.dart';

class HoroscopePage extends StatefulWidget {
  List id;
  HoroscopePage(this.id);
  @override
  _HoroscopePageState createState() => _HoroscopePageState();
}

class _HoroscopePageState extends State<HoroscopePage> {
  late String updateddata;
  List<String> months = [
    'मेष',
    'वृषभ',
    'मिथुन',
    'कर्क',
    'सिंह',
    'कन्या',
    'तुला',
    'वृश्चिक',
    'धनुराशि',
    'मकर',
    'कुंभ',
    'मीन',
  ];
  var translate = {
    'मेष': 'aries',
    'वृषभ': 'taurus',
    'मिथुन': 'gemini',
    'कर्क': 'cancer',
    'सिंह': 'leo',
    'कन्या': 'virgo',
    'तुला': 'libra',
    'वृश्चिक': 'scorpio',
    'धनुराशि': 'sagittarius',
    'मकर': 'capricorn',
    'कुंभ': 'aquarius',
    'मीन': 'pisces',
  };
  late String data;
  DateTime currentDate = DateTime.now();
  String uid = FirebaseDb().getuid().toString();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(height: 20,),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.9,
              child: GridView.count(
                crossAxisCount: 3,
                children: List.generate(months.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  HoroscopeDataPage(translate[months[index]]!)));
                    },
                    child: Container(
                        child: Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage('assets/${months[index]}.jpg'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          months[index],
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        )
                      ],
                    )),
                  );
                }),
              ),
            ),
            /*
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('राशिफल')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text(
                    'No Data...',
                  );
                }
                else if(snapshot.connectionState == ConnectionState.waiting)
                {
                  return Column(
                      children: List.generate(10, (index) => Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Column(
                            children: [
                              Container(
                                height: 20,
                                width: MediaQuery.of(context).size.width,
                                color: Colors.white,
                              ),
                              SizedBox(height: 5,),
                              Container(
                                height: 20,
                                width: MediaQuery.of(context).size.width,
                                color: Colors.white,
                              ),
                              SizedBox(height: 5,),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  height: 20,
                                  width: MediaQuery.of(context).size.width/2,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 10,),
                              Container(
                                height: MediaQuery.of(context).size.height*0.3,
                                width: MediaQuery.of(context).size.width,
                                color: Colors.white,
                              ),
                              SizedBox(height: 10,),
                              Container(
                                height: 20,
                                width: MediaQuery.of(context).size.width,
                                color: Colors.white,
                              ),
                              SizedBox(height: 5,),
                              Container(
                                height: 20,
                                width: MediaQuery.of(context).size.width,
                                color: Colors.white,
                              ),
                              SizedBox(height: 5,),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  height: 20,
                                  width: MediaQuery.of(context).size.width/2,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                    );
                }
                else {
                  return Flexible(
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot ds = snapshot.data!.docs[index];
                          String docid = ds.id;
                          FirebaseDb().updatevalue(docid, 'impression');
                          if(index==0)
                          {
                            return GestureDetector(
                              onTap: () async {
                                await FirebaseDb().updatevalue(docid, 'views');
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            BlogDataPage(ds, widget.id)));
                              },
                              child: Material(
                                elevation: 2,
                                child: Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Container(
                                    //margin: EdgeInsets.only(bottom: 10),
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    width: MediaQuery.of(context).size.width * 0.9,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(width: 2, color: Colors.grey),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: MediaQuery.of(context).size.height * 0.3,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: CachedNetworkImageProvider(
                                                    ds['image_url']),
                                                fit: BoxFit.fill),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(left: 10, right: 10),
                                          child: Text(
                                            (ds['title']).toString(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 22,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10,),
                                        Container(
                                          padding: EdgeInsets.only(left: 10, right: 10),
                                          child: Text(
                                            (ds['description']).toString(),
                                            maxLines: 5,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 18),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10, right: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                ds['category'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: Colors.grey),),
                                              Text(ds['date'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 10,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            GestureDetector(child: Container(child: Icon(Icons.bookmark))),
                                            SizedBox(width: 10,),
                                            GestureDetector(
                                              child: Container(child: Icon(EvaIcons.share)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                          return GestureDetector(
                              onTap: () async {
                                await FirebaseDb().updatevalue(docid, 'views');
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            BlogDataPage(ds, widget.id)));
                              },
                              child: Material(
                                elevation: 2,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 140,
                                  //color: Theme.of(context).backgroundColor.withOpacity(0.1),
                                  //margin: EdgeInsets.only(top: 10,bottom: 10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(

                                        ),
                                      )
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 100,
                                        width: MediaQuery.of(context).size.width*0.5,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                  ds['image_url']),
                                              fit: BoxFit.fill),
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                          child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Text((ds['title']).toString(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                                                maxLines: 3,overflow: TextOverflow.clip,textAlign: TextAlign.left,)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ));
                        }),
                  );
                }
              },
            ),
             */
          ],
        ),
      ),
    );
  }
}
