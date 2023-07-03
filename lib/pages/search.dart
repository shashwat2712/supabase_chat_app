import 'package:flutter/material.dart';
import 'package:supabase_flutter_application/components/squareTile.dart';

import 'chatRoom_page.dart';
import '../components/chatTile.dart';
import 'loginOrRegisterPage.dart';
import '../main.dart';
class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Map<String,dynamic>> data = [];

  final _searchController = TextEditingController();

  void onSearch()async{
    setState(() {
      _searchController.text;
    });



  }


  Future<void> signUserOut() async {
    await superbase.auth.signOut();
    if(!mounted)return;
    Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => const LoginOrRegisterPage()),
          (route) => false,);
  }
  String chatRoomId(String user1, String user2){
    if(user1[0].toLowerCase().codeUnits[0]>user2[0].toLowerCase().codeUnits[0]){
      return "$user1$user2";
    }
    else{
      return '$user2$user1';
    }
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
      body: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.verified_rounded),
              Text('Please enter the full name'),
            ],
          ),
          SizedBox(
            height: size.height/60,
          ),
          Container(
            height: size.height/14,
            width: size.width/0.9,
            alignment: Alignment.center,
            child: Container(
              height: size.height/14,
              width: size.width/1.095,
              decoration: BoxDecoration(
                color: Colors.green,
                border: Border.all(color: Colors.black38),
                borderRadius: BorderRadius.circular(10),

              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        fillColor: Colors.grey[300],
                        filled: true,
                        prefixIcon: Icon(Icons.search),


                        hintText: 'Search Users',
                        border: OutlineInputBorder(

                          borderRadius: BorderRadius.circular(10),
                        ),

                      ),
                    ),
                  ),
                  Container(
                    child: IconButton(
                      onPressed: onSearch,
                      icon: const Icon(Icons.send_sharp),
                    ),

                  )
                ],
              ),
            ),
          ),
         SizedBox(
           height: size.width/30,
         ),

          Expanded(
            child: StreamBuilder(
              stream: _searchController.text.isEmpty ? superbase.from('users').stream(primaryKey: ['uid']).order('name',ascending: true) : superbase.from('users').stream(primaryKey: ['uid']).order('name',ascending: true)
                  .eq('name', _searchController.text.toString())


              ,

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
          )
        ],
      )
    );
  }
}
