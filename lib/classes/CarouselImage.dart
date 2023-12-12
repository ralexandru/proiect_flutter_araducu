import '../main.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
class CarouselImage{
  int ImageId;
  String ImageUrl;

  CarouselImage({required this.ImageId, required this.ImageUrl});

    factory CarouselImage.fromJson(Map<String, dynamic> json) {
      return CarouselImage(
        ImageId: json['ImagineId'],
        ImageUrl: json['ImagineUrl'],
      );
    }
}

Future<void> AddCarouselImage(String imageUrl) async {
  String? jwtToken = await getJWT();
  HttpClient client = new HttpClient();
  client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);

  Uri url = Uri.parse("https://localhost:7097/api/Carousel/imagine-carousel");
  HttpClientRequest request = await client.postUrl(url);
  request.headers.set('Content-Type', 'application/json');
  request.headers.set('Authorization', 'Bearer ${jwtToken.toString()}');

  final Map<String, dynamic> requestBody = {
    'ImagineURL': imageUrl,
  };

  final requestBodyJson = jsonEncode(requestBody);
   request.write(requestBodyJson);
   print(requestBodyJson);
  HttpClientResponse result = await request.close();

  print(result.statusCode);
  if (result.statusCode == 200) {
    print('Image successfully added');
  } else {
    print('JWT TOKEN ' + jwtToken.toString());
    print('Image add failed!');
  }
}


Future<List<CarouselImage>> retrieveImages() async {
  HttpClient client = new HttpClient();
  client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);

  HttpClientRequest request = await client
      .getUrl(Uri.parse("https://localhost:7097/api/Carousel/imagini-carousel"));
  request.headers.set('Content-Type', 'application/json');

  HttpClientResponse response = await request.close();

  if (response.statusCode == 200) {
    String responseBody = await response.transform(utf8.decoder).join();
    List<dynamic> jsonList = jsonDecode(responseBody);

    List<CarouselImage> images =
        jsonList.map((json) => CarouselImage.fromJson(json)).toList();
    print("ImageId ID: " + (images[0].ImageId).toString());
    return images;
  } else {
    print('Failed to retrieve Images. Status code: ${response.statusCode}');
    return [];
  }
}

Future<void> DeleteImage(int imageId) async {
  String? jwtToken = await getJWT();
  HttpClient client = new HttpClient();
  client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);

  Uri url = Uri.parse("https://localhost:7097/api/Carousel/imagine-carousel?imagineId=$imageId");
  HttpClientRequest request = await client.deleteUrl(url);
  request.headers.set('Content-Type', 'application/json');
  request.headers.set('Authorization', 'Bearer ${jwtToken.toString()}');

  HttpClientResponse response = await request.close();
  print("URL $url");
  if (response.statusCode == 200) {
    print('Image deleted successfully');
  } else {
    print('Failed to delete image. Status code: ${response.statusCode}');
  }
  client.close();
}