import 'package:flutter/material.dart';

class CoursePage extends StatelessWidget {
  final ScrollController _scrollController = new ScrollController();
  final String title;
  CoursePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SingleChildScrollView(
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
                                    '10' + '/' + '20',
                                    style: TextStyle(fontSize: 18),
                                  )
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(Icons.calendar_month,
                                      color: Colors.black),
                                  Text('01/01/2024' + '-' + '03/03/2024',
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
                OutlinedButton(
                  onPressed: () => {},
                  child: Text('Enroll into course',
                      style: TextStyle(color: Colors.green)),
                ),
                SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () => {},
                  child: Text('Add course to favorites'),
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
                    child: Text('Math', style: TextStyle(color: Colors.blue)),
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
                          'eu tincidunt leo.eu tincidunt leo.eu tincidunt leo.eu tincidunt leo.eu tincidunt leo.eu tincidunt leo.eu tincidunt leo.eu tincidunt leo.eu tincidunt leo.eu tincidunt leo.eu tincidunt leo.eu tincidunt leo.eu tincidunt leo.eu tincidunt leo.eu tincidunt leo.eu tincidunt leo.eu tincidunt leo.eu tincidunt leo.eu tincidunt leo.'),
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
              Container(
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
                        Text('Introduction into Advanced Math',
                            style: TextStyle(
                              fontSize: 20,
                            )),
                        Row(
                          children: [
                            Icon(Icons.calendar_month),
                            SizedBox(width: 6),
                            Text('01/01/2024 02:50',
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ])),
            ],
          ),
        ),
      ),
    );
  }
}
