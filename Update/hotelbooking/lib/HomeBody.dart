import 'package:flutter/material.dart';
import 'package:hotelbooking/constants.dart';
class Homebody extends StatelessWidget {
  const Homebody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: kReadColor,
              borderRadius: BorderRadius.only(
                topLeft:Radius.circular(40),
                topRight: Radius.circular(40)

              )
            ),
          )
        ],
      ),

    );
  }
}
