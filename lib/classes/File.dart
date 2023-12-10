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

  print('Request body: $requestBody');
  print('CourseID: $courseId');
  request.write(requestBodyJson);
  HttpClientResponse result = await request.close();

  print('Response Status Code: ${result.statusCode}');

  if (result.statusCode == 200) {
    print('File successfully uploaded');
  } else {
    print(result);
    print(result.reasonPhrase);
    print('JWT TOKEN ' + jwtToken.toString());
    print('File upload failed!');
  }
}

  }
  
