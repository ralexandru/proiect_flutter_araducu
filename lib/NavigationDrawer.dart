import 'package:flutter/material.dart';
import 'package:proiect_flutter_araducu/AddCourse.dart';
import 'package:proiect_flutter_araducu/ManageCarousel.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'BottomNavigation.dart';
import 'Profile.dart';
import 'UsersList.dart';
import 'CreateDomain.dart';
import 'ManageDomains.dart';
import 'AddNews.dart';
import 'classes/User.dart';

int userId = 0;
String username = '';
String email = '';
String JWT = '';
String firstName = '';
String lastName = '';
String phoneNumber = '';
int nivelAcces = 0;
String city = '';
String birthday = '';
User? user;

//ignore: must_be_immutable
Future<void> getUserData() async {
  final client = HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);

  try {
    final request = await client.getUrl(Uri.parse(
        "https://localhost:7097/api/User/info-utilizator?username='${username}'"));
        print('REQUEST Username: $username');
    final response = await request.close();
    if (response.statusCode == 200) {
      print(response.statusCode);
      final Map<String, dynamic> data =
          json.decode(await response.transform(utf8.decoder).join());
      firstName = data['Prenume'];
      lastName = data['NumeFamilie'];
      email = data['AdresaMail'];
      phoneNumber = data['NrTelefon'];
      city = data['Adresa'];
      birthday = data['DataNasterii'];
      userId = data['UtilizatorId'];
      nivelAcces = data['NivelAcces'];
      print(firstName);
      user = new User(
       userId: data["UtilizatorId"],
       username: data["NumeUtilizator"],
       firstName: data['Prenume'],
       lastName: data['NumeFamilie'],
       email: data['AdresaMail'],
       phoneNo: data['NrTelefon'],
       country: data['Tara'],
       city: data['Adresa'],
       birthday: data['DataNasterii'],
       accessLevel: data['NivelAcces']);
       user!.PrintUser();
    } else {
      throw Exception('Failed to load data');
    }
  } finally {
    client.close();
  }
}

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    getUserData();
    return Scaffold(
      drawer: DrawerProiect(),
      body: Column(children: [const Text('Test')]),
      bottomNavigationBar: BottomNavigationBarProiect(),
    );
  }
}

class DrawerProiect extends StatefulWidget {
  const DrawerProiect({super.key});
  @override
  State<DrawerProiect> createState() => _DrawerProiectState();
}

class _DrawerProiectState extends State<DrawerProiect> {
  @override
  Widget build(BuildContext build) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              child: Text(
                '${firstName.substring(0,1)}${lastName.substring(0,1)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            accountEmail: Text(email),
            accountName: Text('${firstName} ${lastName}'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(
                  build,
                  MaterialPageRoute(builder: (context) => Profile()),
                );
              }),
          //ListTile(title: const Text('Grades'), onTap: () {}),
          //ListTile(title: const Text('Settings'), onTap: () {}),
          SizedBox(height: 18),
          if(nivelAcces==3)
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.admin_panel_settings),
            Text('Admin options', style: TextStyle(fontSize: 15)),
          ]),
          Divider(),
          if (nivelAcces == 3)
            ListTile(
                title: const Text('Add new course',
                    style: TextStyle(color: Colors.blue)),
                onTap: () {
                  Navigator.push(
                    build,
                    MaterialPageRoute(builder: (context) => AddCourse()),
                  );
                }),
          if (nivelAcces == 3)
            ListTile(
                title: const Text('Add new domain',
                    style: TextStyle(color: Colors.blue)),
                onTap: () {
                  Navigator.push(
                    build,
                    MaterialPageRoute(builder: (context) => AddDomain()),
                  );
                }),
          if (nivelAcces == 3)
            ListTile(
                title: const Text('Manage domains',
                    style: TextStyle(color: Colors.blue)),
                onTap: () {
                  Navigator.push(
                    build,
                    MaterialPageRoute(
                        builder: (context) =>
                            ModifyDomains(title: "Modify domains")),
                  );
                }),
          if (nivelAcces == 3)
            ListTile(
                title: const Text('Manage users',
                    style: TextStyle(color: Colors.blue)),
                onTap: () {
                  Navigator.push(
                    build,
                    MaterialPageRoute(
                        builder: (context) => UsersList(title: "Add ", byCourse: false,)),
                  );
                }),
          if(nivelAcces==3)
            ListTile(
                title: const Text('Add news',
                    style: TextStyle(color: Colors.blue)),
                onTap: () {
                  Navigator.push(
                    build,
                    MaterialPageRoute(
                        builder: (context) => AddNews()),
                  );
                }),
           if(nivelAcces==3)
            ListTile(
                title: const Text('Manage carousel',
                    style: TextStyle(color: Colors.blue)),
                onTap: () {
                  Navigator.push(
                    build,
                    MaterialPageRoute(
                        builder: (context) => ManageCarousel()),
                  );
                })
        ],
      ),
    );
  }
}
