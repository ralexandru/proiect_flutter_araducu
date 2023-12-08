import 'package:flutter/material.dart';
import 'Courses.dart';

List<String> differentCourses = <String>[
  'My courses',
  'All courses',
];

class AppBarProiect extends StatelessWidget {
  const AppBarProiect({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorSchemeSeed: const Color(0xff6750a4), useMaterial3: true),
      home: const AppBarWidget(),
    );
  }
}

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({Key? key}) : super(key: key);
  @override
  Size get preferredSize => const Size.fromHeight(
      kToolbarHeight + 48.0); // Adjust the height as needed

  @override
  Widget build(BuildContext context) {
    const int tabsCount = 2;

    return DefaultTabController(
      initialIndex: 1,
      length: tabsCount,
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              AppBar(
                title: const Text('Praeceptor'),
                notificationPredicate: (ScrollNotification notification) {
                  return notification.depth == 1;
                },
                scrolledUnderElevation: 4.0,
                shadowColor: Theme.of(context).shadowColor,
                bottom: const TabBar(
                  tabs: [
                    Tab(
                      icon: Icon(Icons.person),
                      text: 'Tab 1',
                    ),
                    Tab(
                      icon: Icon(Icons.book),
                      text: 'Tab 2',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: const <Widget>[
                    // Adjust the number of children accordingly
                    CoursesPage(),
                    Placeholder(), // Placeholder for the second tab
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
