import 'package:flutter/material.dart';
import 'package:proiect_flutter_araducu/BookmarkedCourses.dart';
import 'Courses.dart';
import 'Home.dart';

class BottomNavigationBarProiect extends StatefulWidget {
  const BottomNavigationBarProiect(
      {super.key}); // used to uniquely identify instances of this widget
  // It is a good practice to pass the 'key' parameter to the constructor of the superclass using super(key: key).
  @override
  State<BottomNavigationBarProiect> createState() =>
      _BottomNavigationBarProiectState();
}

class _BottomNavigationBarProiectState
    extends State<BottomNavigationBarProiect> {
  int selectedIndex = 0;
  static const TextStyle navigationStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  // Creating a list of widgets which represent the tabs from the bottom navigation bar.
  static const List<Widget> navigationOptions = <Widget>[
    Home(),
    CoursesPage(),
    BookMarkedCourse(),
  ];
  // Function which updates the selected index with the value of the index given as a parameter
  void changeIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: navigationOptions.elementAt(selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.blue,
            currentIndex: selectedIndex,
            onTap: changeIndex,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
                backgroundColor: Color.fromARGB(255, 121, 186, 238),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book),
                label: 'Courses',
                backgroundColor: Color.fromARGB(255, 51, 142, 217),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.star),
                label: 'Bookmarks',
                backgroundColor: Color.fromARGB(255, 241, 245, 118),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
