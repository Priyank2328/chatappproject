import 'package:chatappproject/MessagePage.dart';
import 'package:chatappproject/LoginGooglePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatsPage extends StatefulWidget {

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  var tname = "";
  var tgmail = "";
  getdata() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tname = prefs.getString("fname");
      tgmail = prefs.getString("femail");
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        // appBar: AppBar(
        //   title: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Text("Welcome,"+tname,style: TextStyle(fontSize: 10.0),),
        //       PopupMenuButton(
        //         onSelected: (value) {},
        //         itemBuilder: (BuildContext bc) {
        //           return const [
        //             PopupMenuItem(
        //               child: Text("New Group"),
        //               value: '/group',
        //             ),
        //             PopupMenuItem(
        //               child: Text("New broadcast"),
        //               value: '/broadcast',
        //             ),
        //             PopupMenuItem(
        //               child: Text("Linked devices"),
        //               value: '/devices',
        //             ),
        //             PopupMenuItem(
        //               child: Text("Starred messages"),
        //               value: '/messages',
        //             ),
        //             PopupMenuItem(
        //               child: Text("Payments"),
        //               value: '/pay',
        //             ),
        //             PopupMenuItem(
        //               child: Text("Settings"),
        //               value: '/set',
        //             ),
        //           ];
        //         },
        //       ),
        //       IconButton(
        //         onPressed: () async{
        //           SharedPreferences prefs = await SharedPreferences.getInstance();
        //           prefs.clear();
        //           final GoogleSignIn googleSignIn = GoogleSignIn();
        //           googleSignIn.signOut();
        //           Navigator.of(context).pop();
        //           Navigator.of(context).push(
        //               MaterialPageRoute(builder: (context)=>LoginGooglePage())
        //           );
        //         },
        //         icon: Icon(Icons.logout),
        //       ),
        //     ],
        //   ),
        // ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Chats").where("femail",isNotEqualTo: tgmail).snapshots(),
          builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot)
          {
            if(snapshot.hasData)
            {
              if(snapshot.data.size<=0)
              {
                return Center(child: Text("Your Data Is Clear Please Enter New Data!",style: TextStyle(color: Colors.red,fontSize: 18.0),),);
              }
              else
              {
                return ListView(
                  children: snapshot.data.docs.map((document){
                    return Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(document["fname"].toString(),style: TextStyle(color: Colors.red),),
                                  subtitle: Text(document["femail"].toString(),style: TextStyle(color: Colors.blue),),
                                  leading: CircleAvatar(
                                    child: Image.network(document["fphoto"].toString(),width: 100,),
                                  ),
                                  onTap: (){
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context)=>MessagePage(chatname: document["fname"].toString(),
                                        chatemail: document["femail"].toString(),receiverid: document.id.toString(),chatphoto: document["fphoto"].toString(),))
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                );
              }
            }
            else
            {
              return Center(child: CircularProgressIndicator(),);
            }
          },
        ),
      ),
    );
  }
}
