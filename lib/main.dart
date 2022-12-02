import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:rest_api/api/api_service.dart';
import 'package:rest_api/models/usermodel.dart';
import 'package:rest_api/providers/push_provider.dart';
import 'package:rest_api/screens/profile_screen.dart';
import 'package:rest_api/widgets/drawer.dart';

@pragma("vm:entry-point")
Future<void> messageHandler(RemoteMessage message) async {
  print("background message ${message.notification!.body}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(messageHandler);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;
  final pushProvider = PushProvider();
  late List<UserModel>? userModel = [];

  @override
  void initState() {
    super.initState();
    getApi();
    pushProvider.requestPermission();
    pushProvider.loadFcm();
    pushProvider.listenFCM();
    FirebaseMessaging.instance.subscribeToTopic("Janne");
  }

  void getApi() async {
    userModel = await ApiService().getEmployees();
    Future.delayed(const Duration(seconds: 1)).then((value) {
      setState(() {
        for (var id in userModel!) {
          pushProvider.getDeviceToken(id.id.toString());
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 162, 163, 169),
                  Color.fromARGB(255, 141, 138, 143)
                ]),
          ),
          child: Column(
            children: [
              DrawerItem(title: title, message: body),
              ElevatedButton.icon(
                onPressed: () async {
                  pushProvider.sendPushMessage(title.text, body.text);
                  title.clear();
                  body.clear();
                },
                icon: const Icon(
                  Icons.notification_add_outlined,
                ),
                label: const Text(
                  "Send",
                  style: TextStyle(color: Colors.black, fontFamily: "Times"),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: ((context) => AlertDialog(
                        title: const Text(
                          "QuickMessage",
                          textAlign: TextAlign.center,
                        ),
                        contentPadding: const EdgeInsets.all(10.0),
                        content: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color.fromARGB(126, 66, 77, 133),
                                Color.fromARGB(177, 33, 27, 43)
                              ],
                            ),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          width: MediaQuery.of(context).size.width * .7,
                          child: GridView.builder(
                            itemCount: userModel!.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 2 / 2,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 13),
                            padding: const EdgeInsets.all(3.0),
                            itemBuilder: ((context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color.fromARGB(255, 162, 163, 169),
                                      Color.fromARGB(255, 141, 138, 143)
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
                                          showDialog(
                                            context: context,
                                            builder: ((context) => AlertDialog(
                                                  content: SizedBox(
                                                    height: 150,
                                                    width: 200,
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          "Send Message to: ${userModel![index].username}",
                                                          style:
                                                              const TextStyle(
                                                                  fontFamily:
                                                                      "Times",
                                                                  fontSize:
                                                                      20.0),
                                                        ),
                                                        const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 10.0)),
                                                        TextFormField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .text,
                                                          controller: body,
                                                          decoration:
                                                              InputDecoration(
                                                            filled: true,
                                                            labelText:
                                                                "Message",
                                                            suffixIcon:
                                                                IconButton(
                                                              onPressed: () {
                                                                pushProvider
                                                                    .sendPushMessage(
                                                                        "The Boss",
                                                                        body.text);
                                                                body.clear();
                                                              },
                                                              icon: const Icon(
                                                                Icons.send,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                          );
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
                        ))));
              },
              icon: const Icon(
                Icons.notification_add_outlined,
                color: Colors.black,
              ))
        ],
        centerTitle: true,
        title: const Text(
          "Employees",
          style: TextStyle(
              color: Colors.black,
              fontFamily: "Times",
              fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 162, 163, 169),
                Color.fromARGB(255, 141, 138, 143)
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
                      Color.fromARGB(126, 66, 77, 133),
                      Color.fromARGB(177, 33, 27, 43)
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
