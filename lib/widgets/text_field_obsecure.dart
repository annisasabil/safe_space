import 'package:safe_space/provider/obsecure_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TextFieldObsecure extends StatelessWidget{
  final TextEditingController controller;
  final String? hintText;
   final InputDecoration? decoration;

  const TextFieldObsecure({
    super.key,
    required this.controller,
    this.hintText,
    this.decoration,
  });

  @override
  Widget build(BuildContext context){
    return  ChangeNotifierProvider(
      create: (context) => ObsecureProvider(),
      child: Consumer<ObsecureProvider>(
        builder: (context, value, child){
          final obsecureText = value.obsecureText;

          return TextField(
            controller: controller,
            obscureText: obsecureText,
            decoration: InputDecoration(
              hintText: "Masukkan kata sandi",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                icon: 
                  Icon(obsecureText ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                value.obsecureText = !obsecureText;
              },
              ),
            ),
          );
        },
      ),
    );
  }
}