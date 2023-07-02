import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter_application/chatRoom_page.dart';
import 'package:supabase_flutter_application/components/chatTile.dart';
import 'package:supabase_flutter_application/profile_page.dart';
import 'package:supabase_flutter_application/search.dart';

import 'components/bullets.dart';
import 'loginOrRegisterPage.dart';
import 'main.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver{

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state){
    if(state == AppLifecycleState.resumed  ){

    }
    else{
      setStatus('offline');
    }

  }

  List<Map<String,dynamic>> data = [];

  final _searchController = TextEditingController();

  String chatRoomId(String user1, String user2){
    if(user1[0].toLowerCase().codeUnits[0]>user2[0].toLowerCase().codeUnits[0]){
      return "$user1$user2";
    }
    else{
      return '$user2$user1';
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
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          leadingWidth: 100.0,
          backgroundColor: Colors.grey[300],
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.perm_identity_sharp,
              size: 40,
            ),
            onPressed: () async{
              final map = await superbase.from('users').select('name').eq('uid', superbase.auth.currentUser!.id);

              if(!mounted)return;
              Navigator.push(context, 
                MaterialPageRoute(builder: (context)=>ProfileScreen(name: map[0]['name'].toString(),))
              );
            },

          ),
          actions:  [

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(Icons.notification_add_outlined),
                onPressed: (){},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(Icons.logout),
                onPressed: signUserOut,
              ),
            )
          ],

        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  decoration: BoxDecoration(color: Colors.pink[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //animation or picture
                      Container(
                        height: 125,
                        width: 125,
                        child: Lottie.network
                          (
                            'https://assets1.lottiefiles.com/packages/lf20_p9cnyffr.json',
                            fit: BoxFit.cover,
                            alignment: Alignment.centerLeft
                        ),
                      ),
                      const SizedBox(width: 20,),

                      //What's next in the schedule
                      Expanded(
                        child: Column(

                          children: [
                            Text("Explore ",
                              style: GoogleFonts.abel(
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0
                                ),
                              ),),
                            const SizedBox(height: 12,),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceEvenly,
                              children: [
                                MyBullets(text: "New", leading_icon: Icons.verified,),
                                SizedBox(width: 20,),
                                MyBullets(text: "Anonymous", leading_icon: Icons.verified,),

                              ],
                            ),
                            const SizedBox(height: 12,),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context,
                                MaterialPageRoute(builder: (context)=> SearchPage())
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                    color: Colors.deepPurple[300],
                                    borderRadius: BorderRadius.circular(12)
                                ),
                                child: Center(
                                  child: Text('Find People',
                                      style: GoogleFonts.abel(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      )),
                                ),
                              ),
                            )
                          ],
                        ),
                      )


                    ],)
              ),
            ),
            SizedBox(height: 12,),

            Expanded(
              child: StreamBuilder(
                stream: superbase.from('users').stream(primaryKey: ['uid']).order('name',ascending: true),
                builder: ((context, snapshot){
                  if(!snapshot.hasData || snapshot.hasError){
                    return Center(child: CircularProgressIndicator());
                  }
                  if(snapshot.connectionState != ConnectionState.active){
                    final messages = snapshot.data!;
                    return ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: ((context,index){

                        return chatTile(text: (messages[index]['name']),
                          imageUrl: messages[index]['profile_photo_url'].toString(),
                          status: messages[index]['caption'].toString(),
                          onTap: () async {
                            final user_uid = superbase.auth.currentUser!.id;
                            String roomId = chatRoomId(user_uid.toString(),
                                messages[index]['uid']);


                            final currentUserName = await superbase
                                .from('users')
                                .select('name')
                                .eq('uid', user_uid);
                            print(currentUserName[0]);
                            List<dynamic> list  = await superbase.from('chat_room').select('*')
                                .eq('chatRoomId', roomId);


                            if(list.isEmpty){
                              if(!mounted) return;
                              try{
                                await superbase.from('chat_room').insert({

                                  'chatRoomId': roomId,
                                  'user1': currentUserName[0]['name'].toString(),
                                  'user2': messages[index]['name'],
                                });
                              }catch(error){
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(error.toString())));
                              }
                            }




                            if(!mounted) return;

                            Navigator.push(context,
                                MaterialPageRoute(builder: (context)=>  ChatRoom(
                                  receiverUserMap: messages[index], chatRoomId: roomId,
                                  currentUserName: currentUserName[0]['name'].toString(),


                                ))
                            );

                          },
                        );
                      }),
                    );
                    setState(() {

                    });
                  }

                  final messages = snapshot.data!;
                  return ListView.builder(
                    itemCount: messages.length,
                      itemBuilder: ((context,index){

                        return chatTile(text: (messages[index]['name']),
                            imageUrl: messages[index]['profile_photo_url'].toString(),
                          status: messages[index]['caption'].toString(),
                          onTap: () async {
                            final user_uid = superbase.auth.currentUser!.id;
                            String roomId = chatRoomId(user_uid.toString(),
                                messages[index]['uid']);


                            final currentUserName = await superbase
                                .from('users')
                                .select('name')
                                .eq('uid', user_uid);
                            print(currentUserName[0]);
                            List<dynamic> list  = await superbase.from('chat_room').select('*')
                                .eq('chatRoomId', roomId);


                            if(list.isEmpty){
                              if(!mounted) return;
                              try{
                                await superbase.from('chat_room').insert({

                                  'chatRoomId': roomId,
                                  'user1': currentUserName[0]['name'].toString(),
                                  'user2': messages[index]['name'],
                                });
                            }catch(error){
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(error.toString())));
                              }
                          }




                            if(!mounted) return;

                            Navigator.push(context,
                              MaterialPageRoute(builder: (context)=>  ChatRoom(
                                receiverUserMap: messages[index], chatRoomId: roomId,
                                currentUserName: currentUserName[0]['name'].toString(),


                              ))
                            );

                          },
                        );
                      }),
                  );

              }),
              ),
            ),
          ],
        )
    );
  }
}
