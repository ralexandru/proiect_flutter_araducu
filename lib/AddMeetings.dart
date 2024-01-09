import 'package:flutter/material.dart';
import 'package:proiect_flutter_araducu/Home.dart';
import 'commonClasses/utilities.dart';
import 'classes/Course.dart';
import 'classes/CourseMeeting.dart';
import 'NavigationDrawer.dart';
import 'classes/notifications.dart';
List<DateTime> courseDates = [];
List<CourseMeeting> courseMeetings = [];

//ignore: must_be_immutable
class AddMeetings extends StatelessWidget {
  ScrollController _scrollController = ScrollController();
  Course courseToBeAdded;
  int noOfMeetings;

  AddMeetings(
      {super.key, required this.noOfMeetings, required this.courseToBeAdded});
  List<TextEditingController> courseTitles = [];

  List<Widget> CreateContainers() {
    List<Widget> containers = [];
    DateTime date = DateTime.parse('1999-01-01');

    for (int i = 0; i < noOfMeetings; i++) {
      TextEditingController controller = TextEditingController();
      courseTitles.add(controller);
      courseDates.add(date);
      Container container = Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(16.0),
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
            FilledTextField(
              controller: courseTitles[i],
              icon: Icon(Icons.calendar_month),
              labelText: 'Course no. ' + (i + 1).toString(),
              hintText: 'Enter the name of the course #${i + 1}',
            ),
            SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(
                Icons.punch_clock,
                color: Colors.blue,
              ),
              Text('Course will be held on: ',
                  style: TextStyle(fontSize: 16, color: Colors.blue)),
            ]),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 50.0),
              child: Divider(
                color: Colors.blue,
                thickness: 1,
              ),
            ),
            DatePicker(
              textToDisplay: 'Pick date for course #${i + 1}',
              pickedDate: i,
            )
          ],
        ),
      );

      containers.add(container);
    }
    return containers;
  }

  Future<void> CreateCourse(BuildContext context) async {
    bool isValid = true;

    if (isValid) {
      List<CourseMeeting> meetings = [];
      print('a ajusn aici!');
      for (int i = 0; i < noOfMeetings; i++) {
        CourseMeeting meeting = CourseMeeting(
            CourseMeetingName: courseTitles[i].text,
            CourseMeetingDate: courseDates[i],
            CourseMeetingId: courseToBeAdded.CourseId);
        print(meeting.CourseMeetingName);
        meetings.add(meeting);
      }
      courseToBeAdded.meetings = meetings;
      if(await CreateCourseDB(courseToBeAdded)==true){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Homepage()),
        );
        NotificationService().ShowNotification(title: 'Administration!', body: 'Course has been added!');
      };
      
      courseToBeAdded.Test();
    }

    if (isValid == true)
      showPopup(context, 'Course management',
          'Course has been successfully added!', 'OK');
    else
      showPopup(
          context,
          'Course management',
          'Course could not be added. Please check that all fields are completed and dates are not in the past',
          'OK');
  }

  void testIfItWorks() {
    print('${courseTitles.length} - COURSE OCCURENCES LENGTH');
    for (int i = 0; i < noOfMeetings; i++) print(courseTitles[i].text);
    print('${courseDates.length} - COURSE DATES LENGTH');
    for (int i = 0; i < noOfMeetings; i++) print(courseDates[i].toString());
  }

  @override
  Widget build(BuildContext context) {
    double buttonWidth = MediaQuery.of(context).size.width * 0.9;
    return Scaffold(
      appBar: AppBar(
        title: Text("Add course", style: TextStyle(color: Colors.blue)),
        // The title text which will be shown on the action bar
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
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 10),
              Column(
                children: CreateContainers(),
              ),
              if (noOfMeetings == 2) Text('test'),
              SizedBox(height: 10),
              OutlinedButton(
                  onPressed: () => {CreateCourse(context)},
                  child: Text('Submit'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    minimumSize:
                        MaterialStateProperty.all(Size(buttonWidth, 20.0)),
                    padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                  )),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

void showPopup(
    BuildContext context, String title, String content, String buttonText) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // Return the AlertDialog widget
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              // Close the popup
              Navigator.of(context).pop();
            },
            child: Text(buttonText),
          ),
        ],
      );
    },
  );
}

//ignore: must_be_immutable
class DatePicker extends StatefulWidget {
  int pickedDate;
  String textToDisplay;
  DatePicker({required this.textToDisplay, required this.pickedDate});

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime selectedDateTime = DateTime.now();

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      );

      if (pickedTime != null) {
        setState(() {
          print('Changed date and time');
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          courseDates[widget.pickedDate] = selectedDateTime;
          // Update your list or any other logic as needed
          // courseDates[widget.pickedDate] = selectedDateTime;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          "${selectedDateTime.toString()}".split('.')[0],
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(
          height: 20.0,
        ),
        ElevatedButton(
          onPressed: () => _selectDateTime(context),
          child: Text(widget.textToDisplay),
        ),
      ],
    );
  }
}
