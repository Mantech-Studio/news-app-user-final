import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LiveScorePage extends StatefulWidget {
  late int seriesid;
  late int matchid;
  LiveScorePage(this.seriesid, this.matchid);
  @override
  _LiveScorePageState createState() => _LiveScorePageState();
}

//
// List parsenews(String responseBody) {
//   final parsed = jsonDecode(responseBody);
//   return parsed;
// }

class _LiveScorePageState extends State<LiveScorePage> {
  var data;
  bool loading = false;
  Future fetchcricketnews(http.Client client, int seriesid, int matchid) async {
    const _api_key = "a164ce2366msh9b1254f5dba4b42p12da44jsne2d09d2454e1";

    // Base headers for Response url
    const Map<String, String> _headers = {
      "x-rapidapi-host": "dev132-cricket-live-scores-v1.p.rapidapi.com",
      "x-rapidapi-key": _api_key,
      "content-type": "application/json",
    };
    Uri uri = Uri.parse(
        "https://dev132-cricket-live-scores-v1.p.rapidapi.com/matchdetail.php?seriesid=$seriesid&matchid=$matchid");
    final response = await client.get(uri, headers: _headers);
    setState(() {
      data = jsonDecode(response.body);
      loading = true;
    });
    return jsonDecode(response.body);
  }

  @override
  void initState() {
    super.initState();
    fetchcricketnews(http.Client(), widget.seriesid, widget.matchid);
  }

  @override
  Widget build(BuildContext context) {
    if (loading == true) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Live Cricket'),
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Padding(
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 150,
                                        child: AutoSizeText(
                                          data['meta']['series']['name']
                                              .toString(),
                                          maxFontSize: 18,
                                          minFontSize: 14,
                                          style: TextStyle(
                                              fontSize: 6,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue),
                                        ),
                                      ),
                                      Container(
                                        width: 100,
                                        child: AutoSizeText(
                                          data['matchDetail']['matchSummary']
                                                  ['status']
                                              .toString(),
                                          maxFontSize: 18,
                                          minFontSize: 14,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green),
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
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      //Team 1 Box
                                      Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                child: Row(
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context).size.width * 0.2,
                                                  height: MediaQuery.of(context).size.width * 0.2,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20),
                                                    image: DecorationImage(image: NetworkImage(data['matchDetail']['matchSummary']['homeTeam']['logoUrl'].toString()),fit: BoxFit.contain),
                                                  ),
                                                  //child: Image.network(data['matchDetail']['matchSummary']['homeTeam']['logoUrl'].toString(),fit: BoxFit.fill,),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(data['matchDetail']
                                                                        [
                                                                        'matchSummary']
                                                                    ['scores']
                                                                ['homeScore']
                                                            .toString()), //score
                                                        //wickets
                                                      ],
                                                    ),
                                                    Text(
                                                        '(${data['matchDetail']['matchSummary']['scores']['homeOvers'].toString()})'), //overs
                                                  ],
                                                )
                                              ],
                                            )),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              data['matchDetail']
                                                          ['matchSummary']
                                                      ['homeTeam']['shortName']
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            )
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
                                                  MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(data['matchDetail']
                                                                          [
                                                                          'matchSummary']
                                                                      ['scores']
                                                                  ['awayScore']
                                                              .toString()), //wickets
                                                        ],
                                                      ),
                                                      Text(
                                                          '(${data['matchDetail']['matchSummary']['scores']['awayOvers'].toString()})'), //overs
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context).size.width * 0.2,
                                                  height: MediaQuery.of(context).size.width * 0.2,
                                                  child: CachedNetworkImage(
                                                    imageUrl: data['matchDetail']
                                                                ['matchSummary']
                                                            [
                                                            'awayTeam']['logoUrl']
                                                        .toString(),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: NetworkImage(data[
                                                                          'matchDetail']
                                                                      [
                                                                      'matchSummary']
                                                                  ['awayTeam'][
                                                              'backgroundImageUrl']
                                                          .toString()),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              data['matchDetail']
                                                          ['matchSummary']
                                                      ['awayTeam']['shortName']
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width -
                                          40,
                                      child: Text(
                                        data['matchDetail']['matchSummary']
                                                ['matchSummaryText']
                                            .toString(),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      )),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    data['meta']['matchName'].toString(),
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    data['matchDetail']['tossMessage']
                                        .toString(),
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Currently Batting',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            data['matchDetail']
                                                            ['currentBatters']
                                                        [0]['name']
                                                    .toString() +
                                                ': ' +
                                                data['matchDetail']
                                                            ['currentBatters']
                                                        [0]['runs']
                                                    .toString() +
                                                ' (${data['matchDetail']['currentBatters'][0]['ballsFaced'].toString()})',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            data['matchDetail']
                                                            ['currentBatters']
                                                        [1]['name']
                                                    .toString() +
                                                ': ' +
                                                data['matchDetail']
                                                            ['currentBatters']
                                                        [1]['runs']
                                                    .toString() +
                                                ' (${data['matchDetail']['currentBatters'][1]['ballsFaced'].toString()})',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text('Currently Bowling',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14)),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            data['matchDetail']['bowler']
                                                        ['name']
                                                    .toString() +
                                                ': ' +
                                                data['matchDetail']['bowler']
                                                        ['wickets']
                                                    .toString() +
                                                '/' +
                                                data['matchDetail']['bowler']
                                                        ['runsAgainst']
                                                    .toString() +
                                                '(${data['matchDetail']['bowler']['bowlerOver'].toString()})',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ],
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
              ],
            ),
          ));
    } else {
      return Scaffold(
          backgroundColor: Theme.of(context).accentColor,
          body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Text('Please wait while we fetch data',style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),overflow: TextOverflow.clip,textAlign: TextAlign.center,),
          SizedBox(height: 10,),
            CircularProgressIndicator(
            backgroundColor: Theme.of(context).accentColor,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      )));
    }
  }
}
