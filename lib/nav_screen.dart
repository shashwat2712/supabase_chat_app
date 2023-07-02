
import 'package:flutter/material.dart';
import 'package:supabase_flutter_application/home_page.dart';
import 'package:supabase_flutter_application/loginOrRegisterPage.dart';
import 'package:supabase_flutter_application/main.dart';
import 'package:supabase_flutter_application/profile_page.dart';

import 'login_page.dart';


class NavScreen extends StatefulWidget {

  const NavScreen({Key? key}) : super(key: key);

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  int _selectedIndex = 0;
  Future<void> signUserOut() async {
    await superbase.auth.signOut();
    if(!mounted)return;
    Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => const LoginOrRegisterPage()),
          (route) => false,);
  }

  final _screens = [
    const HomePage(),
    const ProfileScreen(name: 'Name',),
    const ProfileScreen(name: '',),

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

      body: Stack(

          children: _screens
              .asMap()
              .map((i, screen) => MapEntry(
            i,
            Offstage(
              offstage: _selectedIndex != i,
              child: screen,

            ),
          )).values.toList()

      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black87,
        elevation: 0,
        showUnselectedLabels: false  ,
        unselectedItemColor: Colors.greenAccent,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        currentIndex: _selectedIndex,
        items: const [

          BottomNavigationBarItem(
              icon: Icon(Icons.travel_explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: 'Explore'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              activeIcon: Icon(Icons.add_circle),
              label: 'Explore'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.library_add_check_outlined),
              activeIcon: Icon(Icons.library_add_check_rounded),
              label: 'Library'
          ),
        ],
      ),
    );
  }
}