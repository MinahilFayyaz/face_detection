import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:google_ml_kit/google_ml_kit.dart';

class FaceDetectorPainter extends CustomPainter {
  final List<Face> faces;
  final ui.Image image;//added now
  final List<Rect> rects = []; //added now


  //added now
  FaceDetectorPainter(this.faces, this.image){
    for (var i = 0; i<faces.length; i++){
      rects.add(faces[i].boundingBox);
    }
  }

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..blendMode = BlendMode.screen
      ..strokeWidth = 2.0;

    canvas.drawImage(image, Offset.zero, Paint()); //added now

    for (var i = 0; i < faces.length; i++) {
      final Face face = faces[i];
      canvas.drawRect(
          rects[i],// added now
          // Rect.fromLTWH(
          //   face.boundingBox.left.toDouble(),
          //   face.boundingBox.top.toDouble(),
          //   face.boundingBox.width.toDouble(),
          //   face.boundingBox.height.toDouble(),
          // ),
          paint);
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    //return oldDelegate.faces != faces;
    return image != oldDelegate.image || faces != oldDelegate.faces; //added now
  }
}
