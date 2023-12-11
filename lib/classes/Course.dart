import 'dart:ffi';
import 'dart:convert';
import 'package:proiect_flutter_araducu/AddCourse.dart';
import 'package:proiect_flutter_araducu/AddMeetings.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'CourseMeeting.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';

import '../main.dart';

class Course {
  int? CourseId;
  final String CourseName;
  final String CourseShortDescription;
  final String CourseLongDescription;
  final DateTime StartDate;
  final DateTime FinishDate;
  final int AvailableSeats;
  final int Price;
  final int DifficultyLevel;
  int? DomainId;
  Uint8List? fileData;
  List<CourseMeeting>? meetings;

  Course(
      {this.CourseId,
      required this.CourseName,
      required this.CourseShortDescription,
      required this.CourseLongDescription,
      required this.StartDate,
      required this.FinishDate,
      required this.AvailableSeats,
      required this.Price,
      this.DomainId,
      required this.DifficultyLevel,
      this.fileData,
      this.meetings});

  Map<String, dynamic> toJson() {
    return {
      'CursId': CourseId,
      'CursDenumire': CourseName,
      'CursScurtaDescriere': CourseShortDescription,
      'CursLungaDescriere': CourseLongDescription,
      'DataInceput': StartDate.toIso8601String(),
      'DataFinal': FinishDate.toIso8601String(),
      'LocuriDisponibile': AvailableSeats,
      'Pret': Price,
      'NivelDificultate': DifficultyLevel,

    };
  }

  void Test() {
    print(
        'CourseID: $CourseId, ID : $DomainId \n NAME: $CourseName \n COURSE SHORT DESC: $CourseShortDescription \n COURSE LONG DECS: $CourseLongDescription \n COURSE START DATE: ${startDate.toString()}  \n END DATE: ${endDate.toString()} \n NO OF SEATS: $AvailableSeats \n PRICE $Price \n DIFFCULTY: $DifficultyLevel');
    for (int i = 0; i < meetings!.length; i++) {
      String meetingName = meetings![i].CourseMeetingName;
      print(
          'Course name ${meetings![i].CourseMeetingName} | Date ${meetings![i].CourseMeetingDate}');
    }
  }
}

Future<void> CreateCourseDB(Course course) async {
  String apiUrl =
      "https://localhost:7097/api/Courses/course"; // Update the URL as needed
  String? jwtToken = await getJWT();

  HttpClient client = HttpClient();
  client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);

  try {
    HttpClientRequest request = await client.postUrl(Uri.parse(apiUrl));
    request.headers.set('Content-Type', 'application/json');
    request.headers.set('Authorization', 'Bearer ${jwtToken.toString()}');

    final Map<String, dynamic> requestBody = {
      'CursDenumire': course.CourseName,
      'CursScurtaDescriere': course.CourseShortDescription,
      'CursLungaDescriere': course.CourseLongDescription,
      'DataInceput': course.StartDate.toIso8601String(),
      'DataFinal': course.FinishDate.toIso8601String(),
      'LocuriDisponibile': course.AvailableSeats,
      'Pret': course.Price,
      'NivelDificultate': course.DifficultyLevel,
      'DomeniuId': course.DomainId,
      'meetinguriCurs': course.meetings
          ?.map((meeting) => {
                'MeetingDenumire': meeting.CourseMeetingName,
                'MeetingData': meeting.CourseMeetingDate.toIso8601String(),
                'CursId': course.CourseId,
                // Add other meeting properties as needed
                
              })
          .toList(),
    };

    final requestBodyJson = jsonEncode(requestBody);
    print(requestBodyJson);
    request.write(requestBodyJson);
    HttpClientResponse result = await request.close();

    print(result.statusCode);

    if (result.statusCode == 200) {
      print('Course successfully added');
    } else {
      print('JWT TOKEN ' + jwtToken.toString());
      print('Course add failed!');
    }
  } catch (error) {
    print('Error: $error');
  } finally {
    client.close();
  }
}

Future<Course> fetchCourseInfo(int? courseId) async {
  HttpClient client = new HttpClient();
  int idCourse = courseId ?? 0;
  client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
  final request = await client.getUrl(Uri.parse('https://localhost:7097/api/Courses/course?cursId=$idCourse'));
 HttpClientResponse response = await request.close();

  if (response.statusCode == 200) {
    String responseBody = await response.transform(utf8.decoder).join();
    final Map<String, dynamic> responseData = json.decode(responseBody);
    Uint8List? fileData;
    // Parse Course details
    Course course = Course(
      CourseId: responseData['CursId'],
      CourseName: responseData['CursDenumire'],
      CourseShortDescription: responseData['CursScurtaDescriere'],
      CourseLongDescription: responseData['CursLungaDescriere'],
      StartDate: DateTime.parse(responseData['DataInceput']),
      FinishDate: DateTime.parse(responseData['DataFinal']),
      AvailableSeats: responseData['LocuriDisponibile'],
      Price: responseData['Pret'],
      DifficultyLevel: responseData['NivelDificultate'],
      DomainId: responseData['DomeniuId'],
    );
    if (responseData["bannerImg"] != null) {
      course.fileData = Uint8List.fromList(base64.decode(responseData["bannerImg"]));
    } else {
      // Assign a default value if fileData is null
      fileData = Uint8List(0); // Empty Uint8List
    }
    // Parse CourseMeeting details
    if (responseData['meetinguriCurs'] != null) {
      List<CourseMeeting> meetings = [];
      for (var meetingData in responseData['meetinguriCurs']) {
        CourseMeeting meeting = CourseMeeting(
          CourseMeetingId: meetingData['MeetingId'],
          CourseMeetingName: meetingData['MeetingDenumire'],
          CourseMeetingDate: DateTime.parse(meetingData['MeetingData']),
        );
        meetings.add(meeting);
      }
      course.meetings = meetings;
    }
    course.Test();

    return course;
  } else {
    print('STATUS CODE ${response.statusCode}');
    throw Exception('Failed to load course info');
  }
}

Future<void> UpdateCourseBanner(Course course) async {
  String? jwtToken = await getJWT();
  HttpClient client = new HttpClient();
  client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);

  Uri url = Uri.parse("https://localhost:7097/api/Courses/update-banner?courseId=${course.CourseId}");
  print("URL BANNER API REQUEST: $url");
  HttpClientRequest request = await client.putUrl(url);
  request.headers.set('Content-Type', 'application/json');
  request.headers.set('Authorization', 'Bearer ${jwtToken.toString()}');

  // Convert the course to JSON
  String bannerBase64 = base64Encode(course.fileData!);
  request.write(jsonEncode(bannerBase64));



  HttpClientResponse response = await request.close();

  if (response.statusCode == 200) {
    print('Course banner updated successfully');
  } else {
    print('Failed to update course banner. Status code: ${response.statusCode}');
  }
  
  print("COURSE BANNER: ${response.statusCode}");
  print("Stats URL BANNER: ${response.statusCode}");
  client.close();
}

Future<String> fetchCourseNumbers(int? utilizatorId) async {
  HttpClient client = new HttpClient();
  int idUtilizator = utilizatorId ?? 0;
  client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
  final request = await client.getUrl(Uri.parse('https://localhost:7097/api/Courses/nr-cursuri-inscris?utilizatorId=$idUtilizator'));
 HttpClientResponse response = await request.close();

  if (response.statusCode == 200) {
    String responseBody = await response.transform(utf8.decoder).join();
    final String responseData = json.decode(responseBody);
    String count = responseData;
    print("COUNT" + count);

    return count;
  } else {
    print('STATUS CODE ${response.statusCode}');
    throw Exception('Failed to load course info');   
  }
}

Future<List<String>> fetchDomainsEnrolled(int? utilizatorId) async {
  HttpClient client = new HttpClient();
  int idUtilizator = utilizatorId ?? 0;
  client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
  final request = await client.getUrl(Uri.parse('https://localhost:7097/api/Courses/domenii-inscris?utilizatorId=$idUtilizator'));
 HttpClientResponse response = await request.close();

  if (response.statusCode == 200) {
    String responseBody = await response.transform(utf8.decoder).join();
    final List<dynamic> responseData = json.decode(responseBody);
    List<String> responseDomains = [];
    for(int i = 0; i < responseData.length; i++)
      responseDomains.add(responseData[i]);

    return responseDomains;
  } else {
    print('STATUS CODE ${response.statusCode}');
    throw Exception('Failed to load course info');   
  }
}