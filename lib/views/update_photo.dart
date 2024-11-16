import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_demo_it415_firebase/models/employee.dart';

// ignore: unused_import
import 'dart:io' if (dart.library.html) 'dart:html' as html;
import 'dart:math';

import 'package:flutter_demo_it415_firebase/models/photo.dart';

class UpdatePhoto extends StatefulWidget {
  const UpdatePhoto({super.key, required this.employee});
  final Employee employee;

  @override
  State<UpdatePhoto> createState() => _UpdatePhotoState();
}

class _UpdatePhotoState extends State<UpdatePhoto> {
  late final Employee employee;

  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  String urlFile = '';

  String generateRandomString(int len) {
    final Random r = Random();
    const String chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789';
    return List<String>.generate(
        len, (int index) => chars[r.nextInt(chars.length)]).join();
  }

  Widget imgNotExist() => Image.asset(
        'assets/images/no-image.png',
        fit: BoxFit.cover,
      );

  void showLoaderDialog(BuildContext context) {
    final AlertDialog alert = AlertDialog(
      content: Row(
        children: <Widget>[
          const CircularProgressIndicator(),
          Container(
            margin: const EdgeInsets.only(left: 7),
            child: const Text('Uploading...'),
          ),
        ],
      ),
    );
    showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> selectFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result == null) {
      return;
    }

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future<void> uploadFile(BuildContext context, String id) async {
    showLoaderDialog(context);
    final String path = 'images/${generateRandomString(5)}-${pickedFile!.name}';
    final Reference ref = FirebaseStorage.instance.ref().child(path);
    if (kIsWeb) {
      setState(() {
        uploadTask = ref.putData(pickedFile!.bytes!);
      });
    } else {
      final File file = File(pickedFile!.path!);
      setState(() {
        uploadTask = ref.putFile(file);
      });
    }
    final TaskSnapshot snapshot = await uploadTask!.whenComplete(() {});
    final String urlDownload = await snapshot.ref.getDownloadURL();
    print('Download Link: $urlDownload');
    if (context.mounted) {
      updateDatabase(urlDownload, context, id);
    }
  }

  void showAlertDialogUpload(BuildContext context, String id) {
    final Widget cancelButton = TextButton(
      child: const Text('Cancel'),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    final Widget continueButton = TextButton(
      child: const Text('Continue'),
      onPressed: () {
        Navigator.of(context).pop();
        uploadFile(context, id);
      },
    );
    final AlertDialog alert = AlertDialog(
      title: const Text('Question'),
      content: const Text('Are you sure you want to upload this image?'),
      actions: <Widget>[
        cancelButton,
        continueButton,
      ],
    );
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showAlert(BuildContext context, String title, String msg) {
    final Widget continueButton = TextButton(
      onPressed: () {
        Navigator.of(context).pop();
        if (title == 'Success') {
          if (urlFile == '') {
            urlFile = '-';
            Navigator.of(context).pop(Photo(image: urlFile));
          }
        }
      },
      child: const Text('OK'),
    );
    final AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(msg),
      actions: <Widget>[continueButton],
    );
    showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
        stream: uploadTask?.snapshotEvents,
        builder: (BuildContext context, AsyncSnapshot<TaskSnapshot> snapshot) {
          if (snapshot.hasData) {
            final TaskSnapshot data = snapshot.data!;
            final double progress = data.bytesTransferred / data.totalBytes;
            return progressBar(progress);
          } else {
            return const SizedBox(height: 50);
          }
        },
      );

  Widget progressBar(double progress) => SizedBox(
        height: 50,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey,
              color: Colors.green,
            ),
            Center(
              child: Text(
                '${(100 * progress).roundToDouble()}%',
                style: const TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      );

  Future<void> updateDatabase(
      String urlDownload, BuildContext context, String id) async {
    final DocumentReference<Map<String, dynamic>> docUser =
        FirebaseFirestore.instance.collection('Employee').doc(id);

    await docUser.update(<String, dynamic>{
      'image': urlDownload,
    }).then((void value) {
      if (context.mounted) {
        showAlert(context, 'Success', 'Image uploaded successfully');
      }
    });

    setState(() {
      pickedFile = null;
    });
  }

  @override
  void initState() {
    super.initState();
    employee = widget.employee;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget imgExists() {
      if (kIsWeb) {
        return pickedFile?.bytes != null
            ? Image.memory(
                pickedFile!.bytes!,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              )
            : imgNotExist();
      } else {
        return pickedFile?.path != null
            ? Image.file(
                File(pickedFile!.path!),
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              )
            : imgNotExist();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Photo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 2,
              ),
            ),
            child: Center(
              child: pickedFile != null ? imgExists() : imgNotExist(),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              selectFile();
            },
            icon: const Icon(Icons.add_a_photo),
            label: const Text('Select Image'),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              if (pickedFile != null) {
                showAlertDialogUpload(context, employee.id);
              } else {
                showAlert(context, 'Error', 'Please select a photo');
              }
            },
            icon: const Icon(Icons.upload),
            label: const Text('Upload Image'),
          ),
          const SizedBox(height: 10),
          buildProgress(),
        ],
      ),
    );
  }

  TextStyle errortxtstyle = const TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.red,
    letterSpacing: 1,
    fontSize: 18,
  );
  TextStyle txtstyle = const TextStyle(
    fontWeight: FontWeight.bold,
    letterSpacing: 2,
    fontSize: 38,
  );
}
