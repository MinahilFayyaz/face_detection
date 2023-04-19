import 'dart:typed_data';
import 'dart:io';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactAvatarPicker extends StatefulWidget {
  const ContactAvatarPicker({Key? key}) : super(key: key);

  @override
  State<ContactAvatarPicker> createState() => _ContactAvatarPickerState();
}

class _ContactAvatarPickerState extends State<ContactAvatarPicker> {
  final imagePicker = ImagePicker();
  CircleAvatar avatar = const CircleAvatar(radius: 50);

  Future<void> pickImage() async {
    final pickedFile =
    await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        avatar = CircleAvatar(
          radius: 50,
          backgroundImage: FileImage(File(pickedFile.path)),
        );
      });

      final Iterable<Contact> contacts =
      (await ContactsService.getContacts()).toList();
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Select a contact'),
            content: SizedBox(
              width: double.maxFinite,
              height: 200.0,
              child: ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (BuildContext context, int index) {
                  final contact = contacts.elementAt(index);
                  return ListTile(
                    title: Text(contact.displayName ?? ''),
                    onTap: () async {
                      final bytes = await pickedFile.readAsBytes();
                      final avatar = Avatar(bytes.buffer.asUint8List());

                      final contactToUpdate = MyContact().copyWith(
                        avatar: avatar.bytes != null
                            ? Avatar(Uint8List.fromList(avatar.bytes))
                            : null,
                      );

                      await ContactsService.updateContact(contactToUpdate);

                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                      setState(() {
                        this.avatar = CircleAvatar(
                          radius: 50,
                          backgroundImage: FileImage(File(pickedFile.path)),
                        );
                      });
                    },
                  );
                },
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Avatar Picker'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: pickImage,
          child: const Text('Pick an avatar'),
        ),
      ),
    );
  }
}

class Avatar {
  final List<int> bytes;

  Avatar(this.bytes);
}



class MyContact extends Contact {
  MyContact({
    String? displayName,
    String? givenName,
    String? middleName,
    String? prefix,
    String? suffix,
    String? familyName,
    Iterable<Item>? emails,
    Iterable<Item>? phones,
    Iterable<PostalAddress>? postalAddresses,
    String? company,
    String? jobTitle,
    Avatar? avatar,
  }) : super(
    displayName: displayName,
    givenName: givenName,
    middleName: middleName,
    prefix: prefix,
    suffix: suffix,
    familyName: familyName,
    emails: emails?.toList(),
    phones: phones?.toList(),
    postalAddresses: postalAddresses?.toList(),
    company: company,
    jobTitle: jobTitle,
    avatar: avatar?.bytes != null
        ? Uint8List.fromList(avatar!.bytes)
        : null,
  );

  MyContact copyWith({
    String? displayName,
    String? givenName,
    String? middleName,
    String? prefix,
    String? suffix,
    String? familyName,
    Iterable<Item>? emails,
    Iterable<Item>? phones,
    Iterable<PostalAddress>? postalAddresses,
    String? company,
    String? jobTitle,
    Avatar? avatar,
  }) {
    return MyContact(
      displayName: displayName ?? this.displayName,
      givenName: givenName ?? this.givenName,
      middleName: middleName ?? this.middleName,
      prefix: prefix ?? this.prefix,
      suffix: suffix ?? this.suffix,
      familyName: familyName ?? this.familyName,
      emails: emails,
      phones: phones,
      postalAddresses: postalAddresses,
      company: company ?? this.company,
      jobTitle: jobTitle ?? this.jobTitle,
      avatar: avatar ?? (this.avatar != null ? Avatar(List<int>.from(this.avatar!)) : null),
    );
  }
}


