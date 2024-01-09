import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proiect_flutter_araducu/classes/DomainOfStudy.dart';
import 'commonClasses/utilities.dart';
import 'classes/notifications.dart';
DateTime startDate = DateTime.parse('1999-01-01');
DateTime endDate = DateTime.parse('1999-01-01');
int selectedDomainId = 0;

class AddDomain extends StatelessWidget {
  final TextEditingController domainName = new TextEditingController();
  final TextEditingController domainDescription = new TextEditingController();
  final ScrollController _scrollController = ScrollController();

  AddDomain({super.key});

  bool ValidateForm() {
    print('Am ajuns aici');
    print(domainName.text.length);
    print(domainDescription.text.length);
    if (domainName.text.length > 3 && domainDescription.text.length > 20)
      return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    double buttonWidth = MediaQuery.of(context).size.width * 0.9;

    return Scaffold(
      appBar: AppBar(
        title: Text("Add domain", style: TextStyle(color: Colors.blue)),
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
                      controller: domainName,
                      icon: Icon(Icons.book),
                      labelText: 'Domain Name',
                      hintText: 'Enter domain name'),
                  SizedBox(height: 40),
                  Text("Course short description"),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 50.0),
                    child: Divider(
                      color: Colors.blue,
                      thickness: 1,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextArea(
                    controller: domainDescription,
                    labelText: 'Enter a short description for the domain',
                    maxLines: 5,
                    icon: Icon(Icons.description),
                  ),
                  SizedBox(height: 20),
                  OutlinedButton(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Icon(Icons.add), Text('Add domain')]),
                      onPressed: () async
                          {if(await domainAdd(domainName.text, domainDescription.text)){
                            domainName.text = '';
                            domainDescription.text = '';
                          }
                          },
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

Future<bool> domainAdd(String domainName, String domainDescription) async {
  DomainOfStudy newDomain = DomainOfStudy(
      domainName: domainName, domainDescription: domainDescription);
  if(await newDomain.CreateDomain()==true){
    NotificationService().ShowNotification(title:'Administration!',body: 'Domain has been added!');
    return true;
  }
  return false;
}
