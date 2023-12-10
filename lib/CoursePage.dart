import 'package:flutter/material.dart';
import 'package:proiect_flutter_araducu/classes/DomainOfStudy.dart';
import 'classes/Course.dart';
import 'package:intl/intl.dart';
import 'classes/CourseMeeting.dart';
import 'Files.dart';

class CoursePage extends StatelessWidget {
  int? CourseId;
  final ScrollController _scrollController = new ScrollController();
  final String title;
  final bool isEnrolled;
  CoursePage({super.key, required this.title, required this.CourseId, required this.isEnrolled});

  @override
  Widget build(BuildContext context) {
    fetchCourseInfo(CourseId);
    return 
    Scaffold(
      appBar: AppBar(
        // The title text which will be shown on the action bar
        title: Text(title),
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
        future: fetchCourseInfo(CourseId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // or a loading indicator
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
           
            return SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        child: SizedBox(
          child: Column(
            children: [
              Stack(
                children: [
                  Image.network(
                      'https://img.jagranjosh.com/imported/images/E/Articles/CBSE-Class-12-Maths-Sample-Paper-2020-Download-PDF-Body-Images.jpg',
                      width: double.infinity,
                      fit: BoxFit.cover),
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
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                if(!isEnrolled)
                OutlinedButton(
                  onPressed: () => {},
                  child: Text('Enroll into course',
                      style: TextStyle(color: Colors.green)),
                ),
                if(isEnrolled)
                 OutlinedButton(
                  onPressed: () => {
                    
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                            Files(title: "test", courseId: CourseId ?? 0)))
                  },
                  child: Row(children: [Icon(Icons.file_copy, color: Colors.blue,),Text('Files',
                      style: TextStyle(color: Colors.blue))]),
                ),
                SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () => {},
                  child: Row(children: [Icon(Icons.star),Text('Add course to favorites')]),
                ),
              ]),
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
    )
    );
  }
}

  List<Widget> createContainers(List<CourseMeeting>? meetings) {
    List<Widget> containers = [];
  

    if(meetings != null)
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
                      ]),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(meetings[i].CourseMeetingName,
                            style: TextStyle(
                              fontSize: 20,
                            )),
                        Row(
                          children: [
                            Icon(Icons.calendar_month),
                            SizedBox(width: 6),
                            Text(DateFormat('yyyy-MM-dd hh:mm').format(meetings[i].CourseMeetingDate),
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ]));

      containers.add(container);
    }
    return containers;
  }

