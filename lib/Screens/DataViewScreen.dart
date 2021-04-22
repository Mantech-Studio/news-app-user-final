import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DataViewPage extends StatelessWidget {
  var data;
  DataViewPage(this.data);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(data.title.toString(),style: TextStyle(fontSize: 18),),
          Container(
            child: CachedNetworkImage(
              imageUrl: data.urlToImage.toString(),
            ),
          ),
          Text(data.content.toString()),
        ],
      ),
    ));
  }
}
