import 'dart:io';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/view/home_page.dart';
import 'package:chat_app/widgets/helping_functions.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../services/auth_service.dart';
import 'login_page.dart';

String? url;

enum Status { LOADED, COMPLETED }

class ProfilrPage extends StatefulWidget {
  String userName;
  String email;
  ProfilrPage({Key? key, required this.email, required this.userName})
      : super(key: key);

  @override
  State<ProfilrPage> createState() => _ProfilrPageState();
}

class _ProfilrPageState extends State<ProfilrPage> {
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Text(
          "Profile",
          style: TextStyle(
              color: Colors.white, fontSize: 27, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
        // backgroundColor: Colors.blue,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 40),
          children: [
            url != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(url!),
                    radius: 100,
                  )
                : Image.asset("assets/images.jpg"),
            const SizedBox(
              height: 15,
            ),
            Text(
              widget.userName,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),
            Divider(
              height: 3,
              thickness: 1,
              color: Colors.grey,
            ),
            ListTile(
              onTap: () {
                nextScreen(context, HomeScreen());
              },
              selectedColor: Theme.of(context).primaryColor,
              // selected: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: Icon(Icons.group),
              title: Text(
                "Groups",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () {},
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: Icon(Icons.person),
              title: Text(
                "Profile",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Logout"),
                        content: Text("Are you sure you want to logout"),
                        actions: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.cancel,
                                color: Colors.red,
                              )),
                          IconButton(
                              onPressed: () async {
                                await authService.signout();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()),
                                    (route) => false);
                              },
                              icon: Icon(
                                Icons.done,
                                color: Colors.green,
                              )),
                        ],
                      );
                    });

                // authService.signout().whenComplete(() {
                //   nextScreenReplace(context, LoginPage());
                // });
              },
              // selectedColor: Theme.of(context).primaryColor,
              // selected: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: Icon(Icons.exit_to_app),
              title: Text(
                "Logout",
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 170, horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              child: url != null
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(url!),
                      radius: 100,
                    )
                  : Image.asset("assets/images.jpg"),
              onTap: () {
                popUpDialog(context);
              },
            ),
            // Icon(
            //   Icons.account_circle,
            //   size: 200,
            //   color: Colors.grey[700],
            // ),
            // ElevatedButton.icon(
            //     style: ElevatedButton.styleFrom(
            //         backgroundColor: Theme.of(context).primaryColor),
            //     onPressed: () {},
            //     icon: Icon(Icons.edit),
            //     label: Text("aaaaa")),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "FullName",
                  style: TextStyle(fontSize: 17),
                ),
                Text(
                  widget.userName,
                  style: TextStyle(fontSize: 17),
                )
              ],
            ),
            Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Email",
                  style: TextStyle(fontSize: 17),
                ),
                Text(
                  widget.email,
                  style: TextStyle(fontSize: 17),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: () {
                    pickImage(ImageSource.gallery).whenComplete(() {
                      DatabaseService(
                              uid: FirebaseAuth.instance.currentUser!.uid)
                          .updateProfile(image!)
                          .whenComplete(() async {
                        QuerySnapshot snapshot = await DatabaseService(
                                uid: FirebaseAuth.instance.currentUser!.uid)
                            .gettingUserData(widget.email);
                        setState(() {
                          url = snapshot.docs[0]['profilePic'];
                          HelpingFunctions.saveProfileImage(url!);
                        });
                      });
                    });
                  },
                  icon: Icon(
                    Icons.photo_camera_back,
                    size: 50,
                  )),
              IconButton(
                  onPressed: () {
                    pickImage(ImageSource.camera).whenComplete(() {
                      DatabaseService(
                              uid: FirebaseAuth.instance.currentUser!.uid)
                          .updateProfile(image!)
                          .whenComplete(() async {
                        QuerySnapshot snapshot = await DatabaseService(
                                uid: FirebaseAuth.instance.currentUser!.uid)
                            .gettingUserData(widget.email);
                        setState(() {
                          url = snapshot.docs[0]['profilePic'];
                          HelpingFunctions.saveProfileImage(url!);
                        });
                      });
                    });
                  },
                  icon: Icon(
                    Icons.camera_alt,
                    size: 50,
                  )),
              IconButton(
                  onPressed: () {
                    print("working ");
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.cancel_outlined,
                    color: Colors.red,
                    size: 50,
                  ))
            ],
          ),
        );
      },
    );
  }

  File? image;
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
}
