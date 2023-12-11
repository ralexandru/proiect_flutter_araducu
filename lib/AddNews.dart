import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proiect_flutter_araducu/classes/DomainOfStudy.dart';
import 'commonClasses/utilities.dart';
import 'classes/News.dart';

class AddNews extends StatelessWidget {
  final TextEditingController newsName = new TextEditingController();
  final TextEditingController newsContent = new TextEditingController();
  final ScrollController _scrollController = ScrollController();

  AddNews({super.key});

  bool ValidateForm() {
    print('Am ajuns aici');
    print(newsName.text.length);
    print(newsContent.text.length);
    if (newsName.text.length > 3 && newsContent.text.length > 20)
      return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    double buttonWidth = MediaQuery.of(context).size.width * 0.9;

    return Scaffold(
      appBar: AppBar(
        title: Text("Add news", style: TextStyle(color: Colors.blue)),
        // The title text which will be shown on the action bar
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () {
            // Add your back button functionality here
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
                      controller: newsName,
                      icon: Icon(Icons.book),
                      labelText: 'News Name',
                      hintText: 'Enter news name'),
                  SizedBox(height: 40),
                  Text("News short description"),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 50.0),
                    child: Divider(
                      color: Colors.blue,
                      thickness: 1,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextArea(
                    controller: newsContent,
                    labelText: 'Enter the content for the news',
                    maxLines: 5,
                    icon: Icon(Icons.description),
                  ),
                  SizedBox(height: 20),
                  OutlinedButton(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Icon(Icons.add), Text('Add news')]),
                      onPressed: () =>
                          {newsAdd(newsName.text, newsContent.text)},
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        minimumSize:
                            MaterialStateProperty.all(Size(buttonWidth, 20.0)),
                        padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                      )),
                ],
              ),
            ),
          )),
    );
  }
}

void newsAdd(String newsName, String newsContent) {
  News newsToAdd = News(
      newsName: newsName, newsContent: newsContent);
  newsToAdd.AddNews();
}
