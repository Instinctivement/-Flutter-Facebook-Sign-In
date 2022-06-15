import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Facebook Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? _userData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        elevation: 0,
        title: Text(
            'Facebook (logged ' + (_userData == null ? 'out' : 'in') + ')'),
        centerTitle: true,
        actions: [
          _userData != null
              ? TextButton(
                  onPressed: () async {
                    await FacebookAuth.i.logOut();

                    setState(() {
                      _userData = null;
                    });
                  },
                  child: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : Container(),
        ],
      ),
      backgroundColor: Colors.grey.shade900,
      body: _userData == null
          ? Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  const FlutterLogo(
                    size: 120,
                  ),
                  const Spacer(),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Hey There, \nWelcome Back',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Login to your account to continue',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.black,
                        minimumSize: const Size(double.infinity, 50)),
                    onPressed: () async {
                      final result = await FacebookAuth.i
                          .login(permissions: ['email', 'public_profile']);

                      if (result.status == LoginStatus.success) {
                        final userData = await FacebookAuth.i.getUserData(
                          fields: "name,email,picture.width(200)",
                        );

                        setState(() {
                          _userData = userData;
                        });
                      } else {
                        print("Something Went Wrong");
                      }
                    },
                    icon: const Icon(
                      Icons.facebook,
                      color: Colors.red,
                      size: 36,
                    ),
                    label: const Text('Sign Up with Facebook'),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  RichText(
                      text: const TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(color: Colors.white),
                          children: [
                        TextSpan(
                            text: 'Log in',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.white))
                      ])),
                  const Spacer(),
                ],
              ),
            )
          : Container(
              alignment: Alignment.center,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Profile",
                      style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    CircleAvatar(
                      radius: 80,
                      backgroundImage:
                          NetworkImage(_userData!['picture']['data']['url']),
                      backgroundColor: Colors.amber,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Name: " + _userData!['name'],
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Email: " + _userData!['email'],
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ]),
            ),
    );
  }
}
