import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rest_api/api/api_service.dart';
import 'package:rest_api/models/usermodel.dart';

class LocationScreen extends StatefulWidget {
  List<UserModel>? userModel;
  int index;
  LocationScreen({super.key, required this.userModel, required this.index});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final inputText = TextEditingController();
  final apiService = ApiService();
  Future<UserModel>? futureUser;

  void addToFirebase(String name, int age) {
    final person = <String, dynamic>{
      "name": name,
      "age": age,
    };
    FirebaseFirestore.instance.collection("Test").add(person);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "Times",
        canvasColor: Colors.transparent,
        cardColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.grey, size: 20.0),
        appBarTheme: const AppBarTheme(backgroundColor: Colors.blueGrey),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.arrow_left,
              size: 50.0,
            ),
          ),
          centerTitle: true,
          title: const Text("Location"),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(217, 221, 240, 0.5),
                    Color.fromRGBO(239, 236, 235, 0.7)
                  ]),
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(217, 221, 240, 0.5),
                Color.fromRGBO(239, 236, 235, 0.7)
              ],
            ),
          ),
          child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: inputText,
                    decoration: const InputDecoration(hintText: "Name"),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          futureUser = apiService.createUser(inputText.text);
                        });
                      },
                      child: const Text("POST")),
                  builder(),
                  ElevatedButton(
                      onPressed: () {
                        addToFirebase("janne", 32);
                      },
                      child: const Icon(Icons.fire_extinguisher))
                ],
              )),
        ),
      ),
    );
  }

  FutureBuilder<UserModel> builder() {
    return FutureBuilder(
      future: futureUser,
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!.name);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return const CircularProgressIndicator();
      }),
    );
  }
}
