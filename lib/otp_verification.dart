import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_flutter_application/home_page.dart';
import 'package:supabase_flutter_application/main.dart';

import 'components/MyButton.dart';
import 'components/squareTile.dart';


class OtpPage extends StatefulWidget {
  final String phone;
  const OtpPage({Key? key, required this.phone}) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
   String code = "";

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    return Scaffold(

      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),

        )),
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


                Text('Enter Your Mobile Number',
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16.0)
                ),


                const SizedBox(height: 40.0,),

                //email textfield

            Pinput(

              length: 6,
              showCursor: true,
              onChanged: (value){
                code = value;
              },
            ),






                const SizedBox(height: 40.0,),

                MyButton(
                  onTap: () async{
                    try{
                      final AuthResponse res = await superbase.auth.verifyOTP(
                        type: OtpType.sms,
                        token: code,
                        phone: widget.phone,
                      );
                      final Session? session = res.session;
                      if (session != null) {
                        if (!mounted) return;
                        // superbase.auth.updateUser({
                        //   'Email': 'shashwatsaivyas@gmail.com'
                        // } as UserAttributes
                        //
                        // );
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()));
                      }
                      if (session == null) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Wrong OTP')));
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
                          SnackBar(content: Text('Error Occurred please retry '),
                            backgroundColor: Theme.of(context).colorScheme.error,
                          ));
                    }

                  },
                  text: 'Verify',
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextButton(onPressed: (){},
                          child: const Text(
                            'Did not get OTP resend?',
                          )),
                    ),
                  ],
                ),

                const SizedBox(height: 10.0,),

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
                      onTap: (){},
                      child: Text('Register Now',
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
