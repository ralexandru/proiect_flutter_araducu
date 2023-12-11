import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:proiect_flutter_araducu/NavigationDrawer.dart';
import '../Profile.dart';
import '../Courses.dart';
import '../classes/News.dart';
class NewsPage extends StatefulWidget {
  News news;
  NewsPage({Key? key, required this.news}) : super(key: key);

  @override
  NewsPageState createState() => NewsPageState();
}

class NewsPageState extends State<NewsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Back to home", style: TextStyle(color: Colors.blue)),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(widget.news.newsName, style: TextStyle(fontSize: 23)),
            SizedBox(height: 10),
            Text(
              "Published on: " + widget.news.newsPublishDate.toString(),
              style: TextStyle(fontSize: 16),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 50.0),
              child: Divider(
                color: Colors.blue,
                thickness: 1,
              ),
            ),
            SizedBox(height: 0),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Text(
                widget.news.newsContent,
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
