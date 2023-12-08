import 'package:flutter/material.dart';
import 'package:proiect_flutter_araducu/AddCourse.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'BottomNavigation.dart';
import 'Profile.dart';
import 'UsersList.dart';
import 'CreateDomain.dart';
import 'ManageDomains.dart';

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

//ignore: must_be_immutable
Future<void> getUserData() async {
  final client = HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);

  try {
    final request = await client.getUrl(Uri.parse(
        'https://localhost:7097/api/User/info-utilizator?username="test123"'));
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
              backgroundImage: NetworkImage(
                ('https://images.unsplash.com/photo-1485290334039-a3c69043e517?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTYyOTU3NDE0MQ&ixlib=rb-1.2.1&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=300'),
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
          ListTile(title: const Text('Grades'), onTap: () {}),
          ListTile(title: const Text('Settings'), onTap: () {}),
          SizedBox(height: 18),
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
                        builder: (context) => UsersList(title: "Add ")),
                  );
                })
        ],
      ),
    );
  }
}
