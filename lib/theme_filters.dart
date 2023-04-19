// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:photofilters/photofilters.dart';
import 'package:image/image.dart' as imageLib;
import 'package:image_picker/image_picker.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({Key? key}) : super(key: key);

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {

  imageLib.Image? _image;
  File? image;
  Uint8List? imageFile;
  Filter? filter;
  List<Filter> filters = presetFiltersList;

  _getFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    image = File(pickedFile!.path);
    if (pickedFile != null) {
      setState(() {

         var imageFile = imageLib.decodeImage(image!.readAsBytesSync());
        _image = imageFile;
        print('file name : $imageFile');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async{
            await _getFromGallery();
            Navigator.push(context,
            MaterialPageRoute(builder: (context)
            => _image != null
                ?PhotoFilterSelector(
                title: Text('filters'),
                filters: presetFiltersList,
                image: _image!,
                filename: image != null ? image!.path : '',
            loader: Center(
              child: CircularProgressIndicator(),
            ),
            )
              : Container(),
            ),
            );
          },
          label: Text("Button"),
          icon: Icon(Icons.add, color: Colors.black,),
      ),




    );
  }
}
