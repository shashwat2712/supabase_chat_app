import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flyin_social_media_app/media_info.dart';
import 'package:timeago/timeago.dart';
import 'package:timeago/timeago.dart' as timeago;

class VideoCard extends StatelessWidget {
  final String videoTitle;
  final String videoAuthor;
  final String viewCount;
  DateTime timeStamp;
  final String ImageData;
  final List<String> likes;
  final String postID;
  final String views;


   VideoCard({
     super.key,
     required this.videoTitle,
     required this.videoAuthor,
     required this.viewCount,
     required this.timeStamp,
     required this.ImageData,
     required this.postID,
     required this.likes,
     required this.views,

}) ;

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser ;
    return GestureDetector(
      onTap: () async {
        print(postID);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MediaInfo(postID: postID,
              likes: likes,
            )));
        DocumentReference postRef =  FirebaseFirestore.instance.collection('User_Posts')
            .doc(postID);
        int a = int.parse(views) + 1;
        await postRef.update(
            {
              'Views' : a.toString()
            }

        );
      },
      child: Column(
        children: [
          Image.network(ImageData,
            height: 220.0,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  foregroundImage: AssetImage('lib/assets/person-icon.png'),
                ),
                const SizedBox(width: 8.0,),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(child: Text(
                        videoTitle,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[300]
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )),
                      SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: Text(

                              '${videoAuthor} • ${viewCount} views • ${'${timeago.format(timeStamp)}'}',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey[300]
                              ),
                              maxLines: 1,

                            overflow: TextOverflow.ellipsis,
                          )),
                          // Flexible(child: Text(
                          //   viewCount,
                          //   maxLines: 1,
                          //   overflow: TextOverflow.ellipsis,
                          // )),
                          // Flexible(child: Text(
                          //   '${timeago.format(timeStamp)}',
                          //   maxLines: 1,
                          //   overflow: TextOverflow.ellipsis,
                          // )),
                        ],
                      ),

                    ],
                  ),
                ),
                Icon(Icons.more_vert,
                  size: 20.0,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),



        ],

      ),
    );
  }
}
