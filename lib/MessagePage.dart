import 'dart:io';
import 'package:chatappproject/PhoneCallProject.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
class MessagePage extends StatefulWidget {

  var chatname = "";
  var chatemail = "";
  var chatphoto = "";
  var receiverid = "";
  MessagePage({this.chatname,this.chatemail,this.chatphoto,this.receiverid});
  @override
  State<MessagePage> createState() => _MessagePageState();
}
class _MessagePageState extends State<MessagePage> {
  TextEditingController _msg = TextEditingController();
  //
  // bool emojiShowing = false;
  //
  // _onEmojiSelected(Emoji emoji) {
  //   _msg
  //     ..text += emoji.emoji
  //     ..selection = TextSelection.fromPosition(
  //         TextPosition(offset: _msg.text.length));
  // }
  //
  // _onBackspacePressed() {
  //   _msg
  //     ..text = _msg.text.characters.skipLast(1).toString()
  //     ..selection = TextSelection.fromPosition(
  //         TextPosition(offset: _msg.text.length));
  // }
  var senderid="";
  getdata() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      senderid = prefs.getString("senderid");
    });
  }
  File imagefile;
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children:[
            CircleAvatar(
              child: Image.network(widget.chatphoto),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.chatname, style: TextStyle(color: Colors.white, fontSize: 10.0, fontWeight: FontWeight.w600),),
                Text(widget.chatemail, style: TextStyle(color: Colors.white, fontSize: 5.0, fontWeight: FontWeight.w600),),
              ],
            ),
          ],
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Icon(Icons.videocam_sharp),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 0.0),
            child: IconButton(
              icon: Icon(Icons.call),
              onPressed: (){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=>PhoneCallProject())
                );
              },
            ),
          ),
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
        ],
        backgroundColor: Colors.green,
      ),
      body: Container(
        color: Colors.brown,
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("Chats").doc(senderid)
                    .collection("Users").doc(widget.receiverid).collection("messages")
                    .orderBy("timestamp",descending: true).snapshots(),
                builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot)
                {
                  if(snapshot.hasData)
                  {
                    if(snapshot.data.size<=0)
                    {
                      return Center(
                        child: Text("No chats!"),
                      );
                    }
                    else
                    {
                      return ListView(
                        controller: _scrollController,
                        shrinkWrap: true,
                        reverse: true,
                        children: snapshot.data.docs.map((document){
                          if(senderid==document["senderid"])
                            {
                              return Align(
                                child: Container(
                                  padding: EdgeInsets.all(15.0),
                                  margin: EdgeInsets.all(15.0),
                                  child: ChatBubble(
                                    clipper: ChatBubbleClipper1(type: BubbleType.sendBubble),
                                    alignment: Alignment.topRight,
                                    margin: EdgeInsets.only(top: 20),
                                    backGroundColor: Colors.green,
                                    child: Container(
                                      constraints: BoxConstraints(
                                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                                      ),
                                      child: (document["type"]=="image")?Image.network(document["msg"],width: 100.0,):Text(document["msg"].toString(),style: TextStyle(color: Colors.white),),
                                    ),
                                  )
                              ),
                                alignment: Alignment.centerRight,
                              );
                            }
                          else
                            {
                              return Align(
                                child: Container(
                                  padding: EdgeInsets.all(15.0),
                                  margin: EdgeInsets.all(15.0),
                                  child: ChatBubble(
                                    clipper: ChatBubbleClipper1(type: BubbleType.receiverBubble),
                                    backGroundColor: Colors.grey,
                                    margin: EdgeInsets.only(top: 20),
                                    child: Container(
                                      constraints: BoxConstraints(
                                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                                      ),
                                      child: (document["type"]=="image")?Image.network(document["msg"],width: 100.0,):Text(document["msg"].toString(),style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                alignment: Alignment.centerLeft,
                              );
                            }
                        }).toList(),
                      );
                    }
                  }
                  else
                  {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(2.0),
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(35.0),
                        // boxShadow: const [
                        //   BoxShadow(
                        //       offset: Offset(0, 2),
                        //       blurRadius: 7,
                        //       color: Colors.blue)
                        // ],
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: (){
                              // setState(() {
                              //   emojiShowing = !emojiShowing;
                              // });
                            },
                            icon: Icon(Icons.emoji_emotions,size: 30,),
                          ),

                          Expanded(
                            child: TextField(
                              controller: _msg,
                              cursorColor: Colors.green,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: ()async{
                                    ImagePicker _picker = ImagePicker();
                                    XFile photo = await _picker.pickImage(source: ImageSource.gallery);
                                    imagefile = File(photo.path);
                                    var uuid = new Uuid();
                                    String filename = uuid.v1().toString()+".jpg";
                                    await FirebaseStorage.instance.ref(filename).putFile(imagefile).whenComplete((){}).then((filedata) async{
                                      await filedata.ref.getDownloadURL().then((fileurl) async{
                                        await FirebaseFirestore.instance.collection("Chats")
                                            .doc(senderid).collection("Users")
                                            .doc(widget.receiverid).collection("messages").add({
                                          "senderid":senderid,
                                          "receiverid":widget.receiverid,
                                          "msg":fileurl,
                                          "type":"image",
                                          "timestamp":DateTime.now().millisecondsSinceEpoch
                                        }).then((value) async{
                                          await FirebaseFirestore.instance.collection("Chats")
                                              .doc(widget.receiverid).collection("Users")
                                              .doc(senderid).collection("messages").add({
                                            "senderid":senderid,
                                            "receiverid":widget.receiverid,
                                            "msg":fileurl,
                                            "type":"image",
                                            "timestamp":DateTime.now().millisecondsSinceEpoch
                                          }).then((value){
                                            _msg.text="";
                                          });
                                        });
                                      });
                                    });
                                  },
                                  icon: Icon(Icons.attach_file,size: 30,color: Colors.grey,),
                                ),
                                hintText: "Message",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0,left: 2.0),
                            child: GestureDetector(
                                child: Icon(Icons.camera_alt,size: 30,color: Colors.grey,),
                              onTap: () async{
                                ImagePicker _picker = ImagePicker();
                                XFile photo = await _picker.pickImage(source: ImageSource.camera);
                                imagefile = File(photo.path);
                                var uuid = new Uuid();
                                String filename = uuid.v1().toString()+".jpg";
                                await FirebaseStorage.instance.ref(filename).putFile(imagefile).whenComplete((){}).then((filedata) async{
                                  await filedata.ref.getDownloadURL().then((fileurl) async{
                                    await FirebaseFirestore.instance.collection("Chats")
                                        .doc(senderid).collection("Users")
                                        .doc(widget.receiverid).collection("messages").add({
                                      "senderid":senderid,
                                      "receiverid":widget.receiverid,
                                      "msg":fileurl,
                                      "type":"image",
                                      "timestamp":DateTime.now().millisecondsSinceEpoch
                                    }).then((value) async{
                                      await FirebaseFirestore.instance.collection("Chats")
                                          .doc(widget.receiverid).collection("Users")
                                          .doc(senderid).collection("messages").add({
                                        "senderid":senderid,
                                        "receiverid":widget.receiverid,
                                        "msg":fileurl,
                                        "type":"image",
                                        "timestamp":DateTime.now().millisecondsSinceEpoch
                                      }).then((value){
                                        _msg.text="";
                                      });
                                    });
                                  });
                                });


                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 2.0),
                                child: GestureDetector(
                                    onTap: (){},
                                    child: Icon(Icons.currency_rupee_outlined,color: Colors.grey,),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // SizedBox(width: 15),
                  GestureDetector(
                    onTap: () async{
                      _scrollController.animateTo(
                        0.0,
                        curve: Curves.easeOut,
                        duration: const Duration(milliseconds: 300),
                      );
                      var msg = _msg.text.toString();
                      await FirebaseFirestore.instance.collection("Chats")
                          .doc(senderid).collection("Users")
                          .doc(widget.receiverid).collection("messages").add({
                        "senderid":senderid,
                        "receiverid":widget.receiverid,
                        "msg":msg,
                        "type":"text",
                        "timestamp":DateTime.now().millisecondsSinceEpoch
                      }).then((value) async{
                        await FirebaseFirestore.instance.collection("Chats")
                            .doc(widget.receiverid).collection("Users")
                            .doc(senderid).collection("messages").add({
                          "senderid":senderid,
                          "receiverid":widget.receiverid,
                          "msg":msg,
                          "type":"text",
                          "timestamp":DateTime.now().millisecondsSinceEpoch
                        }).then((value){
                          _msg.text="";
                        });
                      });
                    },
                     child: Padding(
                       padding: EdgeInsets.only(left: 4.0),
                       child: CircleAvatar(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2.0),
                          child: Icon(Icons.send,color: Colors.white,size: 25.0,),
                        ),
                        backgroundColor: Colors.green,
                        radius: 25.0,
                    ),
                     ),
                  ),
                ],
              ),
            ),
            // Offstage(
            //   offstage: !emojiShowing,
            //   child: SizedBox(
            //     height: 250,
            //     child: EmojiPicker(
            //         onEmojiSelected: (Category category, Emoji emoji) {
            //           _onEmojiSelected(emoji);
            //         },
            //         onBackspacePressed: _onBackspacePressed,
            //         config: Config(
            //             columns: 7,
            //             // Issue: https://github.com/flutter/flutter/issues/28894
            //             emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
            //             verticalSpacing: 0,
            //             horizontalSpacing: 0,
            //             gridPadding: EdgeInsets.zero,
            //             initCategory: Category.RECENT,
            //             bgColor: const Color(0xFFF2F2F2),
            //             indicatorColor: Colors.blue,
            //             iconColor: Colors.grey,
            //             iconColorSelected: Colors.blue,
            //             progressIndicatorColor: Colors.blue,
            //             backspaceColor: Colors.blue,
            //             skinToneDialogBgColor: Colors.white,
            //             skinToneIndicatorColor: Colors.grey,
            //             enableSkinTones: true,
            //             showRecentsTab: true,
            //             recentsLimit: 28,
            //             replaceEmojiOnLimitExceed: false,
            //             noRecents: Text(
            //               'No Recents',
            //               style: TextStyle(fontSize: 20, color: Colors.black26),
            //               textAlign: TextAlign.center,
            //             ),
            //             tabIndicatorAnimDuration: kTabScrollDuration,
            //             categoryIcons: const CategoryIcons(),
            //             buttonMode: ButtonMode.MATERIAL)),
            //   ),
            // ),
          ],
        ),

      ),
    );

  }

}