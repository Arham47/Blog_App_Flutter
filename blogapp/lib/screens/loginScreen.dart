import 'package:blogapp/components/round_button.dart';
import 'package:blogapp/screens/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'ForgotScreen.dart';

class LoginScreeb extends StatefulWidget {
  const LoginScreeb({Key? key}) : super(key: key);

  @override
  _LoginScreebState createState() => _LoginScreebState();
}

class _LoginScreebState extends State<LoginScreeb> {
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
            title:Text("login to your account  ")
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Login" ,style: TextStyle(fontWeight: FontWeight.bold,fontSize:35 )),
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
                          Padding(
                            padding: const EdgeInsets.only(top: 10,bottom: 30),
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context,MaterialPageRoute(builder: (context)=>ForgotScreen()));
                              },
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text("forgot password")),
                            ),
                          ),

                          RoundButton(title: 'Register', onpress: ()async{
                            if(_formkey.currentState!.validate()){
                              setState(() {
                                showSpinner=true;
                              });
                              try{
                                final user=await _auth.signInWithEmailAndPassword(email: email.toString().trim(), password: password.toString().trim());
                                if(user!= null){
                                  print("success");
                                  toastMessage('user successfully loggedin');
                                  setState(() {
                                    showSpinner=false;
                                  });
                                  Navigator.push(context,MaterialPageRoute(builder: (context)=>HomeScreen()));
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
        textColor: Colors.black,
        fontSize: 16.0
    );
  }
}
