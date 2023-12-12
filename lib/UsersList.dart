import 'package:flutter/material.dart';
import 'classes/User.dart';

List<User> users = [];

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
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      List<User> loadedImages = await retrieveUsers();
      setState(() {
        users = loadedImages;
      });
    } catch (error) {
      print('Error loading users: $error');
    }
  }

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
      containers.add(UserProfileCard(
        user: filteredUsers[i],
        onDeleteSuccess: () async {
          await _loadUsers();
          setState(() {
            filteredUsers.removeAt(i);
          });
        },
      ));
    }
    return containers;
  }
}

class UserProfileCard extends StatefulWidget {
  final User user;
  final VoidCallback? onDeleteSuccess;

  UserProfileCard({required this.user, this.onDeleteSuccess, Key? key})
      : super(key: key);

  @override
  _UserProfileCardState createState() => _UserProfileCardState();
}

class _UserProfileCardState extends State<UserProfileCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
          if (widget.user.accessLevel < 3)
            OutlinedButton(
              onPressed: () {
                setState(() {
                  print('User ID: ${widget.user.userId}');
                  widget.user.accessLevel = 3;
                  widget.user.UpdateUserAccess();
                });
              },
              child: Row(children: [
                Icon(Icons.admin_panel_settings),
                Text('Promote user to admin')
              ]),
            ),
          if (widget.user.accessLevel == 3)
            OutlinedButton(
              onPressed: () {
                setState(() {
                  print('User ID: ${widget.user.userId}');
                  // Perform the demotion logic
                  widget.user.accessLevel = 1;
                  print(
                      "FILTERED USER ACCESS LEVEL: ${widget.user.accessLevel}");
                  widget.user.UpdateUserAccess();
                });
              },
              child: Row(children: [
                Icon(Icons.person),
                Text('Demote admin to user')
              ]),
            ),
          SizedBox(height: 10),
          OutlinedButton(
            onPressed: () async {
              await widget.user.DeleteUser();
              if (widget.onDeleteSuccess != null) {
                widget.onDeleteSuccess!();
              }
            },
            child: Row(children: [
              Icon(Icons.recycling, color: Colors.red),
              Text('Delete user', style: TextStyle(color: Colors.red)),
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
              if (widget.user.accessLevel < 3)
                Icon(
                  Icons.person,
                  color: Colors.blue,
                ),
              if (widget.user.accessLevel == 3)
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
                "Username: ${widget.user.username}",
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.person),
              Text(
                "Name: ${widget.user.firstName} ${widget.user.lastName}",
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.cake),
              Text(
                "Birthday: ${widget.user.birthday}",
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.email),
              Text(
                "Email: ${widget.user.email}",
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.phone),
              Text(
                "Phone No: ${widget.user.phoneNo}",
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.flag),
              Text(
                "Country: ${widget.user.country}",
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.pin),
              Text(
                "City: ${widget.user.city}",
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.person),
              Text(
                "Access level: ${widget.user.accessLevel}",
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
