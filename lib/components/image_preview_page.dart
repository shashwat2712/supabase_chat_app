import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flyin_social_media_app/components/myListTile.dart';
import 'package:flyin_social_media_app/components/my_textfield.dart';
import 'package:flyin_social_media_app/nav_screen.dart';
import 'package:flyin_social_media_app/video_making_page.dart';

import 'MyButton.dart';
class ImagePreview extends StatefulWidget {

  ImagePreview(this.file , {Key? key}) : super(key: key);
  XFile file;

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {

  String uid = FirebaseAuth.instance.currentUser?.uid.toString()??" ";
  final currentUser = FirebaseAuth.instance.currentUser!;
  String imageUrl = "";
  int views = 0;


  final titleController = TextEditingController();
  final categoryController = TextEditingController();

  void postMessage(){



      //store in firebase
      FirebaseFirestore.instance.collection('User_Posts').add({
        'Views' : views.toString(),
        'Phone_Number': currentUser.uid,
        'location': CameraPage.location,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
        'Category' : categoryController.text,
        'Title':titleController.text,
        'image_url': imageUrl,
        'authorID': FirebaseAuth.instance.currentUser!.uid.toString(),
      });

      Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => NavScreen()),
            (route) => false,);




    //clear the text field


  }
  @override
  Widget build(BuildContext context) {
    File picture = File(widget.file.path);
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        leadingWidth: 100.0,
        leading: Image.asset('lib/assets/logo.png'),
        backgroundColor: Colors.black87,
        actions:  [

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.notification_add_outlined),
              onPressed: (){},
            ),
          )
        ],

      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10.0,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.pink[200],

                ),

                margin: EdgeInsets.symmetric(horizontal: 10),
                height: 250,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),

                  child:Image.file(picture,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            SizedBox(height: 40.0),
            Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: titleController,
            style: TextStyle(
              color: Colors.grey[300],
            ),
            decoration: InputDecoration(
              labelText: 'Title',
              labelStyle: TextStyle(
                color: Colors.white
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)
              ),
              fillColor: Colors.black12,
              filled: true,
              hintText: 'hintText',
              hintStyle: TextStyle(
                color: Colors.white
              )
            ),
          ),
        ),
            SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: categoryController,
                obscureText: false,
                style: TextStyle(
                  color: Colors.grey[300],
                ),
                decoration: InputDecoration(
                    labelText: 'Category',
                    labelStyle: TextStyle(
                        color: Colors.white
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)
                    ),
                    fillColor: Colors.black12,
                    filled: true,
                    hintText: 'like Entertainment,Education,Sports etc',
                    hintStyle: TextStyle(
                        color: Colors.white
                    )
                ),

              ),
            ),
            SizedBox(height: 30.0),

            Divider(thickness: 1,color: Colors.white,),
            SizedBox(height: 10.0),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              height: 60.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.white,
                  ),
                  color: Colors.grey.shade200
              ),
              child: Row(
                children: [
                  Container(
                    width: 40.0,
                    child: Icon(Icons.location_pin)

                  ),
                  SizedBox(width: 5.0,),
                  const Text('|',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  SizedBox(width: 5.0,),
                  Expanded(
                      child: Text(CameraPage.location))
                ],
              ),
            ),
            SizedBox(height: 40,),
            MyButton(onTap: () async {
              //Display the image and ask user whether to upload it or not.
              //Get a reference to storage root
              Reference referenceRoot = FirebaseStorage.instance.ref();
              Reference referenceDirImages = referenceRoot.child('images');
              String uniqueFileName = DateTime.now().microsecondsSinceEpoch.toString();


              //Creating the reference for the image to be stored in firebase.
              Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);
              //uniqueFileName is just the name of reference just under
              // which the image is stored


              //So now we have created a path for the image to be stored but not
              // stored the image yet in the firebase

              try{
                //Store the file
                await  referenceImageToUpload.putFile(File(widget.file!.path));
                imageUrl = await referenceImageToUpload.getDownloadURL();

              }catch(error){
                print(error);

              }
              try{
                postMessage();
              }
              catch(error){
                print(error);
              }


            }, text: 'Post'),




          ],
        ),
      ),
    );
  }
}
