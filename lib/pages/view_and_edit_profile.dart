
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter_application/components/MyButton.dart';
import 'package:supabase_flutter_application/main.dart';
import 'package:supabase_flutter_application/pages/upload_image_page.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {





  var nameController = TextEditingController();

  var captionController = TextEditingController();

  var phoneController = TextEditingController();

   String currentName = '';
   String currentBranch = '';
   String currentHometown = '';



  @override
  Widget build(BuildContext context) {


    return StreamBuilder(
      //Fetching data from the documentId specified of the student
      stream: superbase.from('users').stream(primaryKey: ['id']).eq('uid', superbase.auth.currentUser!.id),
      builder:
          (BuildContext context, AsyncSnapshot snapshot) {


        //Error Handling conditions
        if (snapshot.hasError) {
          return const Center(child: AlertDialog(title: Text("Something went wrong Please Refresh")));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SafeArea(
            child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.black54,
                  elevation: 0.0,
                  centerTitle: true,
                  title: Text(
                    'Your Profile',
                    style: GoogleFonts.oswald(),
                  ),
                  leading: IconButton(onPressed: (){Navigator.pop(context);},
                    icon: Icon(Icons.arrow_back_ios_new),),

                ),
                backgroundColor: Colors.grey[300],

                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 5.0,),
                      Center(
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 80,
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.asset('lib/assets/teacher.jpg',
                                  height: 400,
                                  width: 400,
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: IconButton(
                                  icon: const Icon(Icons.camera_alt_outlined,
                                    size: 40,
                                    color: Colors.black38,
                                  ),
                                  onPressed: (){},
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                              label: const Text('Name'),
                              prefixIcon: const Icon(Icons.person),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black87)
                              ),
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              hintText: ''

                          ),
                        ),
                      ),


                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: TextFormField(
                          controller: captionController,
                          decoration: InputDecoration(
                              label: Text('caption'),
                              prefixIcon: const Icon(Icons.school),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black87)
                              ),
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              hintText: ''

                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: TextFormField(
                          controller: phoneController,
                          decoration: InputDecoration(
                              label: const Text('phone'),
                              prefixIcon: const Icon(Icons.place),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black87)
                              ),
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              hintText: ''


                          ),
                        ),
                      )
                    ],
                  ),
                )),
          );
        }



        //Data is output to the user
        if (snapshot.connectionState == ConnectionState.active) {
          final data = snapshot!.data;
          return SafeArea(
            child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.black54,
                  elevation: 0.0,
                  centerTitle: true,
                  title: Text(
                    'Your Profile',
                    style: GoogleFonts.oswald(),
                  ),
                  leading: IconButton(onPressed: (){Navigator.pop(context);},
                    icon: const Icon(Icons.arrow_back_ios_new),),

                ),
                backgroundColor: Colors.grey[300],

                body: SingleChildScrollView(
                  child: Column( 
                    children: [
                      SizedBox(height: 5.0,),
                      Center(
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(context,MaterialPageRoute(builder: (context)=> const CameraPage()));
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 80,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.network(data[0]['profile_photo_url'].toString(),
                                    height: 220.0,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: IconButton(
                                    icon: const Icon(Icons.camera_alt_outlined,
                                      size: 40,
                                      color: Colors.black38,
                                    ),
                                    onPressed: (){
                                      Navigator.push(context,MaterialPageRoute(builder: (context)=> const CameraPage()));
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                              label: const Text('Name'),
                              prefixIcon: const Icon(Icons.person),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black87)
                              ),
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              hintText: data[0]['name'].toString()

                          ),
                        ),
                      ),


                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: TextFormField(
                          controller: captionController,
                          decoration: InputDecoration(
                              label: const Text('Caption'),
                              prefixIcon: const Icon(Icons.closed_caption_rounded),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black87)
                              ),
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              hintText: data[0]['caption'].toString()

                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: TextFormField(
                          controller: phoneController,
                          decoration: InputDecoration(
                              label: const Text('Phone'),
                              prefixIcon: const Icon(Icons.phone),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black87)
                              ),
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              hintText: data[0]['phone'].toString()


                          ),
                        ),
                      ),
                      const SizedBox(height: 40,),
                      MyButton(
                          onTap: () async {

                              if (nameController.text.isNotEmpty) {
                                await superbase.from('users').update({
                                  'name': nameController.text.trim(),
                                }).eq('uid', superbase.auth.currentUser!.id);

                                setState(() {
                                  nameController.clear();
                                });
                              }
                              if (captionController.text.isNotEmpty) {
                                await superbase.from('users').update({
                                  'caption': captionController.text.trim(),
                                }).eq('uid', superbase.auth.currentUser!.id);
                                setState(() {
                                  captionController.clear();
                                });
                              }
                              if (phoneController.text.isNotEmpty) {
                                await superbase.from('users').update({
                                  'phone': phoneController.text.trim()
                                }).eq('uid', superbase.auth.currentUser!.id);
                                setState(() {
                                  phoneController.clear();
                                });
                              }

                      },
                          text: 'Save'
                      ),
                    ],
                  ),
                )),
          );
        }
        final data = snapshot!.data;
        return SafeArea(
          child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black54,
                elevation: 0.0,
                centerTitle: true,
                title: Text(
                  'Your Profile',
                  style: GoogleFonts.oswald(),
                ),
                leading: IconButton(onPressed: (){Navigator.pop(context);},
                  icon: Icon(Icons.arrow_back_ios_new),),

              ),
              backgroundColor: Colors.grey[300],

              body: SingleChildScrollView(
                child: Column( 
                  children: [

                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                            label: Text('Name'),
                            prefixIcon: const Icon(Icons.person),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black87)
                            ),
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            hintText: data[0]['name'].toString()

                        ),
                      ),
                    ),


                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextFormField(
                        controller: captionController,
                        decoration: InputDecoration(
                            label: Text('Caption'),
                            prefixIcon: const Icon(Icons.school),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black87)
                            ),
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            hintText: data[0]['caption'].toString()

                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextFormField(
                        controller: phoneController,
                        decoration: InputDecoration(
                            label: const Text('Phone'),
                            prefixIcon: const Icon(Icons.phone),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black87)
                            ),
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            hintText: data[0]['phone'].toString()


                        ),
                      ),
                    ),

                    MyButton(onTap: () async {
                      try{
                        if (nameController.text.isNotEmpty) {
                          await superbase.from('users').update({
                            'name': nameController.text.trim(),
                          }).eq('uid', superbase.auth.currentUser!.id);

                          nameController.clear();
                        }
                        if (captionController.text.isNotEmpty) {
                          await superbase.from('users').update({
                            'caption': captionController.text.trim(),
                          }).eq('uid', superbase.auth.currentUser!.id);
                        }
                        if (phoneController.text.isNotEmpty) {
                          await superbase.from('users').update({
                            'phone': phoneController.text.trim()
                          }).eq('uid', superbase.auth.currentUser!.id);
                        }
                      }
                      catch(error){
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error.toString())));
                      }
                    }, text: 'Save')
                  ],
                ),
              )),
        );

      },
    );
  }
  }
// SizedBox(height: 20),
// MyListTile(
// icon: Icons.near_me,
// text: "Full Name: ${data['name']}",
// endIcon: Icons.accessibility_new_outlined
// ),
//
//
// SizedBox(height: 20),
// MyListTile(
// icon: Icons.near_me,
// text: "Branch: ${data['branch']}",
// endIcon: Icons.accessibility_new_outlined
// ),
//
// SizedBox(height: 20),
// MyListTile(
// icon: Icons.near_me,
// text: "Hometown: ${data['hometown']}",
// endIcon: Icons.accessibility_new_outlined
// ),
//
// Divider(thickness: 1.0,),
