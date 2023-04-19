import 'dart:io';
import 'dart:typed_data';
import 'package:face_detection/FacePainter.dart';
import 'package:face_detection/image_background.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'dart:ui' as ui;
import 'package:before_after_image_slider_nullsafty/before_after_image_slider_nullsafty.dart';

class FaceDetectionPage extends StatefulWidget {
  @override
  _FaceDetectionPageState createState() => _FaceDetectionPageState();
}

class _FaceDetectionPageState extends State<FaceDetectionPage> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  bool _isDetectingFaces = false;
  List<Face> _detectedFaces = [];
  Uint8List? imageFile;
  String imagePath = '';
  var loaded = false;
  var removeBg = false;
  var isloading = false;
  ui.Image? _image; //added now

  getImage(bool camera) async{
    File image;
    final _picker = ImagePicker();
    var pickedFile;
    if(camera){
      pickedFile = await _picker.pickImage(source: ImageSource.camera);
      image = File(pickedFile.path);
      imageFile = await image.readAsBytes();
    }
    else {
      pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      image = File(pickedFile.path);
      imageFile = await image.readAsBytes();
    }
    setState(() {
      if(_imageFile == null)
        {
          print("error occured");
        }
      else {
      }
       imagePath= image.path;
       loaded = true;
      _imageFile = image;
      _isDetectingFaces = true;
    });

    detectFaces(_imageFile!);
  }


  /*Future<void> _selectImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
      _detectFaces(_imageFile!);
    }
  }

  Future<void> _cameraImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
      _detectFaces(_imageFile!);
    }
  }*/

  /*Future<void> _detectFaces() async {
    if (_isDetectingFaces || _imageFile == null) return;

    setState(() => _isDetectingFaces = true);

    try {
      final inputImage = InputImage.fromFile(_imageFile!);
      final faceDetector = GoogleMlKit.vision.faceDetector(FaceDetectorOptions(
        enableLandmarks: true,
        enableContours: false,
        enableClassification: false,
        minFaceSize: 0.15,
        performanceMode: FaceDetectorMode.accurate,
      ));
      final detectedFaces = await faceDetector.processImage(inputImage);
      setState(() => _detectedFaces = detectedFaces);
    } catch (e) {
      print('Error detecting faces: $e');
    } finally {
      setState(() => _isDetectingFaces = false);
    }
  }*/


  detectFaces(File imageFile) async {
      final inputImage = InputImage.fromFile(imageFile);
      final faceDetector = GoogleMlKit.vision.faceDetector();
      List <Face> faces = await faceDetector.processImage(inputImage);
      if (mounted){
        setState(() {
          _imageFile = imageFile;
          _detectedFaces = faces;
          _loadImage(imageFile);
        });
    }
  }

  //added now
  _loadImage(File file)async{
    final data = await file.readAsBytes();
    await decodeImageFromList(data).then((value) => setState((){
      _image = value;
     // _detectedFaces = false;
      _isDetectingFaces = false;
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Detection'),
      ),
      /*body:Column(
        children: [
          Expanded(
            child: _imageFile != null
                ? Image.file(_imageFile!)
                : const Center(
              child: Text('No image selected'),
            ),
          ),
          ElevatedButton(
            onPressed: (){
              getImage(false);
          },child: const Text('Select Image from Gallery'),
          ),
          ElevatedButton(
            onPressed: (){
              getImage(true);
            },
            child: const Text('Select Image from Camera'),
          ),
          // ElevatedButton(
          //   onPressed: _detectedFaces,
          //   child: Text('Detect Faces'),
          // ),
          Expanded(
            child: _isDetectingFaces
                ? Center(
                  child: Column(
              children : [
                  const SizedBox(
                    height: 40,
                  ),
                  const CircularProgressIndicator(),
                  const SizedBox(
                    height: 40,
                  ),
                  const Text('NO Face Detected')
              ]
            ),
                )
                : Center(
              child: Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: [
                    FittedBox(
                      child: SizedBox(
                        width: _image!.width.toDouble(),
                        height: _image!.height.toDouble(),
                        child: CustomPaint(
                          painter: FaceDetectorPainter(_image as List<Face>, _detectedFaces as ui.Image),
                        ),
                      ),
                    ),
                    ListView.builder(
              itemCount: _detectedFaces.length,
              itemBuilder: (context, index) {
                final face = _detectedFaces[index];
                return ListTile(
                  leading: Text('Face ${index + 1}'),
                  title: Text('Left eye open probability: ${face.leftEyeOpenProbability ?? '-'}'),
                  subtitle: Text('Right eye open probability: ${face.rightEyeOpenProbability ?? '-'}'),
                );
              },
            ),
                  ],
                ),
              ),
            )
          ),
        ],
      ),*/
      body: _isDetectingFaces
      ? Center(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/2,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
            child: Center(child: CircularProgressIndicator(),),
            ),
            Container(
              child : Text("no face detected please choose anyother image"),
            )
          ],
        ),
      )
          : (_imageFile == null)
        ? Center(
        child: Column(
          children: [
            removeBg
            ? BeforeAfter(
              beforeImage : Image.file(File(imagePath)),
              afterImage :Image.memory(imageFile!),
            )
            :loaded
             ? Container(
              width: MediaQuery.of(context).size.width/1.1,
              height: MediaQuery.of(context).size.height/2,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text('No image selected'),
              ),
            )
            : Container(
              child: ListView.builder(
                itemCount: _detectedFaces.length,
                itemBuilder: (context, index) {
                  final face = _detectedFaces[index];
                  return ListTile(
                    leading: Text('Face ${index + 1}'),
                    title: Text('Left eye open probability: ${face.leftEyeOpenProbability ?? '-'}'),
                    subtitle: Text('Right eye open probability: ${face.rightEyeOpenProbability ?? '-'}'),
                  );
                },
              ),
            )
          ],
        ),
      )
          : Center(child: Column(
            children: [
              GestureDetector(
                onTap: getImage(false),
                child: Container(
        margin: EdgeInsets.only(left: 10,right: 10),
        child: FittedBox(
                child: SizedBox(
                  width: _image!.width.toDouble(),
                  height: _image!.height.toDouble(),
                  child: CustomPaint(
                    painter: FaceDetectorPainter(_detectedFaces, _image!),
                  ),
                ),
        ),
      ),
              ),
              Container(
                child: ListView.builder(
                  itemCount: _detectedFaces.length,
                  itemBuilder: (context, index) {
                    final face = _detectedFaces[index];
                    return ListTile(
                      leading: Text('Face ${index + 1}'),
                      title: Text('Left eye open probability: ${face.leftEyeOpenProbability ?? '-'}'),
                      subtitle: Text('Right eye open probability: ${face.rightEyeOpenProbability ?? '-'}'),
                    );
                  },
                ),
              )
            ],
          ),),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              onPressed: (){
                setState(() {
                  _imageFile = null;
                });
              },
              child: Icon(Icons.refresh),
            ),
          ),
          Padding(padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              onPressed: (){
                setState(() {
                  getImage(true);
                });
              },
              child: Icon(Icons.camera_alt),
            ),
          ),
          Padding(padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              onPressed: (){
                getImage(false);
              },
              child: Icon(Icons.image),
            ),
          ),

          Padding(padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              onPressed: loaded  ?() async{
              imageFile = await ApiClient.removebg(imagePath!);
              setState(() {
                isloading = true;
              });
                if(imageFile != null)
                  {
                    removeBg = true;
                    isloading = false;
                    setState(() {
                    });
                  }
              }
              : null,
              child: isloading ? const CircularProgressIndicator() : Icon(Icons.navigate_next),
            ),
          ),
        ],
      ),
    );
  }
}



/*import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class FaceDetectionPage extends StatefulWidget {
  final String imagePath;

  FaceDetectionPage({required this.imagePath});

  @override
  _FaceDetectionPageState createState() => _FaceDetectionPageState();
}

class _FaceDetectionPageState extends State<FaceDetectionPage> {
  //late final FaceDetector _faceDetector;
  bool _isDetectingFaces = false;
  List<Face> _detectedFaces = [];*/

/*
  @override
  void initState() {
    super.initState();
    _detectFaces();
  }
*/
//FireBaseImageVision
/*  @override
  void initState() {
    super.initState();
    _faceDetector = GoogleMlKit.vision.faceDetector(
      FaceDetectorOptions(
        enableLandmarks: true,
        enableContours: false,
        enableClassification: false,
        minFaceSize: 0.15,
        performanceMode: FaceDetectorMode.fast,
      ),
    );
  }

@override
void dispose() {
  _faceDetector.close();
  super.dispose();
}


  Future<void> _detectFaces(Uint8List imageData) async {
    if (_isDetectingFaces) return;

    try {
      setState(() => _isDetectingFaces = true);

      final inputImage = FirebaseVisionImage.fromBytes(imageData);
      final faces = await _faceDetector.processImage(inputImage);

      if (faces.isEmpty) {
        // No faces detected
        print('No faces detected');
      } else {
        // Face detected
        for (final face in faces) {
          final boundingBox = face.boundingBox;
          final left = boundingBox.left.toInt();
          final top = boundingBox.top.toInt();
          final width = boundingBox.width.toInt();
          final height = boundingBox.height.toInt();

          // Do something with the face coordinates
          print('Face detected at: $left, $top with width: $width and height: $height');
        }
      }
    } catch (e) {
      print('Error detecting faces: $e');
    } finally {
      setState(() => _isDetectingFaces = false);
    }
  }*/
//FirebaseImageVision
 /* void _detectFaces() async {
    final bytes = await File(widget.imagePath).readAsBytes();
    final ui.Image image = await decodeImageFromList(bytes);
    final FaceDetector faceDetector = GoogleMlKit.vision.faceDetector();
    final List<Face> faces = await faceDetector.processImage(image as InputImage);
    setState(() {
      _faces = faces;
    });
  }*/

/*  Future<void> _detectFaces() async {
    if (_isDetectingFaces || widget.imagePath == null) return;

    setState(() => _isDetectingFaces = true);

    try {
      final inputImage = InputImage.fromFile(widget.imagePath! as File);
      final faceDetector = GoogleMlKit.vision.faceDetector(FaceDetectorOptions(
        enableLandmarks: true,
        enableContours: false,
        enableClassification: false,
        minFaceSize: 0.15,
      ));
      final detectedFaces = await faceDetector.processImage(inputImage);
      setState(() => _detectedFaces = detectedFaces);
    } catch (e) {
      print('Error detecting faces: $e');
    } finally {
      setState(() => _isDetectingFaces = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    final imageData = base64.decode(widget.imagePath);
    _detectFaces();
    return Scaffold(
      appBar: AppBar(
        title: Text('Face Detection'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
          child: Image.file(
            File(widget.imagePath),
            fit: BoxFit.contain,
        ),
      ),
    );
  }
}*/

