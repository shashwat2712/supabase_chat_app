

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flyin_social_media_app/components/reply_bar.dart';
import 'package:flyin_social_media_app/components/reply_button.dart';

import 'helper_methods/formatDate.dart';


class WallPost extends StatefulWidget {
  final String message ;
  final String user;
  final String commentID;
  final String postID;


  const WallPost({
    super.key,
    required this.message,
    required this.user,
    required this.commentID,
    required this.postID

});

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  final replyController = TextEditingController();
  void showReplyBox(){
    showDialog(context: context,
        builder:(context) => AlertDialog(
          title: Text("Add Reply"),
          content: TextField(
            controller: replyController,
            decoration: const InputDecoration(
                hintText: "Write the reply here"
            ),
          ),
          actions: [
            //cancel button
            TextButton(onPressed:(){
              Navigator.pop(context);

              //clearing the text box
              replyController.clear();
            },
                child: Text('Cancel')),

            //Post Button
            TextButton(onPressed:(){
              addReply(replyController.text.toString());

              //Clearing the text box
              replyController.clear();

              //poping the alert box
              Navigator.pop(context);

            },
                child: Text('Post')),



          ],


        ) );
  }
  void addReply(String reply){
    FirebaseFirestore.instance.collection('User_Posts')
        .doc(widget.postID).collection('Comments').doc(widget.commentID).collection('Reply')
        .add({
      'reply_text' : reply,
      'TimeStamp' : Timestamp.now().toString(),
      'user': widget.user
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8.0)
      ),
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ),
          SizedBox(width: 20,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user,
                style: TextStyle(color: Colors.grey[300]),
              ),
              const SizedBox(height: 10,),

              Text(
                  widget.message,
                style: TextStyle(color: Colors.grey[300]),

              ),
              SizedBox(height: 10,),
              ReplyButton(onTap: showReplyBox,
              )
            ],
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('User_Posts')
                  .doc(widget.postID).collection('Comments').doc(widget.commentID).collection('Reply')
                  .orderBy('Timestamp', descending: false)
                  .snapshots(),
              builder: (context,snapshot){
                //show loading circle
                if(!snapshot.hasData){
                  return const Center(
                      child: CircularProgressIndicator()
                  );
                }
                return ListView(
                    shrinkWrap: true, //for nested lists
                    physics : const NeverScrollableScrollPhysics(),
                    children: snapshot.data!.docs.map((doc){
                      final replyData = doc.data() as Map<String, dynamic>;
                      return Text('Hello',
                        style: TextStyle(
                          color: Colors.grey[300],
                        ),
                      );
                      return ReplyBar(text: doc['reply_text'], time: doc['TimeStamp'], user: doc['user']);
                    }
                    ).toList()

                );


              }),



    ]));
  }
}
