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
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();
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
                  Color.fromRGBO(217, 142, 210, 0.5),
                  Color.fromRGBO(239, 236, 222, 0.7)
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.notification_add_outlined),
      ),
    );
  }
}
