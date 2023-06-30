import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {
  final String message;
  final String sender;
  final bool sendByMe;
  const MessageTile({Key? key, required this.message, required this.sender, required this.sendByMe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 4,bottom: 4,left: sendByMe ? 0:24,right:  sendByMe ? 24:0
      ),
      child: Container(
        margin: sendByMe ? const EdgeInsets.only(left: 50):const EdgeInsets.only(right: 50),
        alignment:  sendByMe ? Alignment.centerRight:Alignment.centerLeft,
        padding: const EdgeInsets.only(
          top : 17,bottom: 17,left: 20,right: 20
        ),
        decoration: BoxDecoration(
          borderRadius:  sendByMe ? const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20)
          ):
          const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20)
          ),
          color: sendByMe ? Theme.of(context).primaryColor : Colors.grey[700]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(sender.toUpperCase(),
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: -0.5
              ),
            ),
            const SizedBox(height:  8,),
            Text(message,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.white
              ),

            ),

          ],
        ),

      ),
    );
  }
}
