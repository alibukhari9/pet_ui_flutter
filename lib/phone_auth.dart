import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class PhoneAuth extends StatefulWidget {
  static String id = 'phone_auth';
  @override
  _PhoneAuthState createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  String verID;
  UserCredential userCredential;
  TextEditingController textEditingController = new TextEditingController();

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult result = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final facebookAuthCredential =
        FacebookAuthProvider.credential(result.accessToken.token);

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(100),
        child: Column(
          children: [
            GestureDetector(
              // onTap: () async {
              //   FirebaseAuth firebaseAuth = FirebaseAuth.instance;
              //   userCredential =
              //       await firebaseAuth.createUserWithEmailAndPassword(
              //           email: 'alibukhari9@yahoo.com',
              //           password: 'incorrect58');
              //   await firebaseAuth.verifyPhoneNumber(
              //       phoneNumber: '+923222777400',
              //       verificationCompleted:
              //           (PhoneAuthCredential phoneAuthCredential) {},
              //       verificationFailed: (FirebaseAuthException authException) {
              //         print('Error : ' + authException.code);
              //       },
              //       codeSent: (String verificationID, int resend) {
              //         verID = verificationID;
              //       },
              //       timeout: Duration(seconds: 60),
              //       codeAutoRetrievalTimeout: (String verificationId) {});
              // },
              onTap: () async {
                FirebaseAuth firebaseAuth = FirebaseAuth.instance;

                userCredential = await signInWithFacebook();
                await firebaseAuth.verifyPhoneNumber(
                    phoneNumber: '+923222777400',
                    verificationCompleted:
                        (PhoneAuthCredential phoneAuthCredential) {},
                    verificationFailed: (FirebaseAuthException authException) {
                      print('Error : ' + authException.code);
                    },
                    codeSent: (String verificationID, int resend) {
                      verID = verificationID;
                    },
                    timeout: Duration(seconds: 60),
                    codeAutoRetrievalTimeout: (String verificationId) {});
              },
              child: Container(
                color: Colors.blue,
                child: Text(
                  'Verify',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            TextField(
              controller: textEditingController,
            ),
            GestureDetector(
              onTap: () {
                PhoneAuthCredential phoneAuthCredential =
                    PhoneAuthProvider.credential(
                        verificationId: verID,
                        smsCode: textEditingController.text.toString());
                userCredential.user.linkWithCredential(phoneAuthCredential);
              },
              child: Container(
                color: Colors.yellow,
                child: Text(
                  'Code Check',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
