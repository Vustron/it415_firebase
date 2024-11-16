import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_it415_firebase/models/employee.dart';
import 'package:flutter_demo_it415_firebase/views/login.dart';
import 'package:flutter_demo_it415_firebase/views/update_photo.dart';

import 'add_data.dart';
import 'update_data.dart';

class AllData extends StatefulWidget {
  const AllData({super.key});

  @override
  State<AllData> createState() => _AllDataState();
}

class _AllDataState extends State<AllData> {
  @override
  Widget build(BuildContext context) {
    Stream<List<Employee>> readUsers() {
      return FirebaseFirestore.instance.collection('Employee').snapshots().map(
        (QuerySnapshot<Map<String, dynamic>> snapshot) {
          print('Snapshot received with ${snapshot.docs.length} documents');
          return snapshot.docs.map(
            (QueryDocumentSnapshot<Map<String, dynamic>> doc) {
              print('Document data: ${doc.data()}');
              return Employee.fromJson(doc.data());
            },
          ).toList();
        },
      );
    }

    Future<dynamic> deleteUser(String id) async {
      final DocumentReference<Map<String, dynamic>> docUser =
          FirebaseFirestore.instance.collection('Employee').doc(id);
      docUser.delete();
    }

    Widget buildList(Employee employee) => Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(employee.image),
              radius: 25,
            ),
            title: Text(employee.name),
            subtitle: Text(employee.email),
            dense: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) =>
                      UpdatePhoto(employee: employee),
                ),
              );
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) =>
                            UpdateData(employee: employee),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outlined),
                  onPressed: () {
                    deleteUser(employee.id);
                  },
                ),
              ],
            ),
          ),
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee List'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => const Login(),
                ),
              );
            },
            icon: const Icon(Icons.logout),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => const AddData(),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Employee>>(
        stream: readUsers(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Employee>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong! ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final List<Employee> employees = snapshot.data!;
            if (employees.isEmpty) {
              return const Center(child: Text('No data found'));
            }
            return ListView.separated(
              itemCount: employees.length,
              itemBuilder: (BuildContext context, int index) {
                return buildList(employees[index]);
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
