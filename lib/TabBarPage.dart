import 'package:chatappproject/ChatsPage.dart';
import 'package:chatappproject/LoginGooglePage.dart';
import 'package:chatappproject/MessagePage.dart';
import 'package:chatappproject/PhoneCallProject.dart';
import 'package:chatappproject/StatusPage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabBarPage extends StatefulWidget {

  @override
  State<TabBarPage> createState() => _TabBarPageState();
}

class _TabBarPageState extends State<TabBarPage> {

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
        appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Welcome,"+tname,style: TextStyle(fontSize: 10.0),),
            PopupMenuButton(
              onSelected: (value) {},
              itemBuilder: (BuildContext bc) {
                return const [
                  PopupMenuItem(
                    child: Text("New Group"),
                    value: '/group',
                  ),
                  PopupMenuItem(
                    child: Text("New broadcast"),
                    value: '/broadcast',
                  ),
                  PopupMenuItem(
                    child: Text("Linked devices"),
                    value: '/devices',
                  ),
                  PopupMenuItem(
                    child: Text("Starred messages"),
                    value: '/messages',
                  ),
                  PopupMenuItem(
                    child: Text("Payments"),
                    value: '/pay',
                  ),
                  PopupMenuItem(
                    child: Text("Settings"),
                    value: '/set',
                  ),
                ];
              },
            ),
            GestureDetector(
              onTap: (){},
              child: Icon(Icons.search_rounded),
            ),
            GestureDetector(
              onTap: () async{
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();
                final GoogleSignIn googleSignIn = GoogleSignIn();
                googleSignIn.signOut();
                Navigator.of(context).pop();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=>LoginGooglePage())
                );
              },
              child: Icon(Icons.logout),
            ),
          ],
        ),
          bottom: TabBar(
            indicatorColor: Colors.amberAccent,
            tabs: [
              Tab(
                child: Icon(Icons.camera_alt),
              ),
              Tab(
                child: Text("Chats"),
              ),
              Tab(
                child: Text("Status"),
              ),
              Tab(
                child: Text("Calls"),
              ),
            ],
          ),
        ),
          body: TabBarView(
            children: [
              StatusPage(),
              ChatsPage(),
              StatusPage(),
              StatusPage(),
            ],
          ),
        ),
    );
  }
}
