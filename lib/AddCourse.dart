import 'package:flutter/material.dart';
import 'AddMeetings.dart';
import 'commonClasses/utilities.dart';
import 'classes/DomainOfStudy.dart';
import 'classes/Course.dart';

DateTime startDate = DateTime.parse('1999-01-01');
DateTime endDate = DateTime.parse('1999-01-01');
int selectedDomainId = 0;

List<DomainOfStudy> domainsList = [];

class AddCourse extends StatelessWidget {
  final TextEditingController courseName = TextEditingController();
  final TextEditingController shortDescCourse = TextEditingController();
  final TextEditingController longDescCourse = TextEditingController();
  final TextEditingController noOfMeeting = TextEditingController();
  final TextEditingController noOfSeats = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController difficultyLevel = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  AddCourse({Key? key});

  bool validateForm() {
    if (courseName.text.length > 3 &&
        shortDescCourse.text.length > 20 &&
        shortDescCourse.text.length < 255 &&
        longDescCourse.text.length > 50 &&
        longDescCourse.text.length < 1000 &&
        noOfMeeting.text.length > 0 &&
        noOfSeats.text.length > 0 &&
        price.text.length > 0 &&
        startDate.isAfter(DateTime.now()) &&
        endDate.isAfter(startDate)) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add course", style: TextStyle(color: Colors.blue)),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                FilledTextField(
                  controller: courseName,
                  icon: Icon(Icons.book),
                  labelText: 'Nume curs',
                  hintText: 'Introduceti numele cursului',
                ),
                SizedBox(height: 20),
                SizedBox(
                  child: Row(
                    children: [
                      Text('Domain of study'),
                      SizedBox(width: 20),
                      DropdownButtonProiect(),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                NumericTextField(
                  labelText: 'No. of seats available',
                  hintText:
                      'Enter the number of seats available for this course',
                  icon: Icon(Icons.person),
                  controller: noOfSeats,
                ),
                SizedBox(height: 20),
                NumericTextField(
                  labelText: 'Difficulty level',
                  hintText: 'Enter the difficulty level',
                  icon: Icon(Icons.person),
                  controller: difficultyLevel,
                ),
                SizedBox(height: 20),
                NumericTextField(
                  labelText: 'Price (RON)',
                  hintText: 'Enter the price in RON',
                  icon: Icon(Icons.money),
                  controller: price,
                ),
                SizedBox(height: 20),
                Text("Course short description"),
                SizedBox(height: 10),
                TextArea(
                  controller: shortDescCourse,
                  labelText: 'Enter a short description for the course',
                  maxLines: 5,
                ),
                SizedBox(height: 20),
                Text("Course short description"),
                SizedBox(height: 10),
                TextArea(
                  controller: longDescCourse,
                  labelText: 'Enter a long description for the course',
                  maxLines: 10,
                ),
                SizedBox(height: 20),
                Text("Duration: "),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DatePicker(
                        textToDisplay: 'Select start date',
                        pickedDate: 'startDate'),
                    SizedBox(width: 30),
                    DatePicker(
                        textToDisplay: 'Select end date',
                        pickedDate: 'endDate'),
                  ],
                ),
                SizedBox(height: 10),
                NumericTextField(
                  labelText: 'No. of meetings:',
                  hintText: 'Enter the number of meetings',
                  icon: Icon(Icons.numbers),
                  controller: noOfMeeting,
                ),
                SizedBox(height: 20),
                OutlinedButton(
                  child: Text('Set up meetings'),
                  onPressed: () {
                    if (validateForm()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddMeetings(
                            courseToBeAdded: proceedCourse(),
                            noOfMeetings: int.parse(noOfMeeting.text),
                          ),
                        ),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Course proceedCourse() {
    return Course(
      CourseName: courseName.text,
      CourseShortDescription: shortDescCourse.text,
      CourseLongDescription: longDescCourse.text,
      StartDate: startDate,
      FinishDate: endDate,
      AvailableSeats: int.parse(noOfSeats.text),
      Price: int.parse(price.text),
      DifficultyLevel: int.parse(difficultyLevel.text),
      DomainId: selectedDomainId,
    );
  }
}

class DropdownButtonProiect extends StatefulWidget {
  const DropdownButtonProiect({Key? key}) : super(key: key);

  @override
  State<DropdownButtonProiect> createState() => _DropdownButtonState();
}

class _DropdownButtonState extends State<DropdownButtonProiect> {
  late Future<List<DomainOfStudy>> domainsFuture;
  late int? selectedDomainId;
  List<DomainOfStudy> domainsList = [];

  @override
  void initState() {
    super.initState();
    domainsFuture = retrieveDomains();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DomainOfStudy>>(
      future: domainsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          domainsList = snapshot.data!;
          selectedDomainId =
              domainsList.isNotEmpty ? domainsList[0].domainId : null;

          return domainsList.isNotEmpty
              ? DropdownButton<String>(
                  value: selectedDomainId.toString(),
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.blue),
                  underline: Container(
                    height: 2,
                    color: Colors.blue,
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      if (value != null) {
                        selectedDomainId = int.parse(value);
                      }
                    });
                  },
                  items: domainsList.map<DropdownMenuItem<String>>(
                    (DomainOfStudy currentDomain) {
                      return DropdownMenuItem(
                        value: currentDomain.domainId.toString(),
                        child: Text(currentDomain.domainName),
                      );
                    },
                  ).toList(),
                )
              : Text('No domains available');
        }
      },
    );
  }
}

class DatePicker extends StatefulWidget {
  final String pickedDate;
  final String textToDisplay;

  DatePicker({required this.textToDisplay, required this.pickedDate});

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        if (widget.pickedDate == 'startDate') {
          selectedDate = picked;
          startDate = picked;
        } else {
          selectedDate = picked;
          endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          "${selectedDate.toLocal()}".split(' ')[0],
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(
          height: 20.0,
        ),
        ElevatedButton(
          onPressed: () => _selectDate(context),
          child: Text(widget.textToDisplay),
        ),
      ],
    );
  }
}
