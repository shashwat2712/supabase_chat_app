import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter_application/chatRoom_page.dart';
import 'package:supabase_flutter_application/components/chatTile.dart';

import 'components/bullets.dart';
import 'loginOrRegisterPage.dart';
import 'main.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          actions:  [

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(Icons.notification_add_outlined),
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
        body: StreamBuilder(
          stream: superbase.from('users').stream(primaryKey: ['uid']),
          builder: ((context, snapshot){
            if(snapshot.connectionState != ConnectionState.active){
              return const Center(child: CircularProgressIndicator(),);
            }
            if(!snapshot.hasData || snapshot.hasError){
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please Try Again')));
              return Container();
            }
            final messages = snapshot.data!;
            return ListView.builder(
              itemCount: messages.length,
                itemBuilder: ((context,index){

                  return chatTile(text: (messages[index]['name']),
                      email: 'shashwat',
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
        )
    );
  }
}
