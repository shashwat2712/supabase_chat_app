import 'package:flutter/material.dart';
import 'package:supabase_flutter_application/components/image_chat.dart';
import 'package:supabase_flutter_application/components/message_tile.dart';
import 'package:supabase_flutter_application/main.dart';
import 'package:supabase_flutter_application/upload_message_image.dart';

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

  void onSendImage(String url)async{
      Navigator.push(context, MaterialPageRoute(builder: (context)=> CameraPage(chatRoomID: widget.chatRoomId,)));
  }

  final _message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: StreamBuilder(
          stream: superbase.from('users').stream(primaryKey: ['uid']).eq('uid', widget.receiverUserMap['uid']),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

            if(snapshot.data != null){
              final data = snapshot!.data;
              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data[0]['name'].toString(),
                      style: TextStyle(

                      ),
                    ),
                    Text(data[0]['status'].toString(),
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }
            else{
              return Text(widget.receiverUserMap['name']);
            }
          },

        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed:(){Navigator.pop(context);},
        ),
        backgroundColor: Colors.green,

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
                            return messages[index]['type'].toString() == 'text' ?


                            MessageTile(message: messages[index]['messages'].toString(),
                            sender: messages[index]['created_by'] == superbase.auth.currentUser!.id ? widget.currentUserName :
                                widget.receiverUserMap['name'],
                            sendByMe: messages[index]['created_by'] == superbase.auth.currentUser!.id)



                            :ImageMessage(url: messages[index]['image_url'], sendByMe: messages[index]['created_by'] == superbase.auth.currentUser!.id,
                                sender: messages[index]['created_by'] == superbase.auth.currentUser!.id ? widget.currentUserName:
                                widget.receiverUserMap['name'] );
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
                            onPressed: (){
                              onSendImage(_message.text.trim());
                            },
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
                  const SizedBox(width: 3,),
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
