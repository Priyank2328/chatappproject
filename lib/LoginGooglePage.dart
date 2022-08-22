import 'package:chatappproject/ChatsPage.dart';
import 'package:chatappproject/TabBarPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginGooglePage extends StatefulWidget {
  @override
  State<LoginGooglePage> createState() => _LoginGooglePageState();
}

class _LoginGooglePageState extends State<LoginGooglePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  var displayName = "";
  var email = "";
  var photoURL = "";
  var uid = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 300.0,),
            // Padding(
            //   padding: const EdgeInsets.only(right: 68.0,left: 68.0),
            //   child: Container(
            //     padding: EdgeInsets.only(top: 50.0),
            //     child: Center(
            //       child: ElevatedButton(
            //         onPressed: ()async{
            //           final GoogleSignIn googleSignIn = GoogleSignIn();
            //           final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
            //           if (googleSignInAccount != null) {
            //             final GoogleSignInAuthentication googleSignInAuthentication =
            //             await googleSignInAccount.authentication;
            //             final AuthCredential authCredential = GoogleAuthProvider.credential(
            //                 idToken: googleSignInAuthentication.idToken,
            //                 accessToken: googleSignInAuthentication.accessToken);
            //             UserCredential result = await auth.signInWithCredential(authCredential);
            //             User user = result.user;
            //             var name = user.displayName.toString();
            //             var email = user.email.toString();
            //             var photo = user.photoURL.toString();
            //             var googleid = user.uid.toString();
            //             await FirebaseFirestore.instance.collection("Chats").where("femail",isEqualTo: email).get().then((document) async{
            //               if(document.size==1)
            //                 {
            //                   SharedPreferences pref = await SharedPreferences.getInstance();
            //                   pref.setString("fname", name);
            //                   pref.setString("femail", email);
            //                   pref.setString("picture", photo);
            //                   pref.setString("fgoogle", googleid);
            //                   pref.setString("islogin", "yes");
            //                   pref.setString("senderid", document.docs.first.id.toString());
            //                   Navigator.of(context).pop();
            //                   Navigator.of(context).push(
            //                       MaterialPageRoute(builder: (context)=>TabBarPage())
            //                   );
            //                 }
            //               else
            //                 {
            //                   await FirebaseFirestore.instance.collection("Chats").add({
            //                     "fname":name,
            //                     "femail":email,
            //                     "fphoto":photo,
            //                     "fgoogle":googleid,
            //                   }).then((value) async{
            //                     SharedPreferences pref = await SharedPreferences.getInstance();
            //                     pref.setString("fname", name);
            //                     pref.setString("femail", email);
            //                     pref.setString("picture", photo);
            //                     pref.setString("fgoogle", googleid);
            //                     pref.setString("senderid", value.id.toString());
            //                     pref.setString("islogin", "yes");
            //                     Navigator.of(context).pop();
            //                     Navigator.of(context).push(
            //                         MaterialPageRoute(builder: (context)=>ChatsPage())
            //                     );
            //
            //                   });
            //                 }
            //             });
            //           }
            //         },
            //         child: Text("Login With Google",style: TextStyle(letterSpacing: 2.0),),
            //       ),
            //     ),
            //   ),
            // ),
            Container(
              padding: EdgeInsets.only(top: 50.0),
              child: Center(
                child: SignInButton(
                  Buttons.Google,
                  text: "Login with Google",
                  onPressed: () async{
                    final GoogleSignIn googleSignIn = GoogleSignIn();
                    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
                    if (googleSignInAccount != null) {
                      final GoogleSignInAuthentication googleSignInAuthentication =
                          await googleSignInAccount.authentication;
                      final AuthCredential authCredential = GoogleAuthProvider.credential(
                          idToken: googleSignInAuthentication.idToken,
                          accessToken: googleSignInAuthentication.accessToken);
                      UserCredential result = await auth.signInWithCredential(authCredential);
                      User user = result.user;
                      var name = user.displayName.toString();
                      var email = user.email.toString();
                      var photo = user.photoURL.toString();
                      var googleid = user.uid.toString();
                      await FirebaseFirestore.instance.collection("Chats").where("femail",isEqualTo: email).get().then((document) async{
                        if(document.size==1)
                        {
                          SharedPreferences pref = await SharedPreferences.getInstance();
                          pref.setString("fname", name);
                          pref.setString("femail", email);
                          pref.setString("picture", photo);
                          pref.setString("fgoogle", googleid);
                          pref.setString("islogin", "yes");
                          pref.setString("senderid", document.docs.first.id.toString());
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context)=>TabBarPage())
                          );
                        }
                        else
                        {
                          await FirebaseFirestore.instance.collection("Chats").add({
                            "fname":name,
                            "femail":email,
                            "fphoto":photo,
                            "fgoogle":googleid,
                          }).then((value) async{
                            SharedPreferences pref = await SharedPreferences.getInstance();
                            pref.setString("fname", name);
                            pref.setString("femail", email);
                            pref.setString("picture", photo);
                            pref.setString("fgoogle", googleid);
                            pref.setString("senderid", value.id.toString());
                            pref.setString("islogin", "yes");
                            Navigator.of(context).pop();
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context)=>ChatsPage())
                            );

                          });
                        }
                      });
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
