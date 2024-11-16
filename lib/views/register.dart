import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_demo_it415_firebase/models/employee.dart';
import 'package:flutter_demo_it415_firebase/views/authenticator.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  late String errormessage;
  late bool isError;

  @override
  void initState() {
    errormessage = 'This is an error';
    isError = false;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'REGISTER',
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
              TextField(
                obscureText: true,
                controller: passwordcontroller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter password',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  registerUser();
                },
                child: const Text('REGISTER'),
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

  Future<dynamic> createUser() async {
    final User user = FirebaseAuth.instance.currentUser!;
    final String userid = user.uid;
    final DocumentReference<Map<String, dynamic>> docUser =
        FirebaseFirestore.instance.collection('Employee').doc(userid);

    final Employee employee = Employee(
      id: userid,
      name: namecontroller.text.trim(),
      email: emailcontroller.text.trim(),
    );

    final Map<String, dynamic> json = employee.toJson();
    await docUser.set(json);
    goToAuthenticator();
  }

  Future<dynamic> registerUser() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailcontroller.text.trim(),
        password: passwordcontroller.text.trim(),
      );
      createUser();
      setState(() {
        isError = false;
        errormessage = "";
      });
    } on FirebaseAuthException catch (e) {
      print(e);
      setState(() {
        isError = true;
        errormessage = e.message.toString();
      });
    }
  }

  void goToAuthenticator() {
    Navigator.of(context).push(
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => const Authenticator(),
      ),
    );
  }
}
