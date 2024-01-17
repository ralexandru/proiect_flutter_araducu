import 'package:flutter/material.dart';
import 'NavigationDrawer.dart';
import 'commonClasses/utilities.dart';
class Profile extends StatefulWidget {
  final ScrollController _scrollController = ScrollController();
  Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}
class _ProfileState extends State<Profile> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          child: SizedBox(
            child: Column(children: [
              Container(
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
                margin: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InitialsAvatar(initials: '${firstName.substring(0,1)}${lastName.substring(0,1)}'),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person, size: 28, color: Colors.blue),
                        Text(user!.firstName + ' ' + user!.lastName,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold)),
                        if (nivelAcces == 3) Icon(Icons.admin_panel_settings)
                      ],
                    ),
                    Text("(Student)"),
                    SizedBox(height: 20),
                    Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.map, size: 30, color: Colors.blue),
                              Text('Country',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.blue))
                            ]),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 50),
                            child: Divider(color: Colors.blue, thickness: 1)),
                        Text(user!.country, style: TextStyle(fontSize: 20))
                      ],
                    ),
                    SizedBox(height: 20),
                    Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.pin_drop,
                                  size: 30, color: Colors.blue),
                              Text('City',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.blue))
                            ]),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 50),
                            child: Divider(color: Colors.blue, thickness: 1)),
                        Text(user!.city, style: TextStyle(fontSize: 20))
                      ],
                    ),
                    SizedBox(height: 20),
                    Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.phone, size: 30, color: Colors.blue),
                              Text('Phone',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.blue))
                            ]),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 50),
                            child: Divider(color: Colors.blue, thickness: 1)),
                        Text(user!.phoneNo, style: TextStyle(fontSize: 20))
                      ],
                    ),
                    SizedBox(height: 20),
                    Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.email, size: 30, color: Colors.blue),
                              Text('Email',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.blue))
                            ]),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 50),
                            child: Divider(color: Colors.blue, thickness: 1)),
                        Text(user!.email, style: TextStyle(fontSize: 20))
                      ],
                    ),
                    SizedBox(height: 20),
                    Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.calendar_view_day,
                                  size: 30, color: Colors.blue),
                              Text('Birthday',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.blue))
                            ]),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 50),
                            child: Divider(color: Colors.blue, thickness: 1)),
                        Text(user!.birthday, style: TextStyle(fontSize: 20))
                      ],
                    ),
                  ],
                ),
              ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20), 
              child: OutlinedButton(
                onPressed: () => _showChangePasswordDialog(context),
                child: Text('Modify Password'),
                  style: OutlinedButton.styleFrom(
                   minimumSize: Size(300, 50),) 
              ),
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20), 
              child: OutlinedButton(
                onPressed: () => _showChangeEmailDialog(context),
                child: Text('Modify Email'),
                  style: OutlinedButton.styleFrom(
                   minimumSize: Size(300, 50),)               
                ),
            ),
              SizedBox(height: 20)
            ]),
          ),
        ),
      ),
    );
  }
    void _showChangePasswordDialog(BuildContext context) {
    TextEditingController newPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Password'),
          content: TextField(
            controller: newPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'New Password',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String newPassword = newPasswordController.text;
                user!.UpdateUserPassword(newPassword);
                print('New Password: $newPassword');
                Navigator.of(context).pop();
              },
              child: Text('Save Changes'),
            ),
          ],
        );
      },
    );
  }

  void _showChangeEmailDialog(BuildContext context) {
    TextEditingController newEmailController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Email'),
          content: TextField(
            controller: newEmailController,
            decoration: InputDecoration(
              labelText: 'New Email',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String newEmail = newEmailController.text;
                                setState(() {
                  user!.email = newEmail;
                });
                user!.email = newEmail;
                user!.UpdateUserEmail();
                print('New Email: $newEmail');
                Navigator.of(context).pop();
              },
              child: Text('Save Changes'),
            ),
          ],
        );
      },
    );
  }
}

