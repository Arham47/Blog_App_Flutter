import 'package:blogapp/components/round_button.dart';
import 'package:blogapp/screens/HomeScreen.dart';
import 'package:blogapp/screens/loginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({Key? key}) : super(key: key);

  @override
  _ForgotScreenState createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  FirebaseAuth _auth= FirebaseAuth.instance;
  bool showSpinner = false;

  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();

  final _formkey=GlobalKey<FormState>();
  String email='';


  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall:showSpinner,
      child: Scaffold
        (
        appBar: AppBar(
            backgroundColor: Colors.deepOrange,
            title:Text("Reset Your Password here ! ")
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Reset" ,style: TextStyle(fontWeight: FontWeight.bold,fontSize:35 )),
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
                          SizedBox(height: 10,),

                          RoundButton(title: 'Reset Password', onpress: ()async{
                            if(_formkey.currentState!.validate()){
                              setState(() {
                                showSpinner=true;
                              });
                              try{
                                _auth.sendPasswordResetEmail(email: emailController.text.toString())
                                .then((value){
                                  toastMessage("Please check your email");

                                }).onError((error, stackTrace) {
                                  toastMessage(error.toString());
                                });

                                  setState(() {
                                    showSpinner=false;
                                  });
                                  Navigator.push(context,MaterialPageRoute(builder: (context)=>LoginScreeb()));

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
