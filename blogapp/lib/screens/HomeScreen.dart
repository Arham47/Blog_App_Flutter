import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'PostScreen.dart';
import 'loginScreen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController=TextEditingController();
  String Search=" ";


  final dbRef = FirebaseDatabase.instance.reference().child('Post');
   FirebaseAuth auth=FirebaseAuth.instance;
  @override

  Widget build(BuildContext context) {
    final User? user=auth.currentUser;


      return   WillPopScope(
        onWillPop: ()async{
          SystemNavigator.pop();
          return true;
        },

        child: Scaffold(

          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.deepOrange,
            title: const Text("new blog"),
            centerTitle: true,
            actions: [
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> PostScreen()));
                },
                child: const Icon(Icons.add),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () {
                  auth.signOut().then((value) =>
                  {
                    Navigator.pop(context),
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreeb())),

                  }
                  );

                },
                child: const Icon(Icons.logout),
              ),
              const SizedBox(width: 20)
            ],
          ),
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              TextFormField(
                controller:searchController,
                keyboardType:TextInputType.emailAddress,
                decoration: InputDecoration(

                    hintText: 'Search by blog title',

                    prefixIcon: Icon(Icons.search),
                    border:OutlineInputBorder()

                ),
                onChanged: (String value){
                  Search=value;
                },


              ),
              Container(
                height: MediaQuery.of(context).size.height*0.8 ,
                width: MediaQuery.of(context).size.width ,
                child: FirebaseAnimatedList(
                  query: dbRef.child("Post List"),
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int x) {
                    Map m = Map.from((snapshot.value ?? {}) as Map);
                    String title=m['pTitle'];
                    if(searchController.text.toString().isEmpty){
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                        child: Card(
                          elevation: 4.0,
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(m['pTitle']),
                                // subtitle: Text('subheading'),
                                trailing: const Icon(Icons.favorite_outline),
                              ),
                              SizedBox(
                                height: 200.0,
                                child: FadeInImage.assetNetwork(
                                  placeholder: 'images/image1.png' ,
                                  image: m['pImage'],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(16.0),
                                alignment: Alignment.centerLeft,
                                child: Text(m['pDescription']),
                              ),
                              ButtonBar(
                                children: [
                                  TextButton(
                                    child: const Text('CONTACT AGENT'),
                                    onPressed: () {/* ... */},
                                  ),
                                  TextButton(
                                    child: const Text('LEARN MORE'),
                                    onPressed: () {/* ... */},
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }else if(title.toLowerCase().contains(searchController.text.toString())){
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                        child: Card(
                          elevation: 4.0,
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(m['pTitle']),
                                // subtitle: Text('subheading'),
                                trailing: const Icon(Icons.favorite_outline),
                              ),
                              SizedBox(
                                height: 200.0,
                                child: FadeInImage.assetNetwork(
                                  placeholder: 'images/image1.png' ,
                                  image: m['pImage'],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(16.0),
                                alignment: Alignment.centerLeft,
                                child: Text(m['pDescription']),
                              ),
                              ButtonBar(
                                children: [
                                  TextButton(
                                    child: const Text('CONTACT AGENT'),
                                    onPressed: () {/* ... */},
                                  ),
                                  TextButton(
                                    child: const Text('LEARN MORE'),
                                    onPressed: () {/* ... */},
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }else{
                      return Container();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );




  }
}