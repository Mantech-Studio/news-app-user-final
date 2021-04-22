import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:news_app_user/Database.dart';
import 'package:news_app_user/Screens/BlogDataPage.dart';
import 'package:shimmer/shimmer.dart';

class BookmarkPage extends StatefulWidget {
  List id;
  BookmarkPage(this.id);
  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  String uid = FirebaseDb().getuid().toString();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookmarks')
            .doc(uid)
            .collection(uid)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text(
              'No Data...',
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Column(
                  children: [
                    Container(
                      height: 30,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                    ),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data!.docs[index];
                  String docid = ds.id;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  BlogDataPage(ds, widget.id)));
                    },
                    child: Material(
                      elevation: 2,
                      child: Padding(
                        padding: EdgeInsets.all(0),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10),
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
                                height: 10,
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
                                          color: Colors.black.withOpacity(0.4)),
                                    ),
                                    Text(ds['date'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Colors.black.withOpacity(0.4))),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                            onTap: () async {
                                              var database =
                                                  await FirebaseDb().main2();
                                              await FirebaseDb()
                                                  .removebookmark(uid, docid);
                                              FirebaseDb().deleteBM(
                                                  database, ds['title']);
                                            },
                                            child: Container(
                                                child: Icon(Icons.delete))),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
          }
        },
      ),
    );
  }
}
