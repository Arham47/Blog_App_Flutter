import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
 final String title;
 final VoidCallback onpress;
   RoundButton({ required this.title, required this.onpress }) ;

  @override 
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: MaterialButton(
        height: 50,
        minWidth: double.infinity,
        color: Colors.deepOrange,
        child: Text(title,style: TextStyle(color:Colors.white),),
        onPressed: onpress ,
        ),
      
    );
  }
}