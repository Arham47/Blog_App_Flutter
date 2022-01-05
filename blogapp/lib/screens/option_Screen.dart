import 'dart:ui';

import 'package:blogapp/components/round_button.dart';
import 'package:blogapp/screens/signin.dart';
import 'package:flutter/material.dart';

import 'loginScreen.dart';

class OptionScreen extends StatefulWidget {
  const OptionScreen({ Key? key }) : super(key: key);

  @override
  _OptionScreenState createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
     body:SafeArea(
         child: Padding(
           padding: const EdgeInsets.symmetric(horizontal: 20),

         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.center,
         children: [
           Image(image:AssetImage('images/logo.jfif')),
           SizedBox(height:30),
           RoundButton(title: 'Login', onpress: (){
             Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreeb()));
           }),
         SizedBox(height:30),
         RoundButton(title: 'register', onpress: (){
           Navigator.push(context, MaterialPageRoute(builder: (context)=>signIn()));

         })
       ],
     )
     )
    )
     );
  }
}