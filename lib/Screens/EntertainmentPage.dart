import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app_user/Database.dart';
import 'package:news_app_user/Screens/BlogDataPage.dart';
import 'package:shimmer/shimmer.dart';

class EntertainmentPage extends StatefulWidget {
  List id;
  EntertainmentPage(this.id);
  @override
  _EntertainmentPageState createState() => _EntertainmentPageState();
}

class _EntertainmentPageState extends State<EntertainmentPage> {
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('मनोरंजन ')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text(
              'No Data...',
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return SingleChildScrollView(
              child: Column(
                children: List.generate(
                    10,
                    (index) => Container(
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
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  height: 20,
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    height: 20,
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 20,
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  height: 20,
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    height: 20,
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
              ),
            );
          } else {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data!.docs[index];
                  String docid = ds.id;
                  if (count == 0) {
                    FirebaseDb().updatevalue(docid, 'impression');
                    count += 1;
                  }
                  if (index == 0) {
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
                                bottom:
                                    BorderSide(width: 2, color: Colors.grey),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
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
                                SizedBox(
                                  height: 10,
                                ),
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
                                            color: Colors.grey),
                                      ),
                                      Text(
                                        ds['date'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                        child: Container(
                                            child: Icon(Icons.bookmark))),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    GestureDetector(
                                      child: Container(
                                          child: Icon(EvaIcons.share)),
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
                            bottom: BorderSide(),
                          )),
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          child: Row(
                            children: [
                              Container(
                                height: 100,
                                width: MediaQuery.of(context).size.width * 0.5,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                          ds['image_url']),
                                      fit: BoxFit.fill),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        (ds['title']).toString(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        maxLines: 3,
                                        overflow: TextOverflow.clip,
                                        textAlign: TextAlign.left,
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ));
                });
          }
        },
      ),
    );
  }
}
