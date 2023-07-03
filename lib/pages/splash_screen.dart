import 'package:flutter/material.dart';
import 'package:supabase_flutter_application/pages/home_page.dart';
import 'package:supabase_flutter_application/pages/loginOrRegisterPage.dart';
import 'package:supabase_flutter_application/main.dart';
import 'package:supabase_flutter_application/pages/nav_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _redirect();
  }
  Future<void> _redirect() async{
    await Future.delayed(Duration.zero);
    //supabase is just variable which is Supabase.instance.client
    //which we declared in main.dart.


    if(!mounted) return;

    final session = superbase.auth.currentSession;
    if(session != null){
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context)=> const HomePage())
      );
    }
    else{
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context)=> LoginOrRegisterPage())
      );

    }



  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
        ),
      ),
    );
  }
}
