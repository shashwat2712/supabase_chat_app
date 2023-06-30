import 'package:flutter/material.dart';

class chatTile extends StatelessWidget {
  final String text;
  final String email;
  final Function()? onTap;

  const chatTile({Key? key,
    required this.text,
    required this.email,
    this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ListTile(
      onTap: onTap ,
      leading: CircleAvatar(
        child: ClipRRect(child: Image.asset('lib/assets/person-icon.png')),
      ),
      title: Text(text),
      subtitle: Text('Live life king Size'),
      trailing: Icon(Icons.message),
    );
  }
}
