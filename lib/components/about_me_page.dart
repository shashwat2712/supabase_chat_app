import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter_application/components/social_icons.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                buildCoverImage(),
                const SizedBox(height: 20,),
                Positioned(
                  left: 5,
                    top: 20,
                    child:Container(
                      width: 70,height: 70,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(120),
                          color: Colors.black12
                      ),
                      child: Center(
                        child: IconButton(
                          onPressed: () { Navigator.pop(context); },
                          icon: const Icon(Icons.arrow_back_ios_new,
                          size: 35,),

                        ),
                      )
                    ),
                ),
                Positioned(
                  top: 220,
                    child: builtProfileImage()
                ),
              ],
            ),
            const SizedBox(height: 125.0),
            Text('Shashwat Sai Vyas',
            style: GoogleFonts.rubik(
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.0
              )
            )),
            Text('A coding Freak',
              style: GoogleFonts.sassyFrass(
                textStyle: TextStyle(
                  fontSize: 35,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                SocialIcons(name: 'lib/assets/linkedin.png',linkName: 'www.youtube.com'),
                SocialIcons(name: 'lib/assets/instagram.png',linkName: 'https://www.linkedin.com/in/shashwat-sai-vyas-92395a224/'),
                SocialIcons(name: 'lib/assets/github.png',linkName: 'https://www.linkedin.com/in/shashwat-sai-vyas-92395a224/'),
              ],
            ),
            const SizedBox(height: 10.0),
            const Divider(thickness: 1.0,),
            const SizedBox(height: 10.0),

            const Padding(
              padding: EdgeInsets.fromLTRB(20.0, 0, 175.0, 0),
              child: Text('About Me',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),

              ),
            ),
            const SizedBox(height: 10.0),
             Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Hey Whatsapp , I am a Computer Science sophomore from '
                    'S.G.S.I.T.S. ,Indore trying to push my limits and explore each corner '
                    'of this techy world. ',
                  style: GoogleFonts.oswald(
                    textStyle: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),

                ),
              ),
            ),
            SizedBox(height: 50,),

          ],
        ),
      ),
    );
  }

  Widget buildCoverImage() => Container(
    color: Colors.grey,
    child: Image.asset('lib/assets/background.png',
    width: double.infinity,
    height: 300,
    fit: BoxFit.cover,
    )
  );
  Widget builtProfileImage() => CircleAvatar(
    backgroundColor: Colors.white,
    radius: 95,
    child: CircleAvatar(
      radius: 90,
      backgroundColor: Colors.grey.shade800,
      backgroundImage: const AssetImage('lib/assets/shashwatsai.jpg'),
    ),
  );
}


