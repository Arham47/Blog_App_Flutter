import 'package:blogapp/components/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class signIn extends StatefulWidget {

  const signIn({ Key? key }) : super(key: key);

  @override
  _signInState createState() => _signInState();
}

class _signInState extends State<signIn> {
  FirebaseAuth _auth= FirebaseAuth.instance;
  bool showSpinner = false;

  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();

  final _formkey=GlobalKey<FormState>();
  String password='',email='';


   @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall:showSpinner,
      child: Scaffold
      (
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          title:Text("Create a account  ")
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
Text("Register" ,style: TextStyle(fontWeight: FontWeight.bold,fontSize:35 )),
Padding(padding: const EdgeInsets.symmetric(vertical: 30),

  child: Form(

        key:_formkey,
        child: Column(

  children: [


      TextFormField(
          controller:emailController,
          keyboardType:TextInputType.emailAddress,
          decoration: InputDecoration(

            hintText: 'email',
            labelText: 'email',
            prefixIcon: Icon(Icons.email),
              border:OutlineInputBorder()

          ),
          onChanged: (String value){
            email=value;
          },
          validator: (value){
            return value!.isEmpty ? 'enter email': null;
          },

      ),
      Padding(
            padding: const EdgeInsets.symmetric(vertical:10),
      child:
      TextFormField(
          controller:passwordController,
          keyboardType:TextInputType.emailAddress,
          obscureText:true,
          decoration: InputDecoration(

              hintText: 'password',
              labelText: 'password',
              prefixIcon: Icon(Icons.lock),
               border:OutlineInputBorder()
          ),
          onChanged: (String value){
            password=value;
          },
          validator: (value){
            return value!.isEmpty ? 'enter password': null;
          },

      )),
      RoundButton(title: 'Register', onpress: ()async{
        if(_formkey.currentState!.validate()){
          setState(() {
            showSpinner=true;
          });
          try{
             final user=await _auth.createUserWithEmailAndPassword(email: email.toString().trim(), password: password.toString().trim());
             if(user!= null){
               print("success");
               toastMessage('user registered successfully');
               setState(() {
                 showSpinner=false;
               });
             }
            }catch(e){
              print(e.toString());
              toastMessage(e.toString());
              setState(() {
                showSpinner=false;
              });
            }

        }

      })

  ],
)
      )
       )
            ],
          ),
        ),
        
      ),
    );
  }
  void toastMessage(String message){
    Fluttertoast.showToast(
        msg: message.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}