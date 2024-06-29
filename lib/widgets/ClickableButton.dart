import 'package:flutter/material.dart';

class ClickableButton extends StatefulWidget {
  final VoidCallback onClick;
  final String buttonText;

  const ClickableButton({
    required this.onClick,
    required this.buttonText,
  });

  @override
  _ClickableButtonState createState() => _ClickableButtonState();
}

class _ClickableButtonState extends State<ClickableButton> {
  bool isButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isButtonPressed = !isButtonPressed;
        });

        widget.onClick();
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: isButtonPressed ? Colors.orangeAccent : Colors.grey,
        ),
        child: Text(
          widget.buttonText,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}