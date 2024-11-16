import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_it415_firebase/models/employee.dart';
import 'package:flutter_demo_it415_firebase/views/alldata.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  final User user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    Widget buildUserInfo(Employee employee) => Column(children: [
          const Text('from firestore'),
          const SizedBox(height: 15),
          Text(employee.id, style: txtstyle),
          const SizedBox(height: 15),
          Text(employee.name, style: txtstyle),
        ]);

    Widget getUserData(String uid) {
      final CollectionReference<Map<String, dynamic>> collection =
          FirebaseFirestore.instance.collection('Employee');

      return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: collection.doc(uid).snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasError) {
              return Text('Error = ${snapshot.error}');
            }
            if (snapshot.hasData) {
              final Map<String, dynamic>? data = snapshot.data!.data();
              if (data != null) {
                final Employee employee = Employee(
                  id: data['id'] as String,
                  name: data['name'] as String,
                  email: data['email'] as String,
                );
                return buildUserInfo(employee);
              }
            }
            return const Center(child: CircularProgressIndicator());
          });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Firebase Connection'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have successfully connected to Firebase:',
            ),
            const SizedBox(height: 15),
            const Text(
              'signed in as:',
            ),
            const SizedBox(height: 15),
            Text(
              user.email!,
            ),
            const SizedBox(height: 15),
            getUserData(user.uid),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              child: const Text(
                'SIGN OUT',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => const AllData(),
                  ),
                );
              },
              child: const Text(
                'All Data',
              ),
            )
          ],
        ),
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
