import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class InputField extends StatelessWidget {
  final String labelText;
  final bool? multiline;
  final bool enabled;
  final bool isPassword;
  final bool isUsername;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmit;
  final void Function()? onTap;
  final int? maxLength;
  final TextAlign? textAlign;
  final TextEditingController? controller;
  final TextInputType? keyboardType;


  const InputField({
    required Key key,
    required this.labelText,
    required this.controller,
    this.onChanged,
    this.onSubmit,
    this.onTap,
    this.keyboardType,
    this.multiline,
    this.textAlign,
    this.maxLength,
    this.isPassword = false,
    this.isUsername = false,
    this.enabled = true,
  }) : super(key: key,);



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: TextField(
        enabled: enabled,
        maxLength: maxLength,
        obscureText: isPassword,
        textAlign: this.textAlign ?? TextAlign.left,
        maxLines: multiline != null && multiline == true ? null : 1,
        keyboardType: keyboardType,
        inputFormatters: keyboardType == TextInputType.number ? <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        ] : null,
        onChanged: onChanged,
        onSubmitted: onSubmit,
        onTap: onTap,
        controller: controller,
        cursorColor: Theme.of(context).primaryColor,
        style: TextStyle(
          height: 1.0,
          color: Theme.of(context).primaryColor,
        ),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: new BorderRadius.circular(2.0),
            borderSide: BorderSide(
              color: Colors.orangeAccent,
            ),
          ),
          fillColor: Theme.of(context).primaryColor,
          focusedBorder: OutlineInputBorder(
            borderRadius: new BorderRadius.circular(2.0),
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: new BorderRadius.circular(2.0),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
            ),
          ),
          labelText: labelText,
          labelStyle: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }


}