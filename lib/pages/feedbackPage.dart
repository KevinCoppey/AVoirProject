import 'dart:async';
import 'dart:io';

import 'package:a_voir_app/ui/appBar.dart';
import 'package:a_voir_app/ui/drawerMenu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:flutter_mailer/flutter_mailer.dart';

class FeedbackPage extends StatefulWidget {
  @override
  FeedbackState createState() => FeedbackState();
}

class FeedbackState extends State<FeedbackPage> {
  List<String> attachments = [];
  late String platformResponse;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _removeAttachment(int index) {
    setState(() {
      attachments.removeAt(index);
    });
  }

  final _recipientController = TextEditingController(
    text: 'kevin.coppey28@hotmail.com',
  );

  final _formkey = GlobalKey<FormState>();

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  final _subjectController = TextEditingController(text: '');

  final _bodyController = TextEditingController(
    text: '',
  );

  Future<void> send() async {
    if (attachments.isEmpty) {
      final MailOptions mailOptions = MailOptions(
        body: _bodyController.text,
        subject: _subjectController.text,
        recipients: ['kevin.coppey28@hotmail.com'],
        isHTML: true,
      );
      final MailerResponse response = await FlutterMailer.send(mailOptions);
      switch (response) {
        case MailerResponse.saved:

          /// ios only
          platformResponse = 'mail was saved to draft';
          break;
        case MailerResponse.sent:

          /// ios only
          platformResponse = 'mail was sent';
          break;
        case MailerResponse.cancelled:

          /// ios only
          platformResponse = 'mail was cancelled';
          break;
        case MailerResponse.android:
          platformResponse = 'intent was successful';
          break;
        default:
          platformResponse = 'unknown';
          break;
      }
    } else {
      final MailOptions mailOptions = MailOptions(
          body: _bodyController.text,
          subject: _subjectController.text,
          recipients: ['kevin.coppey28@hotmail.com'],
          isHTML: true,
          attachments: [attachments[0]]);
      final MailerResponse response = await FlutterMailer.send(mailOptions);
      switch (response) {
        case MailerResponse.saved:

          /// ios only
          platformResponse = 'mail was saved to draft';
          break;
        case MailerResponse.sent:

          /// ios only
          platformResponse = 'mail was sent';
          break;
        case MailerResponse.cancelled:

          /// ios only
          platformResponse = 'mail was cancelled';
          break;
        case MailerResponse.android:
          platformResponse = 'intent was successful';
          break;
        default:
          platformResponse = 'unknown';
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: DrawerMenu(),
      appBar: FirebaseAuth.instance.currentUser != null
          ? BaseAppBar(appBar: AppBar(), scaffoldKey: _scaffoldKey)
          : null,
      backgroundColor: Color(0xff643165),
      body: SingleChildScrollView(
          child: Form(
        key: _formkey,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 70, bottom: 20),
              child: Text(
                'Title',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20.0,
                    color: Color(
                      0xffffffff,
                    )),
              ),
            ),
            Container(
              padding:
                  EdgeInsets.only(bottom: 20, top: 1, left: 100, right: 100),
              child: TextFormField(
                validator: (value) {
                  //handle errors with Password submission
                  if (value == null || value.isEmpty) {
                    return "Please enter a title";
                  }
                  return null;
                },
                controller: _subjectController,
                maxLength: 20,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    counterStyle: TextStyle(color: Colors.white),
                    hintStyle: TextStyle(color: Color(0xff643165)),
                    enabledBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    labelStyle: TextStyle(color: Colors.white),
                    hintText: ''),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: Text(
                'Description',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20.0,
                    color: Color(
                      0xffffffff,
                    )),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 1, left: 100, right: 100),
              child: TextFormField(
                validator: (value) {
                  //handle errors with Password submission
                  if (value == null || value.isEmpty) {
                    return "Please enter a description";
                  }
                  return null;
                },
                controller: _bodyController,
                maxLines: null,
                maxLength: 300,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    counterStyle: TextStyle(color: Colors.white),
                    hintStyle: TextStyle(color: Color(0xff643165)),
                    enabledBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    labelText: '',
                    labelStyle: TextStyle(color: Colors.white),
                    hintText: ''),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 50, bottom: 20),
              child: Text(
                'Attach a screenshot \n (optional)',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20.0,
                    color: Color(
                      0xffffffff,
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Wrap(
                children: <Widget>[
                  for (var i = 0; i < attachments.length; i++)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                            flex: 0,
                            child: Container(
                              margin: EdgeInsets.all(10),
                              width: 100,
                              height: 100,
                              child: Image.file(File(attachments[i]),
                                  fit: BoxFit.cover),
                            )),
                        IconButton(
                          icon: Icon(Icons.remove_circle),
                          onPressed: () => {_removeAttachment(i)},
                        )
                      ],
                    ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: IconButton(
                icon: Icon(Icons.add_a_photo),
                iconSize: 30,
                color: Colors.white,
                onPressed: _openImagePicker,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 50, horizontal: 50),
              child: Container(
                height: 50,
                width: 120,
                child: Center(
                  child: RoundedLoadingButton(
                    color: Color(0xffa456a7),
                    child: Text('Submit',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                    controller: _btnController,
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        // If the form is valid, display a snackbar.

                        ScaffoldMessenger.of(context).showSnackBar(
                          new SnackBar(
                              duration: new Duration(seconds: 1),
                              content: new Row(
                                children: [
                                  new CircularProgressIndicator(),
                                  new Text("   Redirecting...")
                                ],
                              )),
                        );
                        _buttonReset();
                        send();
                      } else {
                        _buttonFail();
                        _buttonReset();
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  void _buttonFail() async {
    Timer(Duration(seconds: 1), () {
      _btnController.error();
    });
  }

  void _buttonReset() async {
    Timer(Duration(seconds: 3), () {
      _btnController.reset();
    });
  }

  Future _openImagePicker() async {
    if (attachments.length <= 0) {
      final pick = await ImagePicker().getImage(source: ImageSource.gallery);
      if (pick != null) {
        setState(() {
          attachments.add(pick.path);
        });
      }
    } else {
      AlertDialog alert = AlertDialog(
        title: Text("Number of screenshots excedeed"),
        content: Text(
          "You cannot add more screenshots. Please delete the screenshot and choose another one.",
          style: TextStyle(color: Color(0xffa456a7)),
        ),
        actions: [
          TextButton(
              child: Text("OK", style: TextStyle(color: Color(0xffa456a7))),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }
}