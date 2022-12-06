import 'dart:math';

import 'package:geolocator/geolocator.dart';
import "package:open_location_code/open_location_code.dart" as olc;

class GeolocaterProvider {
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

  String plusCode = "";

  void locateMe() async {
    Position position = await getCurrentPosition();
    print("${position.latitude}, ${position.longitude}");

    plusCode = getPlusCode(position);
    print(plusCode);

    Position positionDecoded = getPosition(plusCode);
    print("${positionDecoded.latitude}, ${positionDecoded.longitude}");
  }

  void locateEmployee(String lat, String long) {
    var employeePlusCode =
        olc.encode(double.parse(lat), double.parse(long), codeLength: 12);
    print(employeePlusCode);
  }
}
