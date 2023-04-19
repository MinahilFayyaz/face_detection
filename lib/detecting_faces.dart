import 'package:flutter/material.dart';

class isDetectingFaces extends StatelessWidget {
  const isDetectingFaces({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width/1.1,
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
    );
  }
}
