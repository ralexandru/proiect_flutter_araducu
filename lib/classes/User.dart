import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:proiect_flutter_araducu/NavigationDrawer.dart';

import '../main.dart';

class User {
  int userId;
  String username;
  String firstName;
  String lastName;
  String email;
  String phoneNo;
  String country;
  String city;
  String birthday;
  int accessLevel;

  User({
    required this.userId,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNo,
    required this.country,
    required this.city,
    required this.birthday,
    required this.accessLevel,
  });

    factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['UtilizatorId'],
      username: json['NumeUtilizator'],
      firstName: json['Prenume'],
      lastName: json['NumeFamilie'],
      email: json['AdresaMail'],
      phoneNo: json['NrTelefon'],
      country: json['Tara'],
      city: json['Adresa'],
      birthday: json['DataNasterii'],
      accessLevel: json['NivelAcces'],
    );
  }

  void PrintUser(){
    print('User ID: $userId \n Username: $username');
  }
  Future<void> UpdateUserAccess() async {
    String? jwtToken = await getJWT();
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);

    Uri url = Uri.parse("https://localhost:7097/api/Users/update-nivel-acces?utilizatorId=${userId}&nivelAcces=${accessLevel}");
    HttpClientRequest request = await client.putUrl(url);
    request.headers.set('Content-Type', 'application/json');
    request.headers.set('Authorization', 'Bearer ${jwtToken.toString()}');
    print('USER ACCESS: $nivelAcces');
    HttpClientResponse response = await request.close();

    if (response.statusCode == 200) {
      print('User updated successfully');
    } else {
      print('Failed to update user. Status code: ${response.statusCode}');
    }
    client.close();
  }

    Future<void> UpdateUserPassword(String password) async {
    String? jwtToken = await getJWT();
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);

    Uri url = Uri.parse("https://localhost:7097/api/Users/schimba-parola?parola=${password}&utilizatorId=${userId}");
    HttpClientRequest request = await client.putUrl(url);
    request.headers.set('Content-Type', 'application/json');
    request.headers.set('Authorization', 'Bearer ${jwtToken.toString()}');
    print('USER ACCESS: $nivelAcces');
    HttpClientResponse response = await request.close();

    if (response.statusCode == 200) {
      print('User password updated successfully');
    } else {
      print('Failed to update user password. Status code: ${response.statusCode}');
    }
    client.close();
  }

    Future<void> UpdateUserEmail() async {
    String? jwtToken = await getJWT();
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);

    Uri url = Uri.parse("https://localhost:7097/api/Users/schimba-mail?email=${email}&utilizatorId=${userId}");
    HttpClientRequest request = await client.putUrl(url);
    request.headers.set('Content-Type', 'application/json');
    request.headers.set('Authorization', 'Bearer ${jwtToken.toString()}');
    print('USER ACCESS: $nivelAcces');
    HttpClientResponse response = await request.close();

    if (response.statusCode == 200) {
      print('User updated successfully');
    } else {
      print('Failed to update user. Status code: ${response.statusCode}');
    }
    client.close();
  }

    Future<void> DeleteUser() async {
    String? jwtToken = await getJWT();
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);

    Uri url = Uri.parse("https://localhost:7097/api/Users/utilizator?utilizatorId=${userId}");
    HttpClientRequest request = await client.deleteUrl(url);
    request.headers.set('Content-Type', 'application/json');
    request.headers.set('Authorization', 'Bearer ${jwtToken.toString()}');
    print('USER ACCESS: $nivelAcces');
    HttpClientResponse response = await request.close();

    if (response.statusCode == 200) {
      print('User deleted successfully');
    } else {
      print('Failed to delete user. Status code: ${response.statusCode}');
    }
    client.close();
  }
}

Future<List<User>> retrieveUsers() async {
  HttpClient client = new HttpClient();
  client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);

  HttpClientRequest request = await client
      .getUrl(Uri.parse("https://localhost:7097/api/Users/users-info"));
  request.headers.set('Content-Type', 'application/json');

  HttpClientResponse response = await request.close();

  if (response.statusCode == 200) {
    String responseBody = await response.transform(utf8.decoder).join();
    List<dynamic> jsonList = jsonDecode(responseBody);

    List<User> users =
        jsonList.map((json) => User.fromJson(json)).toList();
    print("User ID: " + (users[0].userId).toString());
    return users;
  } else {
    print('Failed to retrieve users. Status code: ${response.statusCode}');
    return [];
  }
}


Future<List<User>> retrieveUsersByCourse(int courseId) async {
  print('retrieveUsersByCourse was called');
  HttpClient client = new HttpClient();
  client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);

  HttpClientRequest request = await client
      .getUrl(Uri.parse("https://localhost:7097/api/Users/users-info-course?cursId=$courseId"));
  request.headers.set('Content-Type', 'application/json');

  HttpClientResponse response = await request.close();

  if (response.statusCode == 200) {
    String responseBody = await response.transform(utf8.decoder).join();
    List<dynamic> jsonList = jsonDecode(responseBody);

    List<User> users =
        jsonList.map((json) => User.fromJson(json)).toList();
    print("User ID: " + (users[0].userId).toString());
    return users;
  } else {
    print('Failed to retrieve users. Status code: ${response.statusCode}');
    return [];
  }
}
