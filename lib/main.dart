import 'package:face_detection/contact_avatar_picker.dart';
import 'package:flutter/material.dart';

import 'contact_services.dart';




void main() async{
  runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
      home : HomePage()
   )
  );
}

/*class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File? imageFile;


  /// Widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Image Picker"),
        ),
        body: Container(
            child: imageFile == null
                ? Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  FloatingActionButton(
                    onPressed: () {
                      _getFromGallery();
                    },
                    child: Icon(Icons.browse_gallery),
                  ),

                  Container(
                    height: 40.0,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      _getFromCamera();
                    },
                    child: Icon(Icons.camera),
                  )
                ],
              ),
            ):

            GestureDetector(
              onTap: (){
                File file = File(imageFile!.path);
                String imagePath = file.path;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FaceDetectionPage()),
                );
              },
                child: Image.file(
                  imageFile!,
                  fit: BoxFit.cover,
                ),
            ),
        )
    );
  }

  /// Get from gallery
  _getFromGallery() async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        print('file name : $imageFile');
      });
    }
  }

  /// Get from Camera
  _getFromCamera() async {
    final picker= ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }
}*/
