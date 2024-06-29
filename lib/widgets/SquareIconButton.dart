import 'package:flutter/material.dart';


class SquareIconButton extends StatelessWidget {
  final IconData icon;
  final void Function()? onPressed;

  const SquareIconButton({required Key key, required this.icon, this.onPressed}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3),
      child: RawMaterialButton(
        onPressed: onPressed,
        elevation: 2.0,
        fillColor: Colors.orangeAccent,
        child: Icon(icon, color: Colors.white),
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
      )
    );
  }


}