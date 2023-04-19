import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:url_launcher/url_launcher.dart';


class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<Contact>? contacts;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getContact();
  }

  void getContact() async {
    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      print(contacts);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Contact Fetch",
            style: TextStyle(color: Colors.blue),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: (contacts) == null
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: contacts!.length,
          itemBuilder: (BuildContext context, int index) {
            Uint8List? image = contacts![index].photo;
            String num = (contacts![index].phones.isNotEmpty) ? (contacts![index].phones.first.number) : "--";
            return GestureDetector(
              child: ListTile(
                  leading: (contacts![index].photo == null)
                      ? const CircleAvatar(child: Icon(Icons.person))
                      : CircleAvatar(backgroundImage: MemoryImage(image!)),
                  title: Text(
                      "${contacts![index].name.first} ${contacts![index].name.last}"),
                  subtitle: Text(num),
                  onTap: () {
                    if (contacts![index].phones.isNotEmpty) {
                      launchUrl('tel: ${num}' as Uri);
                    }
                  }),
            );
          },
        ));
  }
}