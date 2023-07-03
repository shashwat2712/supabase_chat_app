import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_flutter_application/main.dart';


class CameraPage extends StatefulWidget {
  static String location = "";
  const CameraPage({Key? key}) : super(key: key);


  @override
  State<CameraPage> createState() => _CameraPageState();
}


class _CameraPageState extends State<CameraPage> {


  String imageUrl = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () async {
                    ImagePicker imagePicker = ImagePicker();
                    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

                    if(file == null){
                      return;
                    }
                    final uid = superbase.auth.currentUser!.id;
                    if(uid.isEmpty)return;
                    try{
                      await superbase.storage
                          .from('users_profile_photos')
                          .upload(
                          '$uid/${file.name}',
                          File(file.path));
                    }
                    catch(error){
                      if(!mounted)return;
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Error Please try again'))
                      );
                    }
                    try{
                      final publicUrl = await superbase
                          .storage
                          .from('users_profile_photos')
                          .getPublicUrl('$uid/${file.name}');

                      await superbase.from('users').update({
                        'profile_photo_url' : publicUrl
                      }).eq('uid', uid);
                    }
                    catch(error){
                      if(!mounted)return;
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Error Please try again'))
                      );
                    }

                  },
                  child: Container(
                    height: 125.0,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.grey[200],
                    ),
                    child: Image.asset('lib/assets/image-gallery.png',
                      height: 40,


                    ),
                  ),

                ),
                GestureDetector(
                  onTap: () async {
                    ImagePicker imagePicker = ImagePicker();
                    XFile? file = await imagePicker.pickImage(source: ImageSource.camera);

                    if(file == null){
                      return;
                    }
                    final uid = superbase.auth.currentUser!.id;
                    if(uid.isEmpty)return;
                    try{
                      await superbase.storage
                          .from('users_profile_photos')
                          .upload(
                              '$uid/${file.name}',
                              File(file.path));
                    }
                    catch(error){
                      if(!mounted)return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Error Please try again'))
                      );
                    }
                    try{
                      final publicUrl = await superbase
                          .storage
                          .from('users_profile_photos')
                          .getPublicUrl('$uid/${file.name}');

                      await superbase.from('users').update({
                        'profile_photo_url' : publicUrl
                      }).eq('uid', uid);
                    }
                    catch(error){
                      if(!mounted)return;
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Error Please try again'))
                      );
                    }

                  },
                  child: Container(
                    height: 125.0,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.grey[200],
                    ),
                    child: Image.asset('lib/assets/camera.png',
                      height: 40,


                    ),
                  ),

                ),
              ],
            ),


            const SizedBox(height: 30.0,),


          ],
        ),
      ),
    );
  }
}



