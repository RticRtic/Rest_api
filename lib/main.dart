import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rest_api/api/api_service.dart';
import 'package:rest_api/models/usermodel.dart';
import 'package:rest_api/screens/profile_screen.dart';
import "package:http/http.dart" as http;

@pragma("vm:entry-point")
Future<void> messageHandler(RemoteMessage message) async {
  print("background message ${message.notification!.body}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(messageHandler);
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
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  String userToken = "";
  late List<UserModel>? userModel = [];
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late AndroidNotificationChannel channel;

  @override
  void initState() {
    super.initState();
    getApi();
    requestPermission();
    loadFcm();
    listenFCM();
    getToken();
    FirebaseMessaging.instance.subscribeToTopic("Janne");

    // FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    //   showDialog(
    //       context: context,
    //       builder: ((context) {
    //         return AlertDialog(
    //           title: const Text(
    //             "Notification",
    //             style: TextStyle(fontFamily: "Times"),
    //           ),
    //           content: Text(event.notification!.body!),
    //           actions: [
    //             TextButton(
    //               onPressed: () {
    //                 Navigator.of(context).pop();
    //               },
    //               child: const Text(
    //                 "OK!",
    //                 style: TextStyle(fontFamily: "Times", color: Colors.white),
    //               ),
    //             ),
    //           ],
    //         );
    //       }));
    // });
    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //   print("Message clicked");
    // });
  }

  void saveUserToken(String token) async {
    db.collection("userToken").doc(auth.currentUser?.uid).set({"token": token});
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        userToken = token as String;
      });
      saveUserToken(userToken);
    });
  }

  void sendPushMessage() async {
    try {
      await http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: <String, String>{
          "content-type": "application/json",
          "Authorization":
              "key=AAAAaaSbt0w:APA91bFKVM5Evit-eHewVTwka_0AoSD2vZctVoyXxCeNZp_K4zW9jXElArVaaOIJtEmMPIAL8mRgqsY5HCe_EPyCqgCCtGgLmNlk4bq1j2narDU_n-RFsMfw-7MIC11QusnEwPkvWUl4"
        },
        body: jsonEncode(
          <String, dynamic>{
            "notification": <String, dynamic>{
              "body": "This Is A Notification!",
              "title": "Hello!"
            },
            "priority": "high",
            "data": <String, dynamic>{
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
              "id": "1",
              "status": "done"
            },
            "to": userToken,
          },
        ),
      );
    } catch (e) {
      print(" Error to send PushNotification $e");
    }
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("User granted provisional permission");
    } else {
      print("User declined or has not accepted permission");
    }
  }

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(channel.id, channel.name,
                    icon: "launch_background")));
      }
    });
  }

  void loadFcm() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
          "high_importance_channel", "High Importance Notifications",
          importance: Importance.high, enableVibration: true);

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
              alert: true, badge: true, sound: true);
    }
  }

  void getApi() async {
    userModel = await ApiService().getEmployees();
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
                          ElevatedButton(
                            onPressed: () {
                              sendPushMessage();
                            },
                            child: const Text("Send"),
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
