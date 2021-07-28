import 'package:flutter/material.dart';

class CustomeFormField extends StatelessWidget {
  String hintText;
  String validator;
  Widget prefix;
  CustomeFormField({required this.hintText,
    required this.prefix,required this.validator});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.green),
          color: Colors.grey.withOpacity(.3),
          borderRadius: BorderRadius.circular(15)),
      child: TextFormField(
        validator: (val)=>
        val!.isNotEmpty ? null:validator,
        decoration: InputDecoration(
            prefixIcon: prefix,
            hintText: hintText,
            border: OutlineInputBorder(borderSide: BorderSide.none)),
      ),
    );
  }
}
