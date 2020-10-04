import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  String label;
  String hint;
  int maxlen;
  bool password;
  TextEditingController controller;
  FormFieldValidator<String> validator;
  TextInputType keyboardType;
  TextInputAction textInputAction;
  FocusNode focusNode;
  FocusNode nextFocus;

  AppText(
    this.label,
    this.hint,
    {
      this.maxlen = 255,
      this.password = false,
      this.controller,
      this.validator,
      this.keyboardType,
      this.textInputAction,
      this.focusNode,
      this.nextFocus,
  }
  );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
//      textCapitalization:TextCapitalization.characters,
      textCapitalization:TextCapitalization.sentences,
      maxLength: maxlen,
      controller: controller,
      obscureText: password,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      focusNode: focusNode,
      onFieldSubmitted: (String text) {
        if (nextFocus != null) {
          FocusScope.of(context).requestFocus(nextFocus);
        }
      },
      style: TextStyle(
        fontSize: 16,
//        color: Colors.lightBlue[800],
        color: Colors.black,
      ),
      decoration: InputDecoration(
        fillColor: Color(0xff32633C),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Color(0xff32633C)),
        ),
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 16,
//          color: Colors.grey,
          color: Colors.black,
//          color: Color(0xff32633C),
        ),
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 14,
          color: Color(0xff32633C),
        ),
      ),
    );
  }
}
