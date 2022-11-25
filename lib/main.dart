import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rest_api/api/api_service.dart';
import 'package:rest_api/models/usermodel.dart';
import 'package:rest_api/screens/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<UserModel>? userModel = [];
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    userModel = await ApiService().getUsers();
    Future.delayed(const Duration(seconds: 1)).then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Employees"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(217, 142, 210, 0.5),
                Color.fromRGBO(239, 236, 222, 0.7)
              ],
            ),
          ),
        ),
      ),
      body: userModel == null || userModel!.isEmpty
          ? const SingleChildScrollView(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(217, 142, 210, 0.5),
                      Color.fromRGBO(239, 236, 222, 0.7)
                    ]),
              ),
              child: GridView.builder(
                itemCount: userModel!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2 / 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20),
                padding: const EdgeInsets.all(20.0),
                itemBuilder: ((context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromRGBO(217, 221, 240, 0.5),
                          Color.fromRGBO(239, 236, 235, 0.7)
                        ],
                      ),
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    child: GridTile(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ProfilePage(
                                      userModel: userModel, index: index)));
                            },
                            child: Text(
                              userModel![index].username,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Times",
                                  fontSize: 15.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
    );
  }
}
