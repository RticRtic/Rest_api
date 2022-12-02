import 'package:flutter/material.dart';

class ProfileColumn extends StatefulWidget {
  String string;
  IconData icon;

  ProfileColumn({
    required this.icon,
    required this.string,
  });

  @override
  State<ProfileColumn> createState() => _ProfileColumnState();
}

class _ProfileColumnState extends State<ProfileColumn> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.01)),
        Row(
          children: [
            Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.06)),
            Icon(widget.icon),
            Text(
              widget.string,
              style: const TextStyle(fontSize: 15.0, color: Colors.blueGrey),
            ),
          ],
        ),
      ],
    );
  }
}
