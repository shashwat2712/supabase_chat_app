import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_flutter_application/home_page.dart';

import 'components/MyButton.dart';
import 'components/my_textfield.dart';
import 'components/squareTile.dart';
import 'main.dart';
import 'otp_verification.dart';


class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({
    super.key,
    required this.onTap
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  //all the controller information

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  final nameController = TextEditingController();

  final phoneController = TextEditingController();

  final hometownController = TextEditingController();

  ////////////////////////////////////////////////////////

  Future<void> _recordData(String phone) async {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Please Wait while we are registering you'),
          backgroundColor: Colors.green[500],
        ));
    try{
      await superbase.from('users').insert({
        'phone': phone,
        'uid': superbase.auth.currentUser!.id.toString(),
        'name': nameController.text.trim(),
        'status': 'Unavailable'
      });
    }catch(error){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error Occurred please retry : $error'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ));
    }
  }

  void signUserUp() async {

    // // showing load circle
    // showDialog(
    //   context: context,
    //   builder: (context){
    //     return const Center(
    //       child: CircularProgressIndicator(),
    //     );
    //   },
    // );


    if(phoneController.text.isEmpty || nameController.text.isEmpty
      || passwordController.text.isEmpty ||confirmPasswordController.text.isEmpty
        || emailController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Please Enter all the entries'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ));
      return;
    }

    if(passwordController.text != confirmPasswordController.text){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('confirmPassword and Password does not match'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ));
      return;
    }





    try{
      final password = passwordController.text.trim();
      final phone = '+91${phoneController.text.trim()}';
      final email = emailController.text.trim();

      final AuthResponse res = await superbase.auth.signUp(password: password,email: email,
          emailRedirectTo: 'io.supabase.flutterquickstart://login-callback/'
      );
      final Session? session = res.session;



      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Check your messages')));
      if(session != null){

        await _recordData(phone);


        if(!mounted) return;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));

      }
    }on AuthException catch(error){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ));
    }
    catch(error){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error Occurred please retry : ${error}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ));
    }




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
                  size: 50,
                ),


                const SizedBox(height: 25.0,),


                Text('Welcome to our services',
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16.0)
                ),


                const SizedBox(height: 25.0,),

                //email textfield

                MyTextField(
                  controller: nameController,
                  hintText: "Name",
                  obscureText: false,
                ),

                const SizedBox(height: 10.0,),

                //email textfield

                MyTextField(
                  controller: phoneController,
                  hintText: "Contact Number",
                  obscureText: false,
                ),

                const SizedBox(height: 10.0,),

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

                MyTextField(
                  controller: confirmPasswordController,
                  hintText: "Confirm Password",
                  obscureText: true,
                ),

                const SizedBox(height: 25.0,),

                MyButton(
                  onTap: signUserUp,
                  text: "Register Now",
                ),

                const SizedBox(height: 25.0,),

                Row(
                  children: [
                    Expanded(child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                    )),

                    const Text('Or Continue with'),

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
                const SizedBox(height: 25.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text('Login Here',
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
