import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:news_app_user/Database.dart';
import 'package:share/share.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';

class BlogDataPage extends StatefulWidget {
  DocumentSnapshot ds;
  List id;
  BlogDataPage(this.ds, this.id);
  @override
  _BlogDataPageState createState() => _BlogDataPageState();
}

class _BlogDataPageState extends State<BlogDataPage> {
  String uid = FirebaseDb().getuid().toString();
  var database;
  var scr = new GlobalKey();
  double _fontsize = 18;

  takescrshot() async {
    RenderRepaintBoundary boundary =
        scr.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final directory = (await getExternalStorageDirectory())!.path;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);

    ByteData byteData = (await image.toByteData(format: ImageByteFormat.png))!;
    Uint8List pngBytes = byteData.buffer.asUint8List();
    File imgFile = new File('$directory/screenshot.png');
    await imgFile.writeAsBytes(pngBytes);
    Share.shareFiles(
      [File('$directory/screenshot.png').path],
      text:
          'To Read the Full Article. Download this App (जयपुर टाइम्स) from the play store',
    );
  }

  @override
  Widget build(BuildContext context) {
    String docid = FirebaseFirestore.instance
        .collection('bookmarks')
        .doc(uid)
        .collection(uid)
        .doc()
        .id;
    return RepaintBoundary(
      key: scr,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.ds['category']), actions: [
          GestureDetector(
              onTap: () {
                if (_fontsize > 40) {
                  setState(() {
                    _fontsize = 18;
                  });
                } else {
                  setState(() {
                    _fontsize = _fontsize + 4;
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.font_download_rounded),
              )),
          IconButton(
              onPressed: () async {
                if (widget.id.contains(widget.ds['title'])) {
                  widget.id.remove(widget.ds['title']);
                  database = await FirebaseDb().main2();
                  await FirebaseDb().deleteBM(database, widget.ds['title']);
                  await FirebaseDb().removebookmark(uid, docid);
                  setState(() {});
                  Fluttertoast.showToast(
                    msg: "Removed From Bookmarks",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                  );
                } else {
                  widget.id.add(widget.ds['title']);
                  database = await FirebaseDb().main2();
                  await FirebaseDb().insertbookmark(
                      database,
                      Bookmark(
                        id: widget.ds['title'],
                      ));
                  await FirebaseDb().addBookmark(
                    docid,
                    uid,
                    widget.ds['title'],
                    widget.ds['image_url'],
                    widget.ds['description'],
                    widget.ds['date'].toString(),
                    widget.ds['category'],
                    widget.ds['username'],
                  );
                  Fluttertoast.showToast(
                    msg: "Added to Bookmarks",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                  );
                }
              },
              icon: Icon(Icons.bookmark)),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              takescrshot();
            },
          ),
        ]),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          //padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.ds['title'],
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    )),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'By ' + widget.ds['username'].toString(),
                        style: TextStyle(
                            color: Colors.grey.shade500, fontSize: 16),
                      ), //reporters name here
                      Text('Published on ' + widget.ds['date'].toString(),
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 14)),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(widget.ds['image_url']),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.ds['description'],
                          style: TextStyle(fontSize: _fontsize),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    /*
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(widget.ds['date'].toString())),
                     */
                  ],
                ),
              ),
              // Text(widget.ds['category']),
            ],
          ),
        ),
      ),
    );
  }
}
