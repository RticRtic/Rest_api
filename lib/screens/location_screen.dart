import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rest_api/models/usermodel.dart';
import 'package:rest_api/providers/geolocater_provider.dart';
import 'package:rest_api/utils/modalsheet.dart';
import "dart:io";
import "package:webview_flutter/webview_flutter.dart";

class LocationScreen extends StatefulWidget {
  final String plusCode;
  final List<UserModel>? userModel;
  LocationScreen({Key? key, required this.plusCode, required this.userModel})
      : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late WebViewController controller;
  final geoProvider = GeolocaterProvider();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
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
            title: Text(
              "Ur Location is ${widget.plusCode}",
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 162, 163, 169),
                      Color.fromARGB(255, 141, 138, 143)
                    ]),
              ),
            ),
          ),
          body: FutureBuilder(
              future: geoProvider.getCurrentPosition(),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  return WebView(
                    initialUrl: 'https://plus.codes/map',
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (controller) {
                      this.controller = controller;
                    },
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Please wait loading plusCode ...",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(padding: EdgeInsets.only(top: 10.0)),
                        CircularProgressIndicator.adaptive(
                          backgroundColor: Colors.white,
                        )
                      ],
                    ),
                  );
                }
              })),
          floatingActionButton: ModalSheet(
            userModel: widget.userModel,
          )),
    );
  }
}
