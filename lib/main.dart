import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pet_ui/phone_auth.dart';

import 'homeScreen.dart';
import 'screen2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: HomePage(),
    theme: ThemeData(fontFamily: 'Circular'),
    initialRoute: HomeScreen.id,
    routes: {
      HomeScreen.id: (context) => HomeScreen(),
      Screen2.id: (context) => Screen2(),
      PhoneAuth.id: (context) => PhoneAuth()
    },
  ));
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PhoneAuth(),
    );
  }
}
