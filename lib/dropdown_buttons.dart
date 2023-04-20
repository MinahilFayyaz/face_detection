import 'package:flutter/material.dart';

const List<String> list1 = <String>[
  '23 x 35 pixels',
  '35 x 47 pixels',
  '45 x 55 pixels',
  '55 x 60 pixels'
];
const List<String> list2 = <String>[
  '23 x 35 pixels',
  '35 x 47 pixels',
];
const List<String> list3 = <String>[
  'America',
  'Australia',
  'England',
  'Germany',
  'Dubai'
];

class DropdownButtonApp extends StatelessWidget {
  const DropdownButtonApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('DropdownButton Sample')),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: DropdownButton1(),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: DropdownButton2(),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: DropDownButton3(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DropdownButton1 extends StatefulWidget {
  const DropdownButton1({Key? key}) : super(key: key);

  @override
  _DropdownButton1State createState() => _DropdownButton1State();
}

class _DropdownButton1State extends State<DropdownButton1> {
  String dropdownValue1 = list1.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue1,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        setState(() {
          dropdownValue1 = value!;
        });
      },
      items: list1
          .map<DropdownMenuItem<String>>((String value) => DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      ))
          .toList(),
    );
  }
}

class DropdownButton2 extends StatefulWidget {
  const DropdownButton2({Key? key}) : super(key: key);

  @override
  State<DropdownButton2> createState() => _DropdownButton2State();
}

class _DropdownButton2State extends State<DropdownButton2> {
  String dropdownValue2 = list2.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue2,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        setState(() {
          dropdownValue2 = value!;
        });
      },
      items: list2
          .map<DropdownMenuItem<String>>((String value) => DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      ))
          .toList(),
    );
  }
}

class DropDownButton3 extends StatefulWidget {
  const DropDownButton3({Key? key}) : super(key: key);

  @override
  State<DropDownButton3> createState() => _DropDownButton3State();
}

class _DropDownButton3State extends State<DropDownButton3> {
  String dropDownValue3 = list3.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        value: dropDownValue3,
        elevation: 16,
        icon: const Icon(Icons.arrow_downward),
        style: const TextStyle(color: Colors.deepPurple),
        underline: Container(
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
        onChanged: (String? value){
          setState(() {
            dropDownValue3 = value!;
          });
        },
       items: list3.map<DropdownMenuItem<String>>((String value){
          return DropdownMenuItem(
              value: value,
              child: Text(value)
          );
        }).toList(),
        );
  }
}
