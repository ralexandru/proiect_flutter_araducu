import 'package:flutter/material.dart';
import 'classes/User.dart';

User user1 = User(
  userId: 1,
  username: 'test',
  firstName: 'Test',
  lastName: 'Test2',
  email: 'test@test.com',
  phoneNo: '071231312',
  country: 'Romania',
  city: 'Bucharest',
  birthday: '11/01/199',
  accessLevel: 1,
);

User user2 = User(
  userId: 21,
  username: 'asd',
  firstName: 'Test',
  lastName: 'Test2',
  email: 'test@test.com',
  phoneNo: '071231312',
  country: 'Romania',
  city: 'Bucharest',
  birthday: '11/01/199',
  accessLevel: 3,
);

List<User> users = [user1, user2];

class UsersList extends StatefulWidget {
  final ScrollController _scrollController = ScrollController();
  final String title;

  UsersList({Key? key, required this.title}) : super(key: key);

  @override
  UsersListState createState() => UsersListState();
}

class UsersListState extends State<UsersList> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit domain", style: TextStyle(color: Colors.blue)),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        controller: widget._scrollController,
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              Column(
                children: createContainers(),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> createContainers() {
    List<Widget> containers = [];

    List<User> filteredUsers = users
        .where((user) =>
            user.username.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    for (int i = 0; i < filteredUsers.length; i++) {
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
          ],
        ),
        child: Column(
          children: [
            if (filteredUsers[i].accessLevel < 3)
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    print('User ID: ${filteredUsers[i].userId}');
                    filteredUsers[i].accessLevel = 3;
                  });
                },
                child: Row(children: [
                  Icon(Icons.admin_panel_settings),
                  Text('Promote user to admin')
                ]),
              ),
            if (filteredUsers[i].accessLevel == 3)
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    print('User ID: ${filteredUsers[i].userId}');
                    // Perform the demotion logic
                    filteredUsers[i].accessLevel = 1;
                  });
                },
                child: Row(children: [
                  Icon(Icons.person),
                  Text('Demote admin to user')
                ]),
              ),
            SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  print('User ID: ${filteredUsers[i].userId}');
                  // Perform the demotion logic
                });
              },
              child: Row(children: [
                Icon(Icons.recycling, color: Colors.red),
                Text('Delete user', style: TextStyle(color: Colors.red))
              ]),
            ),
            SizedBox(height: 10),
            ClipOval(
              child: Image.network(
                'https://t4.ftcdn.net/jpg/02/29/75/83/240_F_229758328_7x8jwCwjtBMmC6rgFzLFhZoEpLobB6L8.jpg',
                width: 100.0,
                height: 100.0,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (filteredUsers[i].accessLevel < 3)
                  Icon(
                    Icons.person,
                    color: Colors.blue,
                  ),
                if (filteredUsers[i].accessLevel == 3)
                  Icon(
                    Icons.admin_panel_settings,
                    color: Colors.blue,
                  ),
                Text(
                  'User info',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 50.0),
              child: Divider(
                color: Colors.blue,
                thickness: 1,
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.person),
                Text(
                  "Username: ${filteredUsers[i].username}",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.person),
                Text(
                  "Name: ${filteredUsers[i].firstName} ${filteredUsers[i].lastName}",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.cake),
                Text(
                  "Birthday: ${filteredUsers[i].birthday}",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.email),
                Text(
                  "Email: ${filteredUsers[i].email}",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.phone),
                Text(
                  "Phone No: ${filteredUsers[i].phoneNo}",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.flag),
                Text(
                  "Country: ${filteredUsers[i].country}",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.pin),
                Text(
                  "City: ${filteredUsers[i].city}",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.person),
                Text(
                  "Access level: ${filteredUsers[i].accessLevel}",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      );

      containers.add(container);
    }
    return containers;
  }
}
