import 'dart:ui';
import 'package:flutter/material.dart';
import 'Profile.dart';
import 'Courses.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(height: 20),
            Carousel(),
            SizedBox(height: 30),
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  CircularButton(
                    iconData: Icons.person,
                    onPressed: () => {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Profile()))
                    },
                    color: Colors.blue,
                  ),
                  SizedBox(width: 20),
                  CircularButton(
                    iconData: Icons.book,
                    onPressed: () => {},
                    color: Colors.blue,
                  ),
                  SizedBox(width: 20),
                  CircularButton(
                    iconData: Icons.school,
                    onPressed: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CoursesPage()))
                    },
                    color: Colors.blue,
                  ),
                  SizedBox(width: 20),
                  CircularButton(
                    iconData: Icons.exit_to_app,
                    onPressed: () => {Navigator.pop(context)},
                    color: Colors.red,
                  ),
                ]),
              ),
            ),
            SizedBox(height: 30),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.bar_chart, color: Colors.blue),
              Text('Your activity: ',
                  style: TextStyle(fontSize: 20, color: Colors.blue)),
            ]),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 50.0),
              child: Divider(
                color: Colors.blue,
                thickness: 1,
              ),
            ),
            SizedBox(
              child: Container(
                margin: EdgeInsets.all(16.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      )
                    ]),
                child: Column(children: [
                  Column(children: [
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.blue, size: 30),
                        Text("Enrolled courses: ",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: '',
                                color: Colors.blue))
                      ],
                    ),
                    Text("10", style: TextStyle(fontSize: 30)),
                    OutlinedButton(
                      child: Text('Enroll in more courses',
                          style: TextStyle(
                            color: Colors.blue,
                          )),
                      onPressed: () => {},
                    )
                  ]),
                  SizedBox(height: 10),
                  Column(children: [
                    Row(
                      children: [
                        Icon(Icons.book, color: Colors.blue, size: 30),
                        Text(
                          "Domains of Study: ",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: '',
                              color: Colors.blue),
                          softWrap: true,
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      OutlinedButton(
                        child: Text('Math'),
                        onPressed: () => {},
                      ),
                      SizedBox(width: 10),
                      OutlinedButton(
                        child: Text('English'),
                        onPressed: () => {},
                      )
                    ]),
                  ])
                ]),
              ),
            ),
            SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.newspaper, color: Colors.blue),
              Text("News: ",
                  style: TextStyle(fontSize: 20, color: Colors.blue)),
            ]),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 50),
                child: Divider(color: Colors.blue, thickness: 1)),
            Text('Keep being up-to-date with our latest news!',
                style: TextStyle(color: Colors.blue)),
            NewsCard(
              newsTitle: "test",
              newsShortDesc:
                  "Aceasta este o descriere mai scurta, care as vrea sa se intinda pe mai multe randuri",
              onPressed: () => {},
            ),
          ],
        ),
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final String newsTitle;
  final String newsShortDesc;
  final VoidCallback onPressed;
  const NewsCard({
    Key? key,
    required this.newsTitle,
    required this.newsShortDesc,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        margin: EdgeInsets.all(16.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              )
            ]),
        child: Column(
          children: [
            Text(newsTitle,
                style: TextStyle(
                  fontSize: 23,
                  color: Colors.black,
                )),
            SizedBox(height: 12),
            Text(newsShortDesc + "...",
                style: TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 10),
            OutlinedButton(onPressed: onPressed, child: Text('Read more'))
          ],
        ),
      ),
    );
  }
}

class CircularButton extends StatelessWidget {
  final IconData iconData;
  final VoidCallback onPressed;
  final Color color;

  const CircularButton({
    Key? key,
    required this.iconData,
    required this.onPressed,
    required this.color,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 50.0,
        height: 50.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: Center(
          child: Icon(
            iconData,
            color: Colors.white,
            size: 30.0,
          ),
        ),
      ),
    );
  }
}

class MyCard extends StatelessWidget {
  final Color containerColor = Colors.red;
  final String image;
  MyCard(this.image, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Container(
        decoration: BoxDecoration(
            image:
                DecorationImage(image: NetworkImage(image), fit: BoxFit.fill),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
      ),
    );
  }
}

class Carousel extends StatefulWidget {
  Carousel({Key? key}) : super(key: key);

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  List<Color> colors = [Colors.teal, Colors.blue, Colors.pink];
  List<String> images = [''];
  int position = 0;
  @override
  Widget build(BuildContext context) {
    Widget myCircle(int p) {
      return Container(
        height: 15,
        width: 15,
        decoration: BoxDecoration(
            color: position == p ? colors[p] : Colors.grey.shade300,
            borderRadius: const BorderRadius.all(Radius.circular(25))),
      );
    }

    return SizedBox(
      height: 255,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 225,
            child: PageView.builder(
                onPageChanged: (pageposition) {
                  setState(() {
                    position = pageposition;
                  });
                },
                itemCount: colors.length,
                itemBuilder: (context, pagePosition) {
                  return MyCard(images[pagePosition]);
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              myCircle(0),
              const SizedBox(
                width: 10,
              ),
              myCircle(1),
              const SizedBox(
                width: 10,
              ),
              myCircle(2),
            ],
          )
        ],
      ),
    );
  }
}
