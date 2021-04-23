import 'package:flutter/material.dart';
import 'package:news_app_user/Constants.dart';
import 'package:news_app_user/Screens/otp.dart';
import 'package:news_app_user/Theme.dart';

class OpeningScreen extends StatefulWidget {
  @override
  _OpeningScreenState createState() => _OpeningScreenState();
}

class _OpeningScreenState extends State<OpeningScreen> {
  GlobalKey _formkey = GlobalKey();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeNotifier().darkTheme ? dark : light,
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            //Welcome Text
            SizedBox(
              height: 20,
            ),
            Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/NewsLogo.png'),
                      fit: BoxFit.contain),
                ),
              ),
            ),
            Center(
              child: Text(
                'Please enter your details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                  /*
                      shadows: <Shadow>[
                        Shadow(
                          color: Colors.orange.withOpacity(0.6),
                          blurRadius: 2,
                          offset: Offset(2.0,2.0),
                        ),
                      ],
                       */
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Form(
                key: _formkey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.name,
                              controller: _nameController,
                              style: TextStyle(fontSize: 16),
                              decoration: InputDecoration(
                                enabled: true,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelText: 'Name',
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                labelStyle: TextStyle(fontSize: 24),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.phone,
                              controller: _phoneController,
                              style: TextStyle(fontSize: 16),
                              decoration: InputDecoration(
                                enabled: true,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelText: 'Phone',
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(
                                      top: 20, left: 10, bottom: 20),
                                  child: Text(
                                    '+91 |',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                labelStyle: TextStyle(fontSize: 24),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/HawaMahal.jpg'),
                                fit: BoxFit.fill),
                          ),
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => OTPScreen(
                                        _phoneController.text,
                                        _nameController.text)));
                              },
                              child: Material(
                                elevation: 10,
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  width: 150,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Center(
                                      child: Text(
                                    'Login',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  )),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
