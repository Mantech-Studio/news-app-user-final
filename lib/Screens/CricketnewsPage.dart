import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app_user/Screens/CovidDataPage.dart';
import 'package:news_app_user/Screens/LiveScorePage.dart';
import 'package:auto_size_text/auto_size_text.dart';

Future<List<Cricket>> fetchcricketnews(http.Client client) async {
  const _api_key = "a164ce2366msh9b1254f5dba4b42p12da44jsne2d09d2454e1";
  // Base API url
  const String _baseUrl =
      "https://dev132-cricket-live-scores-v1.p.rapidapi.com/matches.php";
  // Base headers for Response url
  const Map<String, String> _headers = {
    "x-rapidapi-host": "dev132-cricket-live-scores-v1.p.rapidapi.com",
    "x-rapidapi-key": _api_key,
    "content-type": "application/json",
  };
  Uri uri = Uri.parse(_baseUrl);
  final response = await client.get(uri, headers: _headers);
  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parsenews, response.body);
}

List<Cricket> parsenews(String responseBody) {
  final parsed = jsonDecode(responseBody)['matchList']['matches']
      .cast<Map<String, dynamic>>();

  return parsed.map<Cricket>((json) => Cricket.fromJson(json)).toList();
}

class Cricket {
  final int id;
  final int matchTypeId;
  final int seriesId;
  final String seriesname;
  final String status;
  final String venue;
  final String hometeam;
  final String awayteam;
  final String matchsummary;
  final String homescore;
  final String homeovers;
  final String awayscore;
  final String awayovers;
  Cricket({
    required this.id,
    required this.matchTypeId,
    required this.seriesId,
    required this.seriesname,
    required this.status,
    required this.venue,
    required this.hometeam,
    required this.awayteam,
    required this.matchsummary,
    required this.homescore,
    required this.homeovers,
    required this.awayscore,
    required this.awayovers,
  });

  factory Cricket.fromJson(Map<String, dynamic> json) {
    return Cricket(
      id: json['id'],
      matchTypeId: json['matchTypeId'] ?? ' ',
      seriesId: json['series']['id'],
      seriesname: json['series']['shortName'] ?? ' ',
      status: json['status'] ?? ' ',
      venue: json['venue']['shortName'] ?? ' ',
      hometeam: json['homeTeam']['shortName'] ?? ' ',
      awayteam: json["awayTeam"]['shortName'] ?? ' ',
      matchsummary: json['matchSummaryText'],
      homescore: json['status'] == 'UPCOMING'
          ? json['startDateTime'].split('T')[0]
          : json["scores"]['homeScore'] as String,
      homeovers: json['status'] == 'UPCOMING'
          ? ' '
          : json["scores"]['homeOvers'] as String,
      awayscore: json['status'] == 'UPCOMING'
          ? json['startDateTime'].split('T')[1]
          : json["scores"]['awayScore'] as String,
      awayovers: json['status'] == 'UPCOMING'
          ? ' '
          : json["scores"]['awayOvers'] as String,
    );
  }
}

class CricketNews extends StatefulWidget {
  @override
  _CricketNewsState createState() => _CricketNewsState();
}

class _CricketNewsState extends State<CricketNews> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor.withOpacity(0.5),
      body: FutureBuilder<List<Cricket>>(
        future: fetchcricketnews(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    if (snapshot.data![index].seriesname == 'IPL 2021') {
                      return GestureDetector(
                        onTap: () {
                          if (snapshot.data![index].status != 'UPCOMING') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LiveScorePage(
                                        snapshot.data![index].seriesId,
                                        snapshot.data![index].id)));
                          }
                        },
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //Live Match Detail Box
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    child: AutoSizeText(
                                                      snapshot.data![index]
                                                          .seriesname,
                                                      minFontSize: 12,
                                                      maxFontSize: 18,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.blue),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                  child: Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: AutoSizeText(
                                                      snapshot
                                                          .data![index].status,
                                                      maxFontSize: 18,
                                                      minFontSize: 12,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.green),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                              width: double.infinity,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                //Team 1 Box
                                                Container(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                          child: Row(
                                                        children: [
                                                          Text(
                                                            snapshot
                                                                .data![index]
                                                                .hometeam,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16),
                                                          ),
                                                          SizedBox(
                                                            width: 30,
                                                          ),
                                                          Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(snapshot
                                                                      .data![
                                                                          index]
                                                                      .homescore), //score
                                                                  //wickets
                                                                ],
                                                              ),
                                                              Text(snapshot
                                                                  .data![index]
                                                                  .homeovers), //overs
                                                            ],
                                                          )
                                                        ],
                                                      )),
                                                    ],
                                                  ),
                                                ),
                                                //Team 2 Box
                                                Container(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Container(
                                                          child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(snapshot
                                                                      .data![
                                                                          index]
                                                                      .awayscore), //score
                                                                  //wickets
                                                                ],
                                                              ),
                                                              Text(snapshot
                                                                  .data![index]
                                                                  .awayovers), //overs
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            snapshot
                                                                .data![index]
                                                                .awayteam,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16),
                                                          ),
                                                        ],
                                                      )),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    40,
                                                child: Text(
                                                  snapshot.data![index]
                                                      .matchsummary,
                                                  textAlign: TextAlign.center,
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                )),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            snapshot.data![index].status !=
                                                    'UPCOMING'
                                                ? Text(
                                                    'Tap to view full match Details',
                                                    style: TextStyle(
                                                        color: Colors.black54,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  )
                                                : Text(
                                                    'Match details not available',
                                                    style: TextStyle(
                                                        color: Colors.black54,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container(height: 0, width: 0);
                    }
                  },
                )
              : Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Please wait we are fetching the data for you',
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).accentColor),
                    ),
                  ],
                ));
        },
      ),
    );
  }
}
