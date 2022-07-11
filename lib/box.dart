import 'package:flutter/material.dart';

class Boxes extends StatelessWidget {
  final Widget child;

  final double height,width;

  const Boxes({super.key, required this.height, required this.width, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Color.fromRGBO(47, 55, 69, 15),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(15),
          bottomLeft: Radius.circular(15)
        ),
      ),
      //padding: const EdgeInsets.all(8.0),
      child: Center(child: child),);
  }
}
