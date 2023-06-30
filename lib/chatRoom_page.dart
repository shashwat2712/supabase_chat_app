import 'package:flutter/material.dart';
import 'package:supabase_flutter_application/components/message_tile.dart';
import 'package:supabase_flutter_application/main.dart';

class ChatRoom extends StatefulWidget {
  final Map<String,dynamic> receiverUserMap;
  final String currentUserName;

  final String chatRoomId;
  const ChatRoom({Key? key, required this.receiverUserMap,required this.chatRoomId, required this.currentUserName}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}


class _ChatRoomState extends State<ChatRoom> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }



  void onSendMessage(String messages)async{
    try{
      if(superbase.auth.currentUser != null){
        final chatRoomId = await superbase.from('chats_ID').insert({
          'messages': _message.text,
          'created_by': superbase.auth.currentUser!.id,
          'chatRoomID': widget.chatRoomId,
        });

      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please try again')));
      }
    }
    catch(error){
      ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(error.toString())));
    }
  }

  final _message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text(widget.receiverUserMap['name']),

      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: superbase.from('chats_ID').stream(primaryKey: ['id']).eq('chatRoomID', widget.chatRoomId ),
                builder: (context, snapshot){

                  if(snapshot.hasData){
                    final messages = snapshot.data!;

                    return ListView.builder(
                      itemCount: messages.length,
                        itemBuilder: (context,index){

                          // return Text(messages[index]['messages'].toString());
                          if(superbase.auth.currentUser != null){
                            return MessageTile(message: messages[index]['messages'].toString(),
                            sender: 'status',
                            sendByMe: messages[index]['created_by'] == superbase.auth.currentUser!.id);
                          }
                          else{
                            return Container();
                          }
                      }
                    );
                  }
                  else{
                    return Container();
                  }

                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black12
                        ),
                        borderRadius: BorderRadius.circular(20)

                    ),
                    height: size.height/12,
                    width: size.width/1.25,
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: TextField(
                              controller: _message,
                              decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.transparent),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color:Colors.transparent)
                                ),

                                hintText: 'Send Message',
                              ),


                              obscureText: false,
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: (){},
                            icon: const Icon(Icons.camera_alt)),
                        IconButton(
                            onPressed: (){
                              onSendMessage(_message.text.trim());
                              _message.clear();
                            },
                            icon: const Icon(Icons.send)),


                      ],
                    ),
                  ),
                  SizedBox(width: 3,),
                  CircleAvatar(
                    backgroundColor: Colors.green,
                    radius: size.height/27,
                    child: const Icon(Icons.phone),
                  )
                ],
              ),
            ),
          ],
        ),
      ),

    );
  }
}
