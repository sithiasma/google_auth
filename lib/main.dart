// ignore_for_file: depend_on_referenced_packages, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
FirebaseAuth _auth = FirebaseAuth.instance;

Future<UserCredential?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);

    return authResult;
  } catch (error) {
    // Handle error
    return null;
  }
}

Future<void> signOutGoogle() async {
  await _googleSignIn.signOut();
  await _auth.signOut();
}

// GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>[
//   'email',
//   'https://www.googleapis.com/auth/contacts.readonly'
// ]);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBHgF4AD2xjMu4WNOgcW0ALAQ5P5euXDxE",
          authDomain: "authentication-d3286.firebaseapp.com",
          projectId: "authentication-d3286",
          storageBucket: "authentication-d3286.appspot.com",
          messagingSenderId: "838473376067",
          appId: "1:838473376067:web:b5409882a4fdac8e2c4ff6",
          measurementId: "G-KZNVSCD552"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Google Authentication',
      debugShowCheckedModeBanner: false,
      home: SignInPage(),
    );
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  GoogleSignInAccount? _currentUser;

  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        print("User is already authenticated");
      }
    }
        // as void Function(GoogleSignInAccount? event)?
        );
    _googleSignIn.signInSilently();
  }

  // Future<void> handleSignIn() async {
  //   try {
  //     await _googleSignIn.signIn();
  //   } catch (error) {
  //     print("Sign in error : " + error.toString());
  //   }
  // }

  // Future<void> handleSignOut() => _googleSignIn.disconnect();

  Widget buildBody() {
    GoogleSignInAccount? user = _currentUser;
    if (user != null) {
      return Column(
        children: [
          SizedBox(
            height: 90,
          ),
          GoogleUserCircleAvatar(identity: user),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              user.displayName ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
              child: Text(
            user.email,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          )),
          SizedBox(
            height: 40,
          ),
          ElevatedButton(
            onPressed: signOutGoogle,
            child: Text("Sign Out"),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          SizedBox(
            height: 90,
          ),
          Center(
            child: Image.asset(
              "assets/images/google_large.png",
              height: 200,
              width: 200,
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Welcome to Google Authentication",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Center(
            child: Container(
              width: 250,
              child: ElevatedButton(
                onPressed: signInWithGoogle,
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/images/google.png",
                        height: 20,
                        width: 20,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text("Google Sign In")
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Container(child: buildBody()),
    );
  }
}
