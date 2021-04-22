import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app_user/Database.dart';

class HoroscopeDataPage extends StatefulWidget {
  String sign;
  HoroscopeDataPage(this.sign);
  @override
  _HoroscopeDataState createState() => _HoroscopeDataState();
}

class _HoroscopeDataState extends State<HoroscopeDataPage> {
  String uid = FirebaseDb().getuid().toString();
  late String data;
  int count = 0;
  DateTime currentDate = DateTime.now();
  late String updateddata;
  var translate = {
    'aries': 'मेष',
    'taurus': 'वृषभ',
    'gemini': 'मिथुन',
    'cancer': 'कर्क',
    'leo': 'सिंह',
    'virgo': 'कन्या',
    'libra': 'तुला',
    'scorpio': 'वृश्चिक',
    'sagittarius': 'धनुराशि',
    'capricorn': 'मकर',
    'aquarius': 'कुंभ',
    'pisces': 'मीन',
  };
  double fontSize = 20;
  @override
  Widget build(BuildContext context) {
    print(widget.sign);
    return Scaffold(
      appBar: AppBar(
        title: Text(translate[widget.sign]!),
        actions: [
          GestureDetector(
            onTap: () {
              if (fontSize < 44)
                setState(() {
                  fontSize = fontSize + 4;
                });
              else
                setState(() {
                  fontSize = 20;
                });
            },
            child: Container(
              margin: EdgeInsets.only(right: 20),
              child: Icon(Icons.font_download_rounded),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(widget.sign)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Text('No Data available'));
          } else {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data!.docs[index];
                  String docid = ds.id;
                  if (count == 0) {
                    FirebaseDb().updatezodiacvalue(docid, 'views', widget.sign);
                    count += 1;
                  }
                  return GestureDetector(
                    child: Container(
                      child: Card(
                        elevation: 5,
                        margin: EdgeInsets.all(10),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ds['date'].toString(),
                                style: TextStyle(),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                ds['data'],
                                style: TextStyle(fontSize: fontSize),
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
