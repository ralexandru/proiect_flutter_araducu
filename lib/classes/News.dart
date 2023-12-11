import 'dart:convert';
import 'dart:async';
import 'dart:io';
import '../main.dart';

class News {
  int? newsId;
  String newsName = '';
  DateTime? newsPublishDate;
  String newsContent = '';
  News(
      {required this.newsName,
      required this.newsContent,
      this.newsPublishDate,
      this.newsId});
  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      newsId: json['StireId'],
      newsName: json['StireDenumire'],
      newsPublishDate: DateTime.parse(json['StireDataPublicare']),
      newsContent: json['StireContinut'],
    );
  }

  Map<String, dynamic> toJsonDelete() {
    return {
      'StireId': newsId,
      'StireDenumire': newsName,
      'StireContinut': newsContent,
    };
  }

  Map<String, dynamic> toJsonCreate() {
    return {
      'StireDenumire': newsId,
      'StireDataPublicare': newsPublishDate,
      'StireContinut': newsContent,
    };
  }

  Future<void> AddNews() async {
    String? jwtToken = await getJWT();
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client
        .postUrl(Uri.parse("https://localhost:7097/api/Stiri/publica-stire"));
    request.headers.set('Content-Type', 'application/json');
    request.headers.set('Authorization', 'Bearer ${jwtToken.toString()}');

    final Map<String, String> requestBody = {
      'StireDenumire': newsName,
      'StireDataPublicare': DateTime.now().toIso8601String(),
      'StireContinut': newsContent
    };

    final requestBodyJson = jsonEncode(requestBody);
    print(requestBodyJson);
    request.write(requestBodyJson);
    HttpClientResponse result = await request.close();

    print(result.statusCode);

    if (result.statusCode == 200) {
      print('News successfully added');
    } else {
      print('JWT TOKEN ' + jwtToken.toString());
      print('News add failed!');
    }
  }
}

Future<void> DeleteNews(int stireId) async {
  String? jwtToken = await getJWT();
  HttpClient client = new HttpClient();
  client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);

  Uri url = Uri.parse("https://localhost:7097/api/Stiri/stire?stireId=$stireId");
  HttpClientRequest request = await client.deleteUrl(url);
  request.headers.set('Content-Type', 'application/json');
  request.headers.set('Authorization', 'Bearer ${jwtToken.toString()}');

  HttpClientResponse response = await request.close();

  if (response.statusCode == 200) {
    print('News deleted successfully');
  } else {
    print('Failed to delete news. Status code: ${response.statusCode}');
  }
  client.close();
}

Future<List<News>> retrieveNews() async {
  HttpClient client = new HttpClient();
  client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);

  HttpClientRequest request = await client
      .getUrl(Uri.parse("https://localhost:7097/api/Stiri/stiri"));
  request.headers.set('Content-Type', 'application/json');

  HttpClientResponse response = await request.close();

  if (response.statusCode == 200) {
    String responseBody = await response.transform(utf8.decoder).join();
    List<dynamic> jsonList = jsonDecode(responseBody);

    List<News> news =
        jsonList.map((json) => News.fromJson(json)).toList();
    print("News ID: " + (news[0].newsId).toString());
    return news;
  } else {
    print('Failed to retrieve domains. Status code: ${response.statusCode}');
    return [];
  }
}
/*
Future<News> fetchDomainInfo(int? domainId) async {
  HttpClient client = new HttpClient();
  int DomainId2 = domainId ?? 0;
  
  client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
  final request = await client.getUrl(Uri.parse('https://localhost:7097/api/Domain/domain?DomeniuId=$DomainId2'));
 HttpClientResponse response = await request.close();

  if (response.statusCode == 200) {
    String responseBody = await response.transform(utf8.decoder).join();
    final Map<String, dynamic> responseData = json.decode(responseBody);

    // Parse Course details
    DomainOfStudy domain = DomainOfStudy(
      domainId: responseData['DomeniuId'],
      domainName: responseData['DomeniuDenumire'],
      domainDescription: responseData['DomeniuDescriere'],
    );

    // Parse CourseMeeting detail

    return domain;
  } else {
    print('STATUS CODE ${response.statusCode}');
    throw Exception('Failed to load domain info');
  }
  
}*/