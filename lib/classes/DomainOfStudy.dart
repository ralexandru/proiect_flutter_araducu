import 'dart:convert';
import 'dart:async';
import 'dart:io';
import '../main.dart';

class DomainOfStudy {
  int? domainId;
  String domainName = '';
  String domainDescription = '';
  DomainOfStudy(
      {required this.domainName,
      required this.domainDescription,
      this.domainId});
  factory DomainOfStudy.fromJson(Map<String, dynamic> json) {
    return DomainOfStudy(
      domainId: json['DomeniuId'],
      domainName: json['DomeniuDenumire'],
      domainDescription: json['DomeniuDescriere'],
    );
  }

  Map<String, dynamic> toJsonDelete() {
    return {
      'DomeniuId': domainId,
      'DomeniuDenumire': domainName,
      'DomeniuDescriere': domainDescription,
    };
  }

  Map<String, dynamic> toJsonCreate() {
    return {
      'DomeniuDenumire': domainName,
      'DomeniuDescriere': domainDescription,
    };
  }

  Future<bool> CreateDomain() async {
    String? jwtToken = await getJWT();
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client
        .postUrl(Uri.parse("https://localhost:7097/api/Domain/create-domain"));
    request.headers.set('Content-Type', 'application/json');
    request.headers.set('Authorization', 'Bearer ${jwtToken.toString()}');

    final Map<String, String> requestBody = {
      'DomeniuDenumire': domainName,
      'DomeniuDescriere': domainDescription,
    };

    final requestBodyJson = jsonEncode(requestBody);

    request.write(requestBodyJson);
    HttpClientResponse result = await request.close();

    print(result.statusCode);

    if (result.statusCode == 200) {
      print('Domain successfully added');
      return true;
    } else {
      print('JWT TOKEN ' + jwtToken.toString());
      print('Domain add failed!');
      return false;
    }
  }
}

Future<void> UpdateDomain(DomainOfStudy updatedDomain) async {
  HttpClient client = new HttpClient();
  client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);

  Uri url = Uri.parse("https://localhost:7097/api/Domain/domain");
  HttpClientRequest request = await client.putUrl(url);
  request.headers.set('Content-Type', 'application/json');

  // Convert the updatedDomain to JSON
  String jsonDomain = jsonEncode(updatedDomain.toJsonDelete());

  // Write the JSON data to the request body
  request.write(jsonDomain);

  HttpClientResponse response = await request.close();

  if (response.statusCode == 200) {
    print('Domain updated successfully');
  } else {
    print('Failed to update domain. Status code: ${response.statusCode}');
  }
  client.close();
}

Future<void> DeleteDomain(DomainOfStudy updatedDomain) async {
  HttpClient client = new HttpClient();
  client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);

  Uri url = Uri.parse("https://localhost:7097/api/Domain/domain");
  HttpClientRequest request = await client.deleteUrl(url);
  request.headers.set('Content-Type', 'application/json');

  String jsonDomain = jsonEncode(updatedDomain.toJsonDelete());

  request.write(jsonDomain);

  HttpClientResponse response = await request.close();

  if (response.statusCode == 200) {
    print('Domain deleted successfully');
  } else {
    print('Failed to delete domain. Status code: ${response.statusCode}');
  }
  client.close();
}

Future<List<DomainOfStudy>> retrieveDomains() async {
  HttpClient client = new HttpClient();
  client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);

  HttpClientRequest request = await client
      .getUrl(Uri.parse("https://localhost:7097/api/Domain/domains"));
  request.headers.set('Content-Type', 'application/json');

  HttpClientResponse response = await request.close();

  if (response.statusCode == 200) {
    String responseBody = await response.transform(utf8.decoder).join();
    List<dynamic> jsonList = jsonDecode(responseBody);

    List<DomainOfStudy> domains =
        jsonList.map((json) => DomainOfStudy.fromJson(json)).toList();
    print("DOMAIN ID: " + (domains[0].domainId).toString());
    return domains;
  } else {
    print('Failed to retrieve domains. Status code: ${response.statusCode}');
    return [];
  }
}
Future<DomainOfStudy> fetchDomainInfo(int? domainId) async {
  HttpClient client = new HttpClient();
  int DomainId2 = domainId ?? 0;
  
  client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
  final request = await client.getUrl(Uri.parse('https://localhost:7097/api/Domain/domain?DomeniuId=$DomainId2'));
 HttpClientResponse response = await request.close();

  if (response.statusCode == 200) {
    String responseBody = await response.transform(utf8.decoder).join();
    final Map<String, dynamic> responseData = json.decode(responseBody);

    DomainOfStudy domain = DomainOfStudy(
      domainId: responseData['DomeniuId'],
      domainName: responseData['DomeniuDenumire'],
      domainDescription: responseData['DomeniuDescriere'],
    );

    return domain;
  } else {
    print('STATUS CODE ${response.statusCode}');
    throw Exception('Failed to load domain info');
  }
}