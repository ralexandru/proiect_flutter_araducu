import 'package:flutter/material.dart';
import 'commonClasses/utilities.dart';
import 'classes/DomainOfStudy.dart';

List<bool> editableDomain = [];
List<TextEditingController> domainsName = [];
List<TextEditingController> domainsDescription = [];
List<DomainOfStudy> domainsList = [];

void GetDomains() async {
  domainsList = await retrieveDomains();

  for (DomainOfStudy domain in domainsList) {
    print(
        'Domain Name: ${domain.domainName}, Description: ${domain.domainDescription}');
  }
}

class ModifyDomains extends StatefulWidget {
  final ScrollController _scrollController = ScrollController();
  final String title;

  ModifyDomains({super.key, required this.title});

  @override
  ModifyDomainsState createState() => ModifyDomainsState();
}

class ModifyDomainsState extends State<ModifyDomains> {
  late Future<List<DomainOfStudy>> domainsFuture;
  void initState() {
    super.initState();
    domainsFuture = retrieveDomains();
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
              FutureBuilder(
                future: domainsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<DomainOfStudy> domainsList =
                        snapshot.data as List<DomainOfStudy>;
                    return Column(
                      children: createContainers(domainsList),
                    );
                  }
                },
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> createContainers(List<DomainOfStudy> domainsList) {
    print("LENGTH: ${domainsList.length}");
    List<Widget> containers = [];
    domainsName.clear();
    domainsDescription.clear();
    for (int i = 0; i < domainsList.length; i++) {
      bool edit = false;
      editableDomain.add(edit);
      TextEditingController controllerName = TextEditingController();
      controllerName.text = domainsList[i].domainName;
      TextEditingController controllerDescription = TextEditingController();
      controllerDescription.text = domainsList[i].domainDescription;
      domainsName.add(controllerName);
      domainsDescription.add(controllerDescription);

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
            OutlinedButton(
              onPressed: () {
                setState(() {
                  editableDomain[i] = true;
                });
              },
              child: Row(children: [Icon(Icons.edit), Text('Edit domain')]),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.description,
                  color: Colors.blue,
                ),
                Text('Domain name',
                    style: TextStyle(fontSize: 16, color: Colors.blue)),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 50.0),
              child: Divider(
                color: Colors.blue,
                thickness: 1,
              ),
            ),
            FilledTextField(
              controller: domainsName[i],
              icon: Icon(Icons.description),
              labelText: '',
              editable: editableDomain[i],
              hintText: 'Enter domain name',
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.description,
                  color: Colors.blue,
                ),
                Text('Domain description',
                    style: TextStyle(fontSize: 16, color: Colors.blue)),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 50.0),
              child: Divider(
                color: Colors.blue,
                thickness: 1,
              ),
            ),
            TextArea(
              controller: domainsDescription[i],
              labelText: '',
              editable: editableDomain[i],
              icon: Icon(Icons.description),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            if (editableDomain[i])
              OutlinedButton(
                onPressed: () {
                  print("TEST 3: ${domainsList[0].domainId}");
                  domainsList[i].domainName = domainsName[i].text;
                  domainsList[i].domainDescription = domainsDescription[i].text;
                  domainsList[i].domainId = domainsList[i].domainId;
                  UpdateDomain(domainsList[i]);
                  setState(() {
                    editableDomain[i] = false;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit, color: Colors.green),
                    Text('Save modifications',
                        style: TextStyle(color: Colors.green)),
                  ],
                ),
              ),
            if (editableDomain[i]) SizedBox(height: 10),
            if (editableDomain[i])
              OutlinedButton(
                onPressed: () {
                  DeleteDomain(domainsList[i]);
                  setState(() {
                    // Remove the deleted domain from the list
                    domainsList.removeAt(i);
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.recycling_rounded, color: Colors.red),
                    Text('Delete domain', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
          ],
        ),
      );

      containers.add(container);
    }
    return containers;
  }
}
