import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:proiect_flutter_araducu/NavigationDrawer.dart';
import 'package:proiect_flutter_araducu/classes/Course.dart';
import 'Profile.dart';
import 'Courses.dart';
import 'classes/News.dart';
import 'commonClasses/NewsP.dart';
import 'classes/CarouselImage.dart';
class Home extends StatefulWidget {
  const Home();
  @override
  _HomeState createState() => _HomeState();
}

List<News> news = [];
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

List<Widget> createNewsCard(List<News> newsList) {
  print("LENGTH: ${newsList.length}");
  List<Widget> containers = [];
  for (int i = 0; i < newsList.length; i++) {
    if (newsList[i] != null && newsList[i].newsId != null) {
      SizedBox sizedBox = SizedBox(
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
            ],
          ),
          child: Column(
            children: [
              Text(
                newsList[i].newsName ?? '',
                style: TextStyle(
                  fontSize: 23,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 12),
              Text(
                (newsList[i].newsContent ?? '') + '...',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 10),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewsPage(news: newsList[i]),
                    ),
                  );
                },
                child: Text('Read more'),
              ),
              SizedBox(height: 10),
              if (nivelAcces == 3)
                OutlinedButton(
                  onPressed: () {
                    DeleteNewsApp(newsList[i].newsId!);
                  },
                  child: Text('Delete'),
                ),
            ],
          ),
        ),
      );
      containers.add(sizedBox);
    }
  }
  return containers;
}

List<Widget> createDomainsContainer(List<String> domains){
  List<Widget> container = [];
  for(int i = 0; i < domains.length; i++){
    SizedBox sizedBox = SizedBox(width:10);
    Row row = Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      OutlinedButton(
      child: Text(domains[i]),
      onPressed: () => {},)]);
    container.add(sizedBox);
    container.add(row);
  }
  return container;
}
void DeleteNewsApp(int newsId){
  DeleteNews(newsId);
  setState(() {
    news.removeWhere((newsItem) => newsItem.newsId == newsId);
  });
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
                    FutureBuilder(
              future: fetchCourseNumbers(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  // Safely access the data
                  String coursesNo = snapshot.data as String;
                  return Text(coursesNo, style: TextStyle(fontSize: 30));
                }}),
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
                    FutureBuilder(
              future: fetchDomainsEnrolled(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  // Safely access the data
                  List<String>? domains = snapshot.data as List<String>?;

                  if (domains != null && domains.isNotEmpty) {
                    
                    return Row(mainAxisAlignment: MainAxisAlignment.center, children: createDomainsContainer(domains));
                  }else {
                    return Text('No news for the moment..');
                  }
                }
              },
            )
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
            FutureBuilder(
              future: retrieveNews(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  // Safely access the data
                  List<News>? newsList = snapshot.data as List<News>?;

                  if (newsList != null && newsList.isNotEmpty) {
                    return Column(
                      children: createNewsCard(newsList),
                    );
                  } else {
                    return Text('No news for the moment..');
                  }
                }
              },
            )
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
            //OutlinedButton(onPressed: NewsPage(news: news[i]), child: Text('Read more')),
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
  final String image;

  MyCard(this.image, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (image.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(image),
              fit: BoxFit.fill,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
        ),
      );
    } else {
      // Handle the case when the image URL is empty
      return Placeholder(); // Replace with your desired placeholder
    }
  }
}


class Carousel extends StatefulWidget {
  Carousel({Key? key}) : super(key: key);

  @override
  State<Carousel> createState() => _CarouselState();
}
class _CarouselState extends State<Carousel> {
  List<Color> colors = [Colors.teal, Colors.blue, Colors.pink];
  List<CarouselImage> images = [];
  int position = 0;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    try {
      List<CarouselImage> loadedImages = await retrieveImages();
      setState(() {
        images = loadedImages;
      });
    } catch (error) {
      print('Error loading images: $error');
    }
  }

  Widget myCircle(int p) {
    return Container(
      height: 15,
      width: 15,
      decoration: BoxDecoration(
        color: position == p ? colors[p] : Colors.grey.shade300,
        borderRadius: const BorderRadius.all(Radius.circular(25)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 255,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 225,
            child: PageView.builder(
              key: Key("carousel_page_view"),
              onPageChanged: (pageposition) {
                print('Page changed: $pageposition');
                setState(() {
                  position = pageposition;
                });
              },
              itemCount: images.length,
              itemBuilder: (context, pagePosition) {
                return MyCard(images[pagePosition].ImageUrl);
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              myCircle(0),
              const SizedBox(width: 10),
              myCircle(1),
              const SizedBox(width: 10),
              myCircle(2),
            ],
          ),
        ],
      ),
    );
  }
}