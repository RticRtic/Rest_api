import 'package:flutter/material.dart';
import 'package:rest_api/screens/location_screen.dart';
import 'package:rest_api/widgets/profile_columns_utilites.dart';
import 'package:rest_api/widgets/profile_title.dart';
import '../models/usermodel.dart';

class ProfilePage extends StatefulWidget {
  List<UserModel>? userModel;
  int index;
  ProfilePage({super.key, required this.userModel, required this.index});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
          title: Text(widget.userModel![widget.index].username),
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
                ]),
          ),
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.010)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.22)),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.45,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100.0)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: ((context) => LocationScreen(
                                      userModel: widget.userModel,
                                      index: widget.index,
                                    ))));
                          },
                          child: const Icon(
                            Icons.person,
                            size: 150,
                            color: Colors.blueGrey,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.57,
                width: MediaQuery.of(context).size.width,
                child: Card(
                  child: Column(
                    children: [
                      ProfileTitle(title: "Profile"),
                      ProfileColumn(
                        icon: (Icons.person_outline),
                        string: widget.userModel![widget.index].name,
                      ),
                      ProfileColumn(
                          icon: (Icons.face),
                          string: widget.userModel![widget.index].username),
                      ProfileColumn(
                          icon: (Icons.phone_android_outlined),
                          string: widget.userModel![widget.index].phone),
                      ProfileColumn(
                          icon: (Icons.email_outlined),
                          string: widget.userModel![widget.index].email),
                      ProfileTitle(title: "Location"),
                      ProfileColumn(
                          icon: (Icons.home),
                          string: widget.userModel![widget.index].address.city),
                      ProfileColumn(
                          icon: (Icons.pin_drop),
                          string:
                              widget.userModel![widget.index].address.street),
                      ProfileColumn(
                          icon: (Icons.pin),
                          string:
                              widget.userModel![widget.index].address.zipcode),
                      ProfileTitle(title: "Company"),
                      ProfileColumn(
                          icon: (Icons.work_outline),
                          string: widget.userModel![widget.index].company.name),
                      ProfileColumn(
                          icon: (Icons.commit_sharp),
                          string: widget.userModel![widget.index].company.bs),
                      ProfileColumn(
                          icon: (Icons.comment_bank_outlined),
                          string: widget
                              .userModel![widget.index].company.catchPhrase),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
