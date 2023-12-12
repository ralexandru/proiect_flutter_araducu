import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:proiect_flutter_araducu/CoursePage.dart';
import 'NavigationDrawer.dart';
import 'classes/Course.dart';
import 'dart:typed_data';

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

class BookMarkedCourse extends StatefulWidget {
  const BookMarkedCourse({super.key});
  @override
  State<BookMarkedCourse> createState() => _BookmarkedState();
}

class _BookmarkedState extends State<BookMarkedCourse> {
  List<Course> bookmarkedCourses = [];
  bool isLoadingCourses = true;

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    try {
      await fetchData('https://localhost:7097/api/Courses/cursuri-bookmark?utilizatorId=${user!.userId}')
          .then((data) {
        if (data.isNotEmpty) {
          print(data[0].CourseName);
          setState(() {
            bookmarkedCourses = data;
          });
        } else {
          print('Error: Empty data for bookmarked courses');
        }
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
    );
  }

@override
Widget build(BuildContext context) {
  print('Number of courses: ${bookmarkedCourses.length}');
  return Scaffold(
    appBar: buildAppBar(context),
    body: Column(
      children: <Widget>[
        if (isLoadingCourses)
          Center(
            child: CircularProgressIndicator(),
          )
        else if (bookmarkedCourses.isNotEmpty)
          Expanded(
            child: ListView.builder(
              itemCount: bookmarkedCourses.length,
              itemBuilder: (BuildContext context, int index) {
                return CourseContainer(
                  type: 0,
                  isEnrolled: true,
                  course: bookmarkedCourses[index],
                  onPressed: () {
                    // Do nothing here or add any specific logic you need
                  },
                );
              },
            ),
          )
        else
          Center(
            child: Text("Your bookmarks will appear here."),
          ),
      ],
    ),
  );
}
}

class CourseContainer extends StatefulWidget {
  final VoidCallback onPressed;
  final int type;
  final Course course;
  final bool isEnrolled;

  CourseContainer(
      {required this.course, required this.onPressed, required this.type, required this.isEnrolled});

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
    Container(
      width: 200, // Adjust the width as needed
      child: TextButton(
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
              builder: (context) => CoursePage(
                title: "Back to courses",
                CourseId: widget.course.CourseId,
                isEnrolled: widget.isEnrolled,
                course: widget.course,
              ),
            ),
          );
        },
        child: const Text('More details'),
      ),
    ),
  ],
          ),
        ],
      ),
    );
  }
}
