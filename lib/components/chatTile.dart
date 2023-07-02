import 'package:flutter/material.dart';

class chatTile extends StatelessWidget {
  final String text;
  final String imageUrl;
  final Function()? onTap;
  final String status;

  const chatTile({Key? key,
    required this.text,
    required this.imageUrl,
    this.onTap, required this.status
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(imageUrl);
    final size = MediaQuery.of(context).size;
    return ListTile(
      onTap: onTap ,
      leading: ClipRRect(
          borderRadius: BorderRadius.circular(100),
        child: CircleAvatar(
          radius: 20,
          child: Image.network(imageUrl)
        ),
      ),
      title: Text(text),
      subtitle: Text(status),
      trailing: Icon(Icons.message,),
    );
  }
}
