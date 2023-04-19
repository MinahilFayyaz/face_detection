import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:photofilters/photofilters.dart';
import 'package:image/image.dart' as imageLib;
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  imageLib.Image? _image;
  Uint8List? image;
  File? fileName;
  Filter? filter;
  List<Filter> filters = presetFiltersList;
  final picker = ImagePicker();

  getImage() async {
    var imageFile = await picker.pickImage(source: ImageSource.gallery);
    fileName = File(imageFile!.path);

    var bytes = await imageFile.readAsBytes();
    var image = imageLib.decodeImage(bytes);

    if(imageFile != null)
    {
      setState(()  {
        _image = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async{
          await getImage();
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => _image != null
                    ? PhotoFilterSelector(
                  title: Text("Filters"),
                  image: _image!,
                  filters: filters,
                  filename: fileName != null ?fileName!.path : "",
                  loader: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
                    : Container(),
              )
          );
        },
        label: Text("Button"),
        icon: Icon(
          Icons.browse_gallery,
          color: Colors.black,
        ),
      ),
    );
  }
}