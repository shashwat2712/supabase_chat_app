import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_flutter_application/search.dart';
import 'package:supabase_flutter_application/loginOrRegisterPage.dart';
import 'package:supabase_flutter_application/register_page.dart';
import 'package:supabase_flutter_application/splash_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://kqtawywimyshkecnuken.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtxdGF3eXdpbXlzaGtlY251a2VuIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODc4NTgxMjUsImV4cCI6MjAwMzQzNDEyNX0.IvUAbg6wUF9HtPGEZKqVKxvKxRVLX_3Px8O7rkdE2eU',
  );

  runApp(const MyApp());


}

final superbase = Supabase.instance.client;
//Now we can access this variable 'superbase' throughout the project
// it basically references the servers of supabase

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home:  const SplashScreen(),
    );
  }
}


