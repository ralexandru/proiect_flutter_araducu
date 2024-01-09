import 'package:flutter/material.dart';
import 'package:proiect_flutter_araducu/NavigationDrawer.dart';
import 'package:proiect_flutter_araducu/UsersList.dart';
import 'package:proiect_flutter_araducu/classes/DomainOfStudy.dart';
import 'classes/Course.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';
import 'classes/CourseMeeting.dart';
import 'dart:io';
import 'Files.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'classes/File.dart';

class CoursePage extends StatefulWidget {
  final int? CourseId;
  final String title;
  final bool isEnrolled;
  final Course course;
  CoursePage({
    Key? key,
    required this.title,
    required this.CourseId,
    required this.isEnrolled,
    required this.course,
  }) : super(key: key);

  @override
  _CoursePageState createState() => _CoursePageState();
}
class _CoursePageState extends State<CoursePage> {
  ScrollController _scrollController = ScrollController();

   void _openFilePicker(Course course) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;
        if (file.path != null) {
          List<int> bytes = await File(file.path!).readAsBytes();
          print('File picked: ${file.name}');
          String fileExtension = file.extension ?? 'Unknown';
          widget.course.fileData = Uint8List.fromList(bytes);
          print('ORIGINAL FILE: $bytes');
          print('FILE UPLOAD: ${widget.course.fileData}');
          setState(() {
            course.fileData = Uint8List.fromList(bytes);
            UpdateCourseBanner(course);
          });
          setState((){
          });
        } else {
          print('File path is null.');
        }
      } else {
        print('No file selected.');
      }
    } catch (e) {
      print('Error picking file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    
    fetchCourseInfo(widget.CourseId);
    return 
    Scaffold(
      appBar: AppBar(
        // The title text which will be shown on the action bar
        title: Text(widget.title, style: TextStyle(color: Colors.blue)),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () {
            // Add your back button functionality here
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FutureBuilder<Course>(
        future: fetchCourseInfo(widget.CourseId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [CircularProgressIndicator(), SizedBox(height:10), Text("We're retrieving course info..")])); // or a loading indicator
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Text('No course data available');
          } 
          
            Course course = snapshot.data!;
            int? idDomain = course.DomainId;
            print("ID DOMAIN: $idDomain");
            return FutureBuilder<DomainOfStudy>(
        future: fetchDomainInfo(idDomain),
        builder: (context, domainSnapshot) {
          if (domainSnapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (domainSnapshot.hasError) {
            return Text('Error: ${domainSnapshot.error}');
          } else if (!domainSnapshot.hasData || domainSnapshot.data == null) {
            return Text('No domain data available');
          } else {
            DomainOfStudy domain = domainSnapshot.data!;
           return FutureBuilder<List<Course>>(
                  future: fetchDataBookmark('https://localhost:7097/api/Courses/cursuri-bookmark?utilizatorId=$userId'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Text('No bookmarked courses available');
          } else {
            List<Course> bookmarkedCourses = snapshot.data!;
            bool isBookmarked = bookmarkedCourses.any((course) => course.CourseId == widget.CourseId);

        return SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        child: SizedBox(
          child: Column(
            children: [
              Stack(
                children: [
                  if(course.fileData == null)
                  Image.network(
                      'https://img.jagranjosh.com/imported/images/E/Articles/CBSE-Class-12-Maths-Sample-Paper-2020-Download-PDF-Body-Images.jpg',
                      width: double.infinity,
                      fit: BoxFit.cover),
                  if(course.fileData != null)
                      Image.memory(course.fileData!),
                  Positioned(
                    bottom: 0,
                    child: SizedBox(
                      width: (MediaQuery.of(context).size.width),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          margin: EdgeInsets.all(16.0),
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue),
                              color: Colors.white.withOpacity(0.9),
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
                              Row(children: [
                                Icon(Icons.info, color: Colors.blue),
                                Text("Course information",
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.blue,
                                    ))
                              ]),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(Icons.people, color: Colors.black),
                                  Text(
                                    course.AvailableSeats.toString(),
                                    style: TextStyle(fontSize: 18),
                                  )
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(Icons.calendar_month,
                                      color: Colors.black),
                                  Text(DateFormat('yyyy-MM-dd').format(course.StartDate) + '-' + DateFormat('yyyy-MM-dd').format(course.FinishDate),
                                      style: TextStyle(fontSize: 18)),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              if(nivelAcces==3)
              Container(margin: EdgeInsets.symmetric(horizontal: 20), child: OutlinedButton(child: Row(children: [Icon(Icons.edit),SizedBox(width:15),Text('Upload new banner picture')]), onPressed: () => {
                _openFilePicker(course)
              })),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                if(!widget.isEnrolled)
                OutlinedButton(
                  onPressed: () => {},
                  child: Text('Enroll into course',
                      style: TextStyle(color: Colors.green)),
                ),
                if(widget.isEnrolled)
                 OutlinedButton(
                  onPressed: () => {
                    
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                            Files(title: "test", courseId: widget.CourseId ?? 0)))
                  },
                  child: Row(children: [Icon(Icons.file_copy, color: Colors.blue,),Text('Files',
                      style: TextStyle(color: Colors.blue))]),
                ),
                SizedBox(width: 10),
                if(!isBookmarked)
                OutlinedButton(
                  onPressed: () => {
                    CreateBookmark(course.CourseId!, userId),
                                        setState((){
                      isBookmarked=true;
                    })
                  },
                  child: Row(children: [Icon(Icons.star),Text('Add course to favorites')]),
                ),
          
              if(isBookmarked)
                              OutlinedButton(
                  onPressed: () => {
                    DeleteBookmark(course.CourseId!, userId),
                    setState((){
                      isBookmarked=false;
                    })
                  },
                  child: Row(children: [Icon(Icons.star),Text('Remove course from favorites')]),
                ),
              ]),
                SizedBox(width: 10),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 25),
                  child: OutlinedButton(
                    onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                            UsersList(title: 'Users enrolled', byCourse: true, courseId: course.CourseId)))
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Center content horizontally
                      children: [
                        Icon(Icons.people),
                        SizedBox(width: 8), // Adjust the spacing between icon and text
                        Text('Users enrolled in this course'),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 10),
              Row(children: [
                SizedBox(width: 20),
                Icon(Icons.school, color: Colors.blue),
                SizedBox(width: 5),
                Text('Domains of Study: ', style: TextStyle(fontSize: 16)),
                SizedBox(width: 5),
                OutlinedButton(
                    onPressed: () => {},
                    child: Text(domain.domainName, style: TextStyle(color: Colors.blue)),
                    style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.blue))),
              ]),
              SizedBox(
                width: MediaQuery.of(context).size.width,
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
                      Row(children: [
                        Icon(Icons.description, color: Colors.blue),
                        SizedBox(width: 5),
                        Text("Course description",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.blue,
                            ))
                      ]),
                      SizedBox(height: 10),
                      Text(
                          course.CourseLongDescription),
                    ],
                  ),
                ),
              ),
              Text('Course Program',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                  )),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 50.0),
                child: Divider(
                  color: Colors.blue,
                  thickness: 1,
                ),
              ),
              Column(children: createContainers(course.meetings),)

            ],
          ),
        ));
        }
        }
      );
      }
  });})
    );
  }
}

List<Widget> createContainers(List<CourseMeeting>? meetings) {
  List<Widget> containers = [];

  if (meetings != null)
    for (int i = 0; i < meetings.length; i++) {
      bool edit = false;

      Container container = Container(
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
          crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
          children: [
            Text(
              meetings[i].CourseMeetingName,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Row(
              children: [
                Icon(Icons.calendar_month),
                SizedBox(width: 6),
                Text(
                  DateFormat('yyyy-MM-dd hh:mm').format(meetings[i].CourseMeetingDate),
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      );

      containers.add(container);
    }
  return containers;
}