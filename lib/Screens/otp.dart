import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app_user/Database.dart';
import 'package:news_app_user/Screens/PageControllerScreen.dart';
import 'package:news_app_user/Screens/RequestDataPage.dart';

import 'package:pinput/pin_put/pin_put.dart';

class OTPScreen extends StatefulWidget {
  final String phone;
  final String name;
  OTPScreen(this.phone, this.name);
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  late String _verificationCode;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: Colors.blueAccent,
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: Column(
        children: [
          Container(
              margin: EdgeInsets.only(top: 40),
              child: Center(
                child: RichText(
                  text: TextSpan(
                      style: TextStyle(
                          color: Theme.of(context).textTheme.subtitle1!.color),
                      children: [
                        TextSpan(
                            text: 'Verifying: ',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w500)),
                        TextSpan(
                            text: '+91 ' + widget.phone.toString(),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ]),
                ),
              )),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: PinPut(
              fieldsCount: 6,
              textStyle: const TextStyle(fontSize: 25.0, color: Colors.black),
              eachFieldWidth: 40.0,
              eachFieldHeight: 55.0,
              focusNode: _pinPutFocusNode,
              controller: _pinPutController,
              submittedFieldDecoration: pinPutDecoration,
              selectedFieldDecoration: pinPutDecoration,
              followingFieldDecoration: pinPutDecoration,
              pinAnimationType: PinAnimationType.fade,
              onSubmit: (pin) async {
                try {
                  await FirebaseAuth.instance
                      .signInWithCredential(PhoneAuthProvider.credential(
                          verificationId: _verificationCode, smsCode: pin))
                      .then((value) async {
                    if (value.user != null) {
                      String uid = FirebaseDb().getuid();
                      await FirebaseDb().adduser(uid, widget.name);
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => PageControllerScreen()),
                          (Route<dynamic> route) => false);
                    }
                  });
                } catch (e) {
                  FocusScope.of(context).unfocus();
                  _scaffoldkey.currentState!
                      .showSnackBar(SnackBar(content: Text('invalid OTP')));
                }
              },
            ),
          ),
          Text('*Please be patient while we process your request*'),
        ],
      ),
    );
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              String uid = FirebaseDb().getuid();
              await FirebaseDb().adduser(uid, widget.name);
              FocusScope.of(context).unfocus();
              _scaffoldkey.currentState!
                  .showSnackBar(SnackBar(content: Text('Login Successful')));
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => PageControllerScreen()),
                  (Route<dynamic> route) => false);
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          FocusScope.of(context).unfocus();
          _scaffoldkey.currentState!.showSnackBar(
              SnackBar(content: Text('An Error Occured Please Retry')));
        },
        codeSent: (String verficationID, resendToken) async {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 120));
  }

  @override
  void initState() {
    super.initState();
    _verifyPhone();
  }
}
