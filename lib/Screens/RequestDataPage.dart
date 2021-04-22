import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:news_app_user/Database.dart';
import 'package:news_app_user/Screens/PageControllerScreen.dart';

class RequestDataPage extends StatefulWidget {
  @override
  _RequestDataPageState createState() => _RequestDataPageState();
}

class _RequestDataPageState extends State<RequestDataPage> {
  String uid = FirebaseDb().getuid();
  late String name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Data Page',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(children: [
        Container(
          padding: EdgeInsets.all(10),
          child: TextField(
            onChanged: (val) {
              setState(() {
                name = val;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              labelText: 'User Name',
              labelStyle: TextStyle(fontSize: 18),
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            await FirebaseDb().adduser(uid, name);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => PageControllerScreen()),
                (route) => false);
          },
          child: Container(
              color: Colors.blueAccent,
              width: 100,
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: Text(
                'Done',
                style: TextStyle(fontSize: 20, color: Colors.white),
              )),
        ),
      ]),
    );
  }
}
