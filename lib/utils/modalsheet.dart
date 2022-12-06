import 'package:flutter/material.dart';
import 'package:rest_api/models/usermodel.dart';

class ModalSheet extends StatefulWidget {
  final List<UserModel>? userModel;
  ModalSheet({Key? key, required this.userModel}) : super(key: key);

  @override
  State<ModalSheet> createState() => _ModalSheetState();
}

class _ModalSheetState extends State<ModalSheet> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: ((context) {
            return GridView.builder(
              itemCount: widget.userModel!.length,
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
                          onTap: () {},
                          child: Text(
                            widget.userModel![index].username,
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
            );
          }),
        );
      },
      child: const Icon(Icons.face),
    );
  }
}
