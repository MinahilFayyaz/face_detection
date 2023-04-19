import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:face_detection/navigation_service.dart';
import 'package:face_detection/app_router.dart';
import 'package:uuid/uuid.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late final Uuid _uuid;
  String? _currentUuid;

  @override
  void initState() {
    super.initState();
    _uuid = const Uuid();
    WidgetsBinding.instance.addObserver(this);
    //Check call when open app from terminated
    checkAndNavigationCallingPage();
  }

  getCurrentCall() async {
    //check current call from pushkit if possible
    var calls = await FlutterCallkitIncoming.activeCalls();
    if (calls is List) {
      if (calls.isNotEmpty) {
        print('DATA: $calls');
        _currentUuid = calls[0]['id'];
        return calls[0];
      } else {
        _currentUuid = "";
        return null;
      }
    }
  }

  checkAndNavigationCallingPage() async {
    var currentCall = await getCurrentCall();
    if (currentCall != null) {
      NavigationService.instance
          .pushNamedIfNotCurrent(AppRoute.callingPage, args: currentCall);
    }
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    print(state);
    if (state == AppLifecycleState.resumed) {
      //Check call when open app from background
      checkAndNavigationCallingPage();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  showCallkitIncoming(String uuid) async {
    final params = CallKitParams(
      id: uuid,
      nameCaller: 'Hien Nguyen',
      appName: 'Callkit',
      avatar: 'https://i.pravatar.cc/100',
      handle: '0123456789',
      type: 0,
      duration: 30000,
      textAccept: 'Accept',
      textDecline: 'Decline',
      textMissedCall: 'Missed call',
      textCallback: 'Call back',
      extra: <String, dynamic>{'userId': '1a2b3c4d'},
      headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
      android: const AndroidParams(
        isCustomNotification: true,
        isShowLogo: false,
        isShowCallback: true,
        isShowMissedCallNotification: true,
        ringtonePath: 'system_ringtone_default',
        backgroundColor: '#0955fa',
        backgroundUrl: 'assets/test.png',
        actionColor: '#4CAF50',
      ),
      ios: IOSParams(
          iconName: 'CallKitLogo',
          handleType: '',
          supportsVideo: true,
          maximumCallGroups: 2,
          maximumCallsPerCallGroup: 1,
          audioSessionMode: 'default',
          audioSessionActive: true,
          audioSessionPreferredSampleRate: 44100.0,
          audioSessionPreferredIOBufferDuration: 0.005,
      ),
    );
    await FlutterCallkitIncoming.showCallkitIncoming(params);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      onGenerateRoute: AppRoute.generateRoute,
      initialRoute: AppRoute.homePage,
      navigatorKey: NavigationService.instance.navigationKey,
      navigatorObservers: <NavigatorObserver>[
        NavigationService.instance.routeObserver
      ],
    );
  }

  Future<void> getDevicePushTokenVoIP() async {
    var devicePushTokenVoIP =
    await FlutterCallkitIncoming.getDevicePushTokenVoIP();
    print(devicePushTokenVoIP);
  }
}
/*
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();

    // Register the incoming call handler
    FlutterCallkitIncoming.onIncomingCall = (Call call) {
      // Assign a custom theme to the incoming call
      _callkitIncoming.setTheme(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        ringtoneSound: 'incoming_call_sound.mp3',
      );

      // Show the incoming call screen
      _callkitIncoming.showIncomingCall(
        callUUID: call.callUUID,
        handle: call.handle,
        handleType: HandleType.generic,
      );
    };
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CallKit Incoming Demo'),
      ),
      body: Center(
        child: Text('Incoming call handler registered.'),
      ),
    );
  }
}
*/



/*
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:url_launcher/url_launcher.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
            return ListTile(
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
                });
          },
        ));
  }
}
*/



/*
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _assignImageToContacts() async {
    final Iterable<Contact> contacts = await ContactsService.getContacts();
    for (final contact in contacts) {
      final bytes = await _image!.readAsBytes();
      final updatedContact = Contact(
        givenName: contact.givenName,
        middleName: contact.middleName,
        familyName: contact.familyName,
        prefix: contact.prefix,
        suffix: contact.suffix,
        company: contact.company,
        jobTitle: contact.jobTitle,
        emails: contact.emails,
        phones: contact.phones,
        postalAddresses: contact.postalAddresses,
        avatar: bytes,
      );
      await ContactsService.updateContact(updatedContact);
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Image Assigned'),
        content: const Text('The selected image has been assigned to all contacts.'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _callContact(Contact contact) async {
    final phoneNumber = contact.phones?.first.value;
    if (phoneNumber != null) {
      await FlutterPhoneDirectCaller.callNumber(phoneNumber);
    }
  }

  Widget _buildContactList() {
    return Expanded(
      child: FutureBuilder<Iterable<Contact>>(
        future: ContactsService.getContacts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final contacts = snapshot.data?.toList() ?? [];
            return ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                final image = contact.avatar != null
                    ? MemoryImage(contact.avatar!)
                    : const AssetImage('assets/images/person.png');
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: image as ImageProvider<Object>,
                  ),
                  title: Text(contact.displayName ?? ''),
                  onTap: () {
                    _callContact(contact);
                  },
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign Image to Contacts'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildContactList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Pick Image'),
              ),
              ElevatedButton(
                onPressed: _assignImageToContacts,
                child: const Text('Assign Image to All Contacts'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}*/
