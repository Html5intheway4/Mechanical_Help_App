import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mechanical_help/main.dart';

class LoggedInScreen extends StatelessWidget{
  const LoggedInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: Center(

        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(user!=null)...[
                FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .get(),
                    builder: (context,snapshot) {
                      if(snapshot.connectionState== ConnectionState.waiting){
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasData&& snapshot.data !=null){
                        final userData = snapshot.data!.data() as Map<String,dynamic>?;
                        if (userData != null){
                        return Column(
                          children: [
                            Text('Hello, ${userData['name']}'),
                            Text('Email, ${userData['email']}'),
                            Text('Phone, ${userData['phone']}'),
                          ],
                        );}
                      else {
                        // No user data found (handle this case)
                        return const Text('No user data found. Please update your profile.');
                      }
                    }else if (snapshot.hasError) {
                        return Text('Error, ${snapshot.error}');
                      }else{
                        return const Text('No user data found');
                      }
                    },
                      ),
                // Display user information
                // Text('Hello, ${user.email}'),
                const SizedBox(height: 20),
                // Add buttons or functionalities for logged-in user
                ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      if(!context.mounted)return;
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                          builder: (context)=> const HomeScreen()));
                    },
                    child: const Text('Sign Out'),
                ),
              ],
              if (user == null) const Text('You are not signed in'),
            ],
          ),
        ),
      ),
    );
  }
}