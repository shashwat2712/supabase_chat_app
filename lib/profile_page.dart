import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter_application/components/about_me_page.dart';
import 'package:supabase_flutter_application/view_and_edit_profile.dart';

import 'components/myListTile.dart';
import 'loginOrRegisterPage.dart';
import 'main.dart';



class ProfileScreen extends StatefulWidget {
  final String name;
  const ProfileScreen({Key? key, required this.name}) : super(key: key);


  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void setStatus(String status)async{
    if(superbase.auth.currentUser == null )return;
    try{
      await superbase.from('users').update(
          {'status': status
          }).eq('uid', superbase.auth.currentUser!.id);
    }
    catch(error){
      print(error);
    }
  }

  Future<void> signUserOut() async {
    await superbase.auth.signOut();
    if(!mounted)return;
    setStatus('offline');
    Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => const LoginOrRegisterPage()),
          (route) => false,);

  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                SizedBox(height: 15),
                Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 70,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset('lib/assets/teacher.jpg',
                        height: 400,
                        width: 400,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                Text(
                    widget.name,
                    style: GoogleFonts.oswald(
                        textStyle: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ))
                ),
                const SizedBox(height: 5),

                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfile()));

                  },
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.symmetric(horizontal: 80,vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.pink[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:   Center(
                      child: Text(
                        'Edit Profile',
                        style: GoogleFonts.oswald(
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          )

                        )
                        )
                      ),
                    ),
                  ),
                const Divider(
                  thickness: 1.0,
                ),
                SizedBox(height: 8),
                const MyListTile(
                  icon: Icons.settings,
                  text: 'Setting',

                ),
                 MyListTile(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>MyProfile()));
                  },
                  icon: Icons.schedule,
                  text: 'Schedule',

                ),
                 MyListTile(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>MyProfile()));
                  },
                  icon: Icons.recent_actors_rounded,
                  text: 'Logs',

                ),

                MyListTile(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>MyProfile()));
                  },
                  icon: Icons.info,
                  text: 'About Us',

                ),
                MyListTile(
                  onTap: signUserOut,
                  icon: Icons.logout,
                  text: 'Log Out',
                ),
                SizedBox(height: 30,)
              ],

            ),
          ),
        ),
      ),
    );
  }
}


