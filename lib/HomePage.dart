import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app_user/Screens/DataViewScreen.dart';

Stream<List<Photo>> getphotos(
    Duration refreshTime, http.Client client, String category) async* {
  while (true) {
    await Future.delayed(refreshTime);
    yield await fetchPhotos(client, category);
  }
}

Future<List<Photo>> fetchPhotos(http.Client client, String category) async {
  final response = await client.get(Uri.parse(
      'https://saurav.tech/NewsAPI/top-headlines/category/$category/in.json'));

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parsePhotos, response.body);
}

Stream<List<Photo>> getallnews(
    Duration refreshTime, http.Client client) async* {
  while (true) {
    await Future.delayed(refreshTime);
    yield await fetchallnews(client);
  }
}

Future<List<Photo>> fetchallnews(http.Client client) async {
  final response = await client
      .get(Uri.parse('https://saurav.tech/NewsAPI/everything/bbc-news.json'));
  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parsePhotos, response.body);
}

// A function that converts a response body into a List<Photo>.
List<Photo> parsePhotos(String responseBody) {
  final parsed =
      jsonDecode(responseBody)['articles'].cast<Map<String, dynamic>>();

  return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
}

class Photo {
  final String title;
  final String urlToImage;
  final String content;
  Photo({
    required this.title,
    required this.urlToImage,
    required this.content,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      title: json['title'] as String,
      urlToImage: json['urlToImage'] != null
          ? json['urlToImage']
          : 'https://mea.nipponpaint-autorefinishes.com/wp-content/uploads/sites/18/2017/07/No-image-found.jpg',
      content: json['content'] != null ? json['content'] : 'No data Found',
    );
  }
}

class HomePage extends StatefulWidget {
  String category;
  HomePage({this.category = 'bbc-news'});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Photo>>(
        stream: widget.category == 'bbc-news'
            ? getallnews(Duration(milliseconds: 10), http.Client())
            : getphotos(Duration(seconds: 1), http.Client(), widget.category),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  DataViewPage(snapshot.data![index])),
                        );
                      },
                      child: Material(
                        elevation: 20,
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: ListTile(
                            leading: Container(
                              height: 50,
                              width: 50,
                              child: CachedNetworkImage(
                                imageUrl:
                                    snapshot.data![index].urlToImage.toString(),
                              ),
                            ),
                            title: Text(snapshot.data![index].title.toString()),
                            subtitle:
                                Text(snapshot.data![index].content.toString()),
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
