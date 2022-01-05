import 'dart:async';

import 'package:blogapp/screens/HomeScreen.dart';
import 'package:blogapp/screens/option_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseAuth auth=FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final user =auth.currentUser;
    if(user!=null) {

      Timer(Duration(seconds: 3),

          ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen( ))));
    }else{

      Timer(Duration(seconds: 3),

              ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>OptionScreen())));

      
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
              height: MediaQuery.of(context).size.height*.3,
              width: MediaQuery.of(context).size.width*.6,
              image: AssetImage('images/image1.png')
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical:30),
            child:Align(
              alignment: Alignment.center,
             child: Text('Blog',style: TextStyle(fontSize: 35,fontStyle: FontStyle.italic,fontWeight: FontWeight.w300 )),
    )
          )
        

        ],
      ),
    );
  }
}
