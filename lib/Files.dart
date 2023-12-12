import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:proiect_flutter_araducu/NavigationDrawer.dart';
import 'classes/File.dart';




List<FileApp> files = [];
class Files extends StatefulWidget {
  bool initialState = true;
  final String title;
  int courseId;
  Files({Key? key, required this.title, required this.courseId}) : super(key: key);

  @override
  _FilesState createState() => _FilesState();
}

class _FilesState extends State<Files> {
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Back to course",
          style: TextStyle(color: Colors.blue),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FutureBuilder<List<FileApp>>(
        future: retrieveFiles(widget.courseId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [CircularProgressIndicator(), SizedBox(height:10), Text("We're retrieving your files...")])); // Loading indicator while waiting
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            if(widget.initialState)
              files = snapshot.data ?? [];
            return SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.vertical,
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    children: CreateContainers(),
                  ),
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openFilePicker(),
        tooltip: 'Pick File',
        child: Icon(Icons.add),
      ),
    );
  }


  void _openFilePicker() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;

        // Ensure the file has a path
        if (file.path != null) {
          // Read file bytes asynchronously
          List<int> bytes = await File(file.path!).readAsBytes();

          // Process the picked file
          print('File picked: ${file.name}');

          // Extract file extension from the file name
          String fileExtension = file.extension ?? 'Unknown';

          // Create a new instance of the FileApp class
          FileApp newFile = FileApp(
            fileId: files.length + 1,
            courseId: widget.courseId,
            fileName: file.name!,
            fileType: fileExtension,
            uploadDate: DateTime.now(),
            fileData: Uint8List.fromList(bytes),
            ftpFile: 'ftp://test',
          );

          print('ORIGINAL FILE: $bytes');
          print('FILE UPLOAD: ${newFile.fileData}');

          // Add the new file to the list and trigger a rebuild
          setState(() {
            widget.initialState=false;
            files.add(newFile);
            newFile.UploadFile();
          });
        } else {
          print('File path is null.');
        }
      } else {
        print('No file selected.');
      }
    } catch (e) {
      print('Error picking file: $e');
    }
  }

void _downloadFile(FileApp file) async {
  try {
    print("FILE ${file.fileData}");
    // Get the application documents directory
    final Directory appDocumentsDirectory =
        await getApplicationDocumentsDirectory();

    // Create a File object for the destination file
    final String filePath = '${appDocumentsDirectory.path}/${file.fileName}';
    File destinationFile = File(filePath);

    // Write the file data to the destination file
    await destinationFile.writeAsBytes(file.fileData);

    // Open the file using the default application
    await OpenFile.open(filePath);
  } catch (e) {
    print('Error downloading or opening file: $e');
  }
}
void _openFile(String filePath) async {
  try {
    await OpenFile.open(filePath);
  } catch (e) {
    print('Error opening file: $e');
  }

}

  void DeleteFileApp(int courseId){
    DeleteFile(courseId);
    setState((){
       widget.initialState = true;
       files.removeWhere((file) => file.courseId == courseId);
    });
  }

 List<Widget> CreateContainers() {
  List<Widget> containers = [];

  for (int i = 0; i < files.length; i++) {
    Container container = Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(6.0),
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
          SizedBox(width: 0),
          Row(
            children: [
              SizedBox(width: 20),
              Text(
                '${files[i].fileType}',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 20),
              Text(
                '${files[i].fileName.length > 10 ? files[i].fileName.substring(0, 10) + "..." : files[i].fileName}',
                style: TextStyle(color: Colors.blue),
              ),
              SizedBox(width: 10),
              OutlinedButton(
                onPressed: () => _downloadFile(files[i]),
                child: Icon(Icons.download),
              ),
              if(nivelAcces==3)
              SizedBox(width: 10),
              if(nivelAcces==3)
              OutlinedButton(
                onPressed: () => {
                  DeleteFileApp(files[i].fileId)
                  },
                child: Icon(Icons.delete),
              )
            ],
          ),
        ],
      ),
    );

    containers.add(container);
  }
  return containers;
}
}
