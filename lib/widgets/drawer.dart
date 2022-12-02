import 'package:flutter/material.dart';
import 'package:rest_api/providers/push_provider.dart';

class DrawerItem extends StatefulWidget {
  TextEditingController title = TextEditingController();
  TextEditingController message = TextEditingController();

  DrawerItem({
    required this.title,
    required this.message,
  });

  @override
  State<DrawerItem> createState() => _DrawerItemState();
}

class _DrawerItemState extends State<DrawerItem> {
  final pushProvider = PushProvider();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(padding: EdgeInsets.only(top: 250)),
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
    );
  }
}
