import 'package:flutter/material.dart';


class Contact {
  final String name;
  final String imagePath;

  Contact({required this.name, required this.imagePath});
}

class ContactImage extends StatelessWidget {
  final contacts = [
    Contact(name: "John Smith", imagePath: "assets/images/john_smith.jpg"),
    Contact(name: "Jane Doe", imagePath: "assets/images/jane_doe.jpg"),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contacts Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Contacts'),
        ),
        body: ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            Contact contact = contacts[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(contact.imagePath),
              ),
              title: Text(contact.name),
            );
          },
        ),
      ),
    );
  }
}
