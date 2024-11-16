import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_it415_firebase/models/employee.dart';

class UpdateData extends StatefulWidget {
  const UpdateData({super.key, required this.employee});
  final Employee employee;

  @override
  State<UpdateData> createState() => _UpdateDataState();
}

class _UpdateDataState extends State<UpdateData> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  late String errormessage;
  late bool isError;

  @override
  void initState() {
    errormessage = 'This is an error';
    isError = false;
    namecontroller.text = widget.employee.name;
    emailcontroller.text = widget.employee.email;
    super.initState();
  }

  @override
  void dispose() {
    namecontroller.dispose();
    emailcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> updateUser(String id) async {
      final DocumentReference<Map<String, dynamic>> docUser =
          FirebaseFirestore.instance.collection('Employee').doc(id);

      docUser.update(<Object, Object?>{
        'name': namecontroller.text,
        'email': emailcontroller.text,
      });
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Data'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'UPDATE DATA',
                style: txtstyle,
              ),
              const SizedBox(height: 15),
              TextField(
                controller: namecontroller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter name',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: emailcontroller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Email Address',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  updateUser(widget.employee.id);
                },
                child: const Text('UPDATE'),
              ),
              const SizedBox(height: 15),
              isError
                  ? Text(
                      errormessage,
                      style: errortxtstyle,
                    )
                  : Container(),
            ],
          ),
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
