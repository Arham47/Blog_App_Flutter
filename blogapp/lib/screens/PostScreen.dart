

import 'package:blogapp/components/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_database/firebase_database.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  bool showSpinner=false;
  final postRef =FirebaseDatabase.instance.reference().child('Post');
  firebase_storage.FirebaseStorage storage=firebase_storage.FirebaseStorage.instance;
  File? _image;
  final picker = ImagePicker();
  FirebaseAuth _auth=FirebaseAuth.instance;
  final _formkey=GlobalKey<FormState>();
  String title="",description="";
TextEditingController titleController = TextEditingController();
TextEditingController descriptonController = TextEditingController();
void dialog(context){
  showDialog(
    context: context,
    builder: (BuildContext context){
      return AlertDialog(
shape:RoundedRectangleBorder(
       borderRadius: BorderRadius.circular(10.0)
),
        content:Container(
          height: 120,
          child: Column(
            children: [
              
              InkWell(
                onTap: (){
                  getImageCamera();
                  Navigator.pop(context);
                },
                child: ListTile(
                  leading:Icon(Icons.camera),
                  title: Text("camera"),

                ),
              ),
              InkWell(
                onTap: (){
getImageGallery();
Navigator.pop(context);
                },
                child: ListTile(
                  leading:Icon(Icons.photo_library),
                  title: Text("gallery"),


                ),
              )

            ],
          ),
        )
      );
    }

  );
}

Future getImageGallery()async{
  final pickedFile=await picker.pickImage(source: ImageSource.gallery);
  setState(() {
    if(pickedFile!=null){
      _image =File(pickedFile.path);

    }else{
      print("no image selected");
    }

  });}

Future getImageCamera()async{
  final pickedFile=await picker.pickImage(source: ImageSource.camera);
  setState(() {
    if(pickedFile!=null){
      _image =File(pickedFile.path);
    }else{
      print("no image captured");
    }
  });

}

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Upload Blog") ,
          backgroundColor: Colors.deepOrange,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical:10,horizontal:20),
            child: Column(
              children:[
                InkWell(
                  onTap: (){
                    dialog(context);
                  },
                  child: Center(
                   child:Container(

                      height: MediaQuery.of(context).size.height*0.2,
                      width: MediaQuery.of(context).size.width*1,
                      child: _image!=null?ClipRect(
                        child: Image.file(
                          _image!.absolute,
                          height: 100,
                          width:100,
                          fit: BoxFit.fitHeight,



                        ),
                      ):Container(
                         decoration: BoxDecoration(
                           color: Colors.grey.shade200,
                           borderRadius: BorderRadius.circular(10),),
                        width: 100,
                        height: 100,
                        child: Icon(
                          Icons.camera_alt,
                          color:Colors.blue
                        ),
                      ),
                  )
                  ),
                ),
          SizedBox(height:30),
                Form(
                    key:_formkey,
                    child: Column(
                  children: [
                    TextFormField(
                      controller: titleController,
                      keyboardType:TextInputType.text,
                      minLines: 1,
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: "Title",
                        hintText: "title",

                        border:OutlineInputBorder(),
                        hintStyle: TextStyle(color:Colors.grey,fontWeight: FontWeight.normal),
                        labelStyle: TextStyle(color:Colors.grey,fontWeight: FontWeight.normal)
                      ),

                        onChanged: (String value){
                title=value;
                },
                  validator: (value){
                    return value!.isEmpty ? 'enter email': null;
                  },
                    ),
                    SizedBox(height:30),
                    TextFormField(
                      controller: descriptonController,
                      keyboardType:TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Description",
                          hintText: "description",
                          border:OutlineInputBorder(),
                          hintStyle: TextStyle(color:Colors.grey,fontWeight: FontWeight.normal),
                          labelStyle: TextStyle(color:Colors.grey,fontWeight: FontWeight.normal)
                      ),

                        onChanged: (String value){
                description=value;
                },
                  validator: (value){
                    return value!.isEmpty ? 'enter email': null;
                  },
                    ),
                    SizedBox(height:30),
                    RoundButton(title: 'Add Blog', onpress: ()async{
                      if(_formkey.currentState!.validate()){
                          setState(() {
                            showSpinner=true;
                          });
                              try{
int date=DateTime.now().microsecondsSinceEpoch;
firebase_storage.Reference ref=firebase_storage.FirebaseStorage.instance.ref('/blogAppflutter$date');
UploadTask uploadTask= ref.putFile(_image!.absolute);
await Future.value(uploadTask);
var newUrl=await ref.getDownloadURL();
final User? user= _auth.currentUser ;
postRef.child('Post List').child(date.toString()).set({
'pId':date.toString(),
'pImage':newUrl.toString(),
'pTime':date.toString(),
'pTitle':titleController.text.toString(),
'pDescription':descriptonController.text.toString(),
'uEmail':user!.email .toString(),
'uId':user.uid .toString(),

}).then((value){

  toastMessage('Post Published');
  setState(() {
    showSpinner=false;
  });
}).onError((error, stackTrace){
  toastMessage(error.toString());
  setState(() {
    showSpinner=false;
  });
});
                              }catch(e){
                                setState(() {
                                  showSpinner=false;
                                });
                            toastMessage(e.toString());

                              }


                      }

                    })


                  ],

                )
                )

              ]

              ),
          )

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
