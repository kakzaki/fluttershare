import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isAuth = false;
  GoogleSignIn googleSignIn;

  login() {
    print('logging in');
    googleSignIn.signIn();
  }

  logout() {
    googleSignIn.signOut();
  }

  @override
  void initState() { 
    super.initState();
    googleSignIn = GoogleSignIn();
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account);
    }, onError: (err) {
      print('Error signing in: $err');
    });
    // Reauthenticate user when app is opened..
    googleSignIn.signInSilently(suppressErrors: false)
      .then((account) {
        handleSignIn(account);
      }).catchError((err) {
        print('Error signing in: $err');
      });
  }

  handleSignIn(GoogleSignInAccount account) {
    if (account != null) {
        print('User signed in: $account');
        setState(() {
          _isAuth = true;
        });
      } else {
        setState(() {
          _isAuth = false;
        });
      }
  }
  
  Widget _buildAuthScreen() {
    return RaisedButton(
      onPressed: logout,
      child: Text('Logout'),
    );
  }

  Scaffold _buildUnAuthScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).accentColor,
              Theme.of(context).primaryColor,
            ],
          )
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'FlutterShare',
              style: TextStyle(
                fontFamily: "Signatra",
                fontSize: 90.0,
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: login,
              child: Container(
                width: 260.0,
                height: 60.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/google_signin_button.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isAuth ? _buildAuthScreen() : _buildUnAuthScreen();
  }
}
