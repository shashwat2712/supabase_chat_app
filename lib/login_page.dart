
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_flutter_application/home_page.dart';
import 'package:supabase_flutter_application/main.dart';
import 'package:supabase_flutter_application/otp_verification.dart';

import 'components/MyButton.dart';
import 'components/my_textfield.dart';
import 'components/squareTile.dart';


class LoginPage extends StatefulWidget {
  final Function()? onTap;
  LoginPage({
    super.key,
    required this.onTap
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {



  final emailController = TextEditingController();

  final passwordController = TextEditingController();


  void signUserIn() async {

    // showing load circle
    showDialog(
      context: context,
      builder: (context){
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );


  }

  //Error Message to user
  void showErrorMessage(String message){
    showDialog(context: context,
      builder: (context) {
        return AlertDialog(title: Text(message),);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children:  [
                const SizedBox(height: 50.0,),


                const Icon(
                  Icons.lock,
                  size: 100,
                ),


                const SizedBox(height: 50.0,),


                Text('Welcome back',
                style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16.0)
                ),


                const SizedBox(height: 25.0,),

                  //email textfield

                MyTextField(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
                ),

                const SizedBox(height: 10.0,),
                MyTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                ),
                const SizedBox(height: 10.0,),




                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextButton(onPressed: (){},
                          child: const Text(
                            'Forget Password',
                          )),
                    ),
                  ],
                ),

                const SizedBox(height: 10.0,),

                MyButton(
                  onTap: ()async{
                    try{
                      final email = emailController.text.trim();
                      final AuthResponse res = await superbase.auth.signInWithPassword(
                        email: email,
                        password: passwordController.text.trim(),
                      );
                      final Session? session = res.session;
                      if (session != null) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Successfully logged in')));
                        final timer = Timer(
                          const Duration(seconds: 2),
                              () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context)=>const HomePage()));
                          },
                        );
                      }
                    }
                    on AuthException catch(error){
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error.message),
                            backgroundColor: Theme.of(context).colorScheme.error,
                          ));
                    }
                    catch(error){
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: const Text('Error Occurred please retry '),
                            backgroundColor: Theme.of(context).colorScheme.error,
                          ));
                    }
                  },
                  text: 'Sign In',
                ),

                const SizedBox(height: 25.0,),

                Row(
                  children: [
                    Expanded(child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                    )),

                    Text('Or Continue with'),

                    Expanded(child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                    )),
                  ],
                ),

                const SizedBox(height: 25.0,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Google Button
                    GestureDetector(
                        child: SquareTile(imagePath: 'lib/assets/google.png')),

                    SizedBox(width: 25.0,),

                    //Apple Button
                    SquareTile(imagePath: 'lib/assets/apple.png',)
                  ],
                ),
                SizedBox(height: 25.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Not a member?'),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text('Register Now',
                        style: TextStyle(
                          color: Colors.blue,
                      ),),
                    )
                  ],
                )
              ],

            ),
          ),
        ),
      ),

    );
  }
}
