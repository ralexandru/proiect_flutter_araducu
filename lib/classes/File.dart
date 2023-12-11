import 'dart:typed_data';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import '../main.dart';

class FileApp {
    int fileId;
    int courseId;
    String fileName;
    String fileType;
    DateTime uploadDate;
    Uint8List fileData;
    String ftpFile;

      FileApp({
        required this.fileId,
        required this.courseId,
        required this.fileName,
        required this.fileType,
        required this.fileData,
        required this.ftpFile,
        required this.uploadDate,
      });

  void Print(){
    print("File ID: $fileId \n Course Id: $courseId \n File Name: $fileName \n File type: $fileType \n File upload date: $uploadDate \n File content: $fileData");
  }
 Future<void> UploadFile() async {
  String? jwtToken = await getJWT();
  HttpClient client = new HttpClient();
  client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
  HttpClientRequest request = await client
      .postUrl(Uri.parse("https://localhost:7097/api/Files/file"));
  request.headers.set('Content-Type', 'application/json');

  // Convert Uint8List to List<int> to match the expected type
  final List<int> fileDataList = fileData.cast<int>();

  final Map<String, dynamic> requestBody = {
    'FisierNume': fileName,
    'FisierDataUpload': uploadDate.toIso8601String(),
    'CursId': courseId,
    'FisierExtensie': fileType,
    'FisierContinutBase64': base64Encode(fileData)
  };

  final requestBodyJson = jsonEncode(requestBody);

  //print('Request body: $requestBody');
  //print('CourseID: $courseId');
  request.write(requestBodyJson);
  HttpClientResponse result = await request.close();

 //print('Response Status Code: ${result.statusCode}');

  if (result.statusCode == 200) {
    print('File successfully uploaded');
  } else {
    print(result);
    print(result.reasonPhrase);
    print('JWT TOKEN ' + jwtToken.toString());
    print('File upload failed!');
  }
}
  factory FileApp.fromJson(Map<String, dynamic> json) {
    return FileApp(
      fileId: json["FisierId"], 
      courseId: json["CursId"], 
      fileName: json["FisierNume"], 
      fileType: json["FisierExtensie"], 
      fileData: base64Decode(json["FisierContinut"]), 
      ftpFile: '', 
      uploadDate: DateTime.parse(json["FisierDataUpload"]));
  }
}
Future<List<FileApp>> retrieveFiles(int courseId) async {
  HttpClient client = new HttpClient();
  client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);

  HttpClientRequest request = await client
      .getUrl(Uri.parse("https://localhost:7097/api/Files/files?cursId=$courseId"));
  request.headers.set('Content-Type', 'application/json');

  HttpClientResponse response = await request.close();

  if (response.statusCode == 200) {
    String responseBody = await response.transform(utf8.decoder).join();
    List<dynamic> jsonList = jsonDecode(responseBody);

    List<FileApp> files =
        jsonList.map((json) => FileApp.fromJson(json)).toList();
    return files;
  } else {
    print('Failed to retrieve domains. Status code: ${response.statusCode}');
    return [];
  }
}
  
Future<void> DeleteFile(int fileId) async {
  String? jwtToken = await getJWT();
  HttpClient client = new HttpClient();
  client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);

  Uri url = Uri.parse("https://localhost:7097/api/Files/file?fisierId=$fileId");
  HttpClientRequest request = await client.deleteUrl(url);
  request.headers.set('Content-Type', 'application/json');
  request.headers.set('Authorization', 'Bearer ${jwtToken.toString()}');

  HttpClientResponse response = await request.close();

  if (response.statusCode == 200) {
    print('Domain deleted successfully');
  } else {
    print('Failed to delete domain. Status code: ${response.statusCode}');
  }
  client.close();
}