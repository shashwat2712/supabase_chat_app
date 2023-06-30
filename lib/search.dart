import 'package:flutter/material.dart';

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

  void onSearch()async{



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
      body: Column(
        children: [
          SizedBox(
            height: size.height/20,
          ),
          Container(
            height: size.height/14,
            width: size.width,
            alignment: Alignment.center,
            child: Container(
              height: size.height/14,
              width: size.width/1.2,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  icon: const Icon(Icons.search),
                  hintText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),

                ),
              ),
            ),
          ),
         SizedBox(
           height: size.width/30,
         ),
         ElevatedButton(onPressed: (){},
             child: const Text('Search')
         )
        ],
      )
    );
  }
}
