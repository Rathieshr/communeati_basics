import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {

  Login({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();

  Future<bool>loginUser(String phone,BuildContext context) async{
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.verifyPhoneNumber(phoneNumber: '+91'+ phone,
      verificationCompleted: (AuthCredential credential) async{
        Navigator.of(context).pop();
        // AuthResult result = await _auth.signInWithCredential(credential);
        // FirebaseUser user = result.user;
        // if(user != null){
        //   Navigator.push(context, MaterialPageRoute(
        // builder: (context) => HomeScreen(user: user,)
        // ));
        // }else{
        //   print("Error");
      },
      //This callback would gets called when verification is done auto maticlly
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }},
      codeSent: (String verificationId, int resendToken) async {
        // Update the UI - wait for the user to enter the SMS code
        displayBottomSheet(context);
        String smsCode = _codeController.text;
        // Create a PhoneAuthCredential with the code
        PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: verificationId,smsCode: smsCode);

        // Sign the user in (or link) with the credential
        await auth.signInWithCredential(phoneAuthCredential);
      }, timeout: const Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-resolution timed out...
      },);
  }

  void displayBottomSheet(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: false,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        builder: (ctx) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
                margin: const EdgeInsets.only(top: 40, bottom: 40, left: 20, right: 20),
                child: Wrap(
                  children: <Widget> [
                    Text("Verify",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 40),
                    TextField(
                      controller: _codeController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(style: BorderStyle.solid)),
                          hintText: 'Enter OTP'),
                      maxLength: 6,
                      maxLengthEnforced: true,
                      showCursor: false,
                      keyboardType: TextInputType.number,
                    ),
                    Text("Resend code",textAlign: TextAlign.end,style: TextStyle(color: Colors.lightGreen),)
                  ],
                )
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: new Container(
        alignment: Alignment.center,
        margin:
        const EdgeInsets.only(top: 180, bottom: 60, left: 40, right: 40),
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/communeatitrim.png',
              width: 300,
              height: 100,
            ),
            SizedBox(height: 40),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(style: BorderStyle.solid)),
                hintText: 'Enter mobile number',
              ),
              maxLines: 1,
              maxLength: 10,
              maxLengthEnforced: true,
              showCursor: false,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 200),
            SizedBox(
              height: 80,
              width: 80,
              child: FloatingActionButton(
                onPressed: () => {loginUser(_phoneController.text, context)},
                tooltip: 'Login',
                child: Icon(
                  Icons.arrow_forward,
                  size: 40.0,
                ),
                splashColor: Colors.blue,
              ), // This trailing comma makes auto-formatting nicer for build methods.
            ),
          ],
        ),
      ),
    );
  }
}
