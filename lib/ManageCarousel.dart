import 'package:flutter/material.dart';
import 'package:proiect_flutter_araducu/Home.dart';
import 'commonClasses/utilities.dart';
import 'classes/CarouselImage.dart';

List<CarouselImage> images = [];

class ManageCarousel extends StatefulWidget{
  @override
  _ManageCarouselState createState() => _ManageCarouselState();
}
class _ManageCarouselState extends State<ManageCarousel>{
  TextEditingController carouselUrl = new TextEditingController();

List<Widget> CreateImagesContainer(List<CarouselImage> images){
  List<Widget> containers = [];
  for(int i = 0; i < images.length;i++){
    Column column = Column(children: [
      Text(images[i].ImageUrl),
      OutlinedButton(child: Text("Delete"),onPressed: () => {
        DeleteImage(images[i].ImageId),
         setState(() {
        images.removeWhere((image) => image.ImageId==images[i].ImageId);
      })}
      ),
      SizedBox(height:20)],
      
    );
    containers.add(column);
  }
  return containers;
}
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Carousel Images", style: TextStyle(color: Colors.blue)),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
Row(
  children: [
    Expanded(
      child: FilledTextField(
        controller: carouselUrl,
        icon: Icon(Icons.description),
        labelText: '',
        editable: true,
        hintText: 'Enter link to image',
      ),
    ),
    CircularButton(iconData: Icons.add,   onPressed: () async {
    await AddCarouselImage(carouselUrl.text);
    List<CarouselImage> updatedImages = await retrieveImages();
    setState(() {
      images = updatedImages;
    });
  }, color: Colors.blue),
  ]),
  SizedBox(height:20),
  Column(
    children: [
                  FutureBuilder(
                future: retrieveImages(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    images =
                        snapshot.data as List<CarouselImage>;
                    return Column(
                      children: CreateImagesContainer(images),
                    );
                  }
                },
              ),
  ],
)
          ]
        )
      )
    );
  }
}