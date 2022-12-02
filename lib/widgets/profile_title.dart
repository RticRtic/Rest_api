import 'package:flutter/material.dart';

class ProfileTitle extends StatefulWidget {
  String title;
  ProfileTitle({required this.title});

  @override
  State<ProfileTitle> createState() => _ProfileTitleState();
}

class _ProfileTitleState extends State<ProfileTitle> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.03)),
        Row(
          children: [
            Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.07)),
            Text(
              widget.title,
              style:
                  const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const Divider(
          color: Colors.grey,
          thickness: 1,
          endIndent: 30,
          indent: 30,
        ),
      ],
    );
  }
}
