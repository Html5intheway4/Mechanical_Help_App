import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mechanical_help/sign_in_screen.dart';
import 'package:mechanical_help/sign_up_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'logged_in_screen.dart';
<<<<<<< HEAD
=======
// Hello Github
>>>>>>> d323fdd (First Commit)



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(), // Use HomeScreen as the home widget
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Mechanical Help'),
          ),
          body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot){
              if (snapshot.hasData){
                //User is logged in
                return const LoggedInScreen(); // Replace with your user profile Screen
              } else{
                //User is not logged in
                return Scaffold(
                  body:  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (user!=null) Text('Welcome,${user.email}!'),
                        const Text('Welcome to Mechanical Help!'),
                        const SizedBox(height: 20),
                        ElevatedButton(onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context)=> const SignUpScreen()));
                        } , child: const Text('Sign Up'), ),
                        ElevatedButton(
                          onPressed: ()=> Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context)=> const SignInScreen(),),
                          ), child: const Text('Sign In'),),
                        ElevatedButton(
                          onPressed: () async {
                            User? user = await singInWithGoogle();
                            if (user!= null){
                              if (context.mounted){
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context)=> const LoggedInScreen()),);
                              }
                            }

                          }, child: const Text('Sign In with Google'),),
                      ],
                    ),

                  ),
                );
              }
            },
          )

      ),
    );
  }
  Future<User?> singInWithGoogle() async{
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount!= null){
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      return userCredential.user;
    }
    return null;
    }
  }






