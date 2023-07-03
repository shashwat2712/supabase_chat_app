
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_flutter_application/main.dart';
import 'package:supabase_flutter_application/pages/otp_verification.dart';

import '../components/MyButton.dart';
import '../components/my_textfield.dart';
import '../components/squareTile.dart';


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



  final phoneController = TextEditingController();

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

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  height: 60.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: Colors.white,
                      ),
                      color: Colors.grey.shade200
                  ),
                  child: Row(
                    children: [
                      Container(
                          width: 40.0,
                          child: Text(
                              '+91'
                          )

                      ),
                      SizedBox(width: 5.0,),
                      Text('|',
                        style: TextStyle(
                          fontSize: 33.0,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                      SizedBox(width: 5.0,),
                      Expanded(
                          child: TextField(
                            keyboardType: TextInputType.phone,
                            controller: phoneController,


                            decoration: InputDecoration(
                              hintText: "*********",
                              border: InputBorder.none,

                            )
                            ,
                          )),
                    ],
                  ),
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
                      final phone = '91'+phoneController.text.trim();
                      await superbase.auth.signInWithOtp(phone: phone);


                      if (!mounted) {return;}


                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Check your messages')));
                      final timer = Timer(
                        const Duration(seconds: 3),
                            () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context)=> OtpPage(phone: phone,)));
                        },
                      );
                    }
                    on AuthException catch(error){
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error.message),
                            backgroundColor: Theme.of(context).colorScheme.error,
                          ));
                    }
                    catch(error){
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error Occurred please retry '),
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

                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Google Button
                    SquareTile(imagePath: 'lib/assets/google.png'),

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
