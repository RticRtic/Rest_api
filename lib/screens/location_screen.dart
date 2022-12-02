import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rest_api/models/usermodel.dart';
import "package:open_location_code/open_location_code.dart" as olc;

class LocationScreen extends StatefulWidget {
  List<UserModel>? userModel;
  int index;
  LocationScreen({Key? key, required this.userModel, required this.index})
      : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  Future<UserModel>? futureUser;

  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location service disabled");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error("Permission permanetly denied");
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error("Permission denied");
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  String getPlusCode(Position fromPosition) {
    return olc.encode(fromPosition.latitude, fromPosition.longitude,
        codeLength: 12);
  }

  Position getPosition(String fromPlusCode) {
    olc.CodeArea ca = olc.decode(fromPlusCode);
    Position position = Position(
        longitude: ca.center.longitude.toDouble(),
        latitude: ca.center.latitude.toDouble(),
        timestamp: null,
        accuracy: 0.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0);
    return position;
  }

  void locateMe() async {
    Position position = await getCurrentPosition();
    print("${position.latitude}, ${position.longitude}");

    String plusCode = getPlusCode(position);
    print(plusCode);

    Position positionDecoded = getPosition(plusCode);
    print("${positionDecoded.latitude}, ${positionDecoded.longitude}");
  }

  @override
  void initState() {
    super.initState();
    locateMe();
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
          title: const Text(
            "Location",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(126, 66, 77, 133),
                Color.fromARGB(177, 33, 27, 43)
              ],
            ),
          ),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [Text("APA")]),
          ),
        ),
      ),
    );
  }
}
