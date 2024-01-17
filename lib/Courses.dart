import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:proiect_flutter_araducu/CoursePage.dart';
import 'NavigationDrawer.dart';
import 'classes/Course.dart';
import 'dart:typed_data';

List<String> differentCourses = <String>[
  'My courses',
  'All courses',
];

Future enrollIntoCourse(int courseId, int userId) async {
  print('enrollIntoCourse was called!');
  print('COURSE ID: ' + courseId.toString());
  print('USER ID: ' + userId.toString());
  HttpClient client = new HttpClient();
  client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
  HttpClientRequest request = await client.postUrl(Uri.parse(
      "https://localhost:7097/api/Courses/inscrie-cursant?CursId=${courseId}&UtilizatorId=${userId}"));
  request.headers.set('Content-Type', 'application/json');
  request.headers.set('Bearer', JWT);
  HttpClientResponse result = await request.close();
  if (result.statusCode == 200) {
    print("student inscris");
  } else {
    return null;
  }
}

Future<List<Course>> fetchData(String url) async {
  final client = HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
  try {
    final request = await client.getUrl(Uri.parse(url));
    final response = await request.close();
    if (response.statusCode == 200) {
      print(response.statusCode);
      final List<dynamic> data =
          json.decode(await response.transform(utf8.decoder).join());
      return data.map((courseData) {
        String? bannerImgString = courseData["bannerImg"];
        print("BANNER IMG STRING: $bannerImgString");
        Uint8List? fileData;
        if (bannerImgString != null) {
          List<int> decodedBytes = base64.decode(bannerImgString);
          fileData = Uint8List.fromList(decodedBytes);
        }
        return Course(
          CourseId: courseData['CursId'],
          CourseName: courseData['CursDenumire'],
          CourseShortDescription: courseData['CursScurtaDescriere'],
          CourseLongDescription: courseData['CursLungaDescriere'],
          StartDate: DateTime.parse(courseData['DataInceput']),
          FinishDate: DateTime.parse(courseData['DataFinal']),
          AvailableSeats: courseData['LocuriDisponibile'],
          Price: courseData['Pret'],
          DifficultyLevel: courseData['NivelDificultate'],
          fileData: fileData,
        );
      }).toList();
    } else {
      print('REQUEST STATUS FAILED WITH THE FOLLOWING CODE: ' +
          response.statusCode.toString());
      throw Exception('Failed to load data');
    }
  } finally {
    client.close();
  }
}

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});
  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  List<Course> courses = [];
  List<Course> coursesEnrolled = [];
  bool isLoadingCourses = true;

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    try {
      await fetchData('https://localhost:7097/api/Courses/cursuri-neinscris?utilizatorId=${user!.userId}')
          .then((data) {
        if (data.isNotEmpty) {
          print(data[0].CourseName);
          setState(() {
            courses = data;
          });
        } else {
          print('Error: Empty data for courses');
        }
      });
      await fetchData('https://localhost:7097/api/Courses/cursuri-inscris?utilizatorId=${user!.userId}')
          .then((data) {
        setState(() {
          coursesEnrolled = data;
        });
      });
    } catch (e) {
      print('Error fetching courses: $e');
    } finally {
      setState(() {
        isLoadingCourses = false;
      });
    }
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      notificationPredicate: (ScrollNotification notification) {
        return notification.depth == 1;
      },
      scrolledUnderElevation: 4.0,
      shadowColor: Theme.of(context).shadowColor,
      bottom: TabBar(
        tabs: <Widget>[
          Tab(
            icon: const Icon(Icons.person),
            text: differentCourses[0],
          ),
          Tab(
            icon: const Icon(Icons.book),
            text: differentCourses[1],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Number of courses: ${courses.length}');
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: buildAppBar(context),
        body: TabBarView(
          children: <Widget>[
            if (isLoadingCourses)
              Center(
                child: CircularProgressIndicator(),
              )
            else if (coursesEnrolled.isNotEmpty)
              ListView.builder(
                itemCount: coursesEnrolled.length,
                itemBuilder: (BuildContext context, int index) {
                  return CourseContainer(
                    type: 0,
                    isEnrolled: true,
                    course: coursesEnrolled[index],
                    onPressed: () {
                      // Do nothing here or add any specific logic you need
                    },
                    onDelete: () {

                    },
                  );
                },
              )
            else
              Center(
                child: Text("No enrolled courses."),
              ),
            if (isLoadingCourses)
              Center(
                child: CircularProgressIndicator(),
              )
            else if (courses.isNotEmpty)
              ListView.builder(
                itemCount: courses.length,
                itemBuilder: (BuildContext context, int index) {
                  return CourseContainer(
                    type: 1,
                    course: courses[index],
                    isEnrolled: false,
                    onPressed: () async {
                      int courseId = courses[index].CourseId ?? 0;
                      await enrollIntoCourse(courseId, userId);
                      setState(() {
                        courses.removeAt(index);
                      });
                      // Update UI after enrollment
                      fetchCourses();
                    },
                    onDelete: () async{
                      int courseId = courses[index].CourseId ?? 0;
                      await DeleteCourse(courseId);
                      setState(() {
                        courses.removeAt(index);
                      });
                      // Update UI after enrollment
                      fetchCourses();
                    },
                  );
                },
              )
            else
              Center(
                child: Text("No available courses."),
              ),
          ],
        ),
      ),
    );
  }
}

class CourseContainer extends StatefulWidget {
  final VoidCallback onPressed;
  final VoidCallback onDelete;
  final int type;
  final Course course;
  final bool isEnrolled;

  CourseContainer(
      {required this.course, required this.onPressed, required this.type, required this.isEnrolled, required this.onDelete});

  @override
  _CourseContainerState createState() => _CourseContainerState();
}

class _CourseContainerState extends State<CourseContainer> {
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.book),
            title: Text(widget.course.CourseName),
            subtitle: Text(
              '${DateFormat('yyyy-MM-dd').format(widget.course.StartDate)} - ${DateFormat('yyyy-MM-dd').format(widget.course.FinishDate)}',
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.course.CourseShortDescription,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (widget.type == 1)
                TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  onPressed: () {
                    widget.onPressed();
                  },
                  child: const Text('Enroll into course'),
                ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 146, 206, 255)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CoursePage(title: "Back to courses", CourseId: widget.course.CourseId,isEnrolled: widget.isEnrolled, course: widget.course)));
                },
                child: const Text('More details'),
              ),
              if (nivelAcces > 0)
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 156, 52, 24)),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  onPressed: () {
                    widget.onDelete();
                  },
                  child: const Text('Delete'),
                ),
            ],
          ),
          if(widget.course.fileData == null)
            Image.network(
                'https://img.jagranjosh.com/imported/images/E/Articles/CBSE-Class-12-Maths-Sample-Paper-2020-Download-PDF-Body-Images.jpg'),
          if(widget.course.fileData != null)
            Image.memory(widget.course.fileData!)
        ],
      ),
    );
  }
}
