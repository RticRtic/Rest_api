import 'package:flutter/material.dart';
import 'package:rest_api/main.dart';

class DrawerItem extends StatefulWidget {
  TextEditingController title = TextEditingController();
  TextEditingController message = TextEditingController();

  DrawerItem({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  State<DrawerItem> createState() => _DrawerItemState();
}

class _DrawerItemState extends State<DrawerItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
          TextFormField(
            keyboardType: TextInputType.text,
            controller: widget.title,
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.grey,
              labelText: "Title",
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 10.0)),
          TextFormField(
            keyboardType: TextInputType.text,
            controller: widget.message,
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.grey,
              labelText: "Message",
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 10.0)),
        ],
      ),
    );
  }
}
