import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_mate/constants.dart';
import 'package:money_mate/components/reusable_card.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:money_mate/services/firebase.dart';
import 'package:money_mate/models/models.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserData userData = UserData(
    uid: 'initial value',
    userName: 'initial value',
    email: 'initial value',
    imageUrl: 'initial value',
  );

  bool isLoading = true;
  late ScaffoldMessengerState _scaffoldMessengerState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Retrieve ScaffoldMessengerState after the widget has finished building
      _scaffoldMessengerState = ScaffoldMessenger.of(context);
      FirebaseServices.getUserData(userData).then((_) {
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  void editProfile() async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditProfileDialog(
          uid: userData.uid,
          userName: userData.userName,
          email: userData.email,
          imageUrl: userData.imageUrl,
          onUpdateProfile: updateProfile,
        );
      },
    );
    if (result != null) {
      setState(() {
        userData.userName = result['userName'];
        userData.email = result['email'];
        userData.imageUrl = result['imageUrl'];
      });
    }
  }

  void updateProfile(Map<String, dynamic> updatedData) {
    setState(() {
      userData.userName = updatedData['userName'];
      userData.email = updatedData['email'];
      userData.imageUrl = updatedData['imageUrl'];
    });

    _scaffoldMessengerState.showSnackBar(
      SnackBar(
        content: Text('Profile updated successfully'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
        // action: SnackBarAction(
        //   label: 'Dismiss',
        //   textColor: Colors.white,
        //   onPressed: () {
        //     _scaffoldMessengerState.hideCurrentSnackBar();
        //   },
        // ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Profile'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ReusableCard(
                        colour: kNavbarColor,
                        aspectRatio: 1,
                        cardChild: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 70.0,
                              backgroundImage:
                                  userData.imageUrl != 'initial value'
                                      ? NetworkImage(userData.imageUrl)
                                      : AssetImage("images/dp.png")
                                          as ImageProvider<Object>?,
                            ),
                            SizedBox(height: 24.0),
                            Text(
                              userData.userName,
                              style: TextStyle(
                                  fontSize: 24.0, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              userData.email,
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        width: 160,
                        height: 45,
                        child: ElevatedButton.icon(
                          onPressed: editProfile,
                          icon: Icon(Icons.edit),
                          label: Text('Edit Profile'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            textStyle: TextStyle(fontSize: 18.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Set your desired radius here
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 12.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        width: 160,
                        height: 45,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            try {
                              await FirebaseAuth.instance.signOut();
                              // Navigate to the login screen or any other desired screen
                              // after successful logout
                              Navigator.pushReplacementNamed(context, '/login');
                            } catch (e) {
                              print(e.toString());
                              // Handle any errors that occur during logout
                            }
                          },
                          icon: Icon(Icons.logout),
                          label: Text('Logout'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            textStyle: TextStyle(fontSize: 18.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Set your desired radius here
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 12.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class EditProfileDialog extends StatefulWidget {
  final String uid;
  final String userName;
  final String email;
  final String imageUrl;
  final Function(Map<String, dynamic>) onUpdateProfile;

  EditProfileDialog({
    required this.uid,
    required this.userName,
    required this.email,
    required this.imageUrl,
    required this.onUpdateProfile,
  });

  @override
  _EditProfileDialogState createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    userNameController.text = widget.userName;
    emailController.text = widget.email;
  }

  Future<void> selectImage() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> saveProfile() async {
    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // Show a loading dialog
          return Center(
            child: SpinKitFadingCircle(
              color: Colors.blue,
              size: 50.0,
            ),
          );
        },
      );

      String imageUrl = widget.imageUrl;

      // Upload the selected image to Firestore Storage
      if (selectedImage != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_images/${widget.uid}');
        await storageRef.putFile(selectedImage!);
        imageUrl = await storageRef.getDownloadURL();

        // Update the user document in Firestore with the image URL
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
            .update({
          'photoURL': imageUrl,
          'displayName': userNameController.text,
          'email': emailController.text,
        });
      } else {
        // Update the user document in Firestore with the updated profile information
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
            .update({
          'displayName': userNameController.text,
          'email': emailController.text,
        });
      }

      widget.onUpdateProfile({
        'userName': userNameController.text,
        'email': emailController.text,
        'imageUrl': imageUrl,
      });

      final editedProfile = {
        'userName': userNameController.text,
        'email': emailController.text,
        'imageUrl': imageUrl,
      };

      Navigator.pop(context, editedProfile);
      Navigator.pop(context);
    } catch (e) {
      print(e.toString());
      // Handle any errors that occur while saving the profile
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: kCardColor,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(10.0), // Apply rounded corners to the dialog
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Edit Profile',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: userNameController,
              decoration: kInputTextDecoration.copyWith(
                hintText: '',
                labelText: 'Name',
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: emailController,
              decoration: kInputTextDecoration.copyWith(
                hintText: '',
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                ElevatedButton(
                  onPressed: selectImage,
                  child: Text('Change profile Picture'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPurple,
                  ),
                ),
                SizedBox(width: 12.0),
                Icon(
                  Icons.upload_file,
                  size: 25.0,
                  color: selectedImage == null ? Colors.grey : Colors.green,
                )
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: saveProfile,
                  child: Text('Update Profile'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kLightBlue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
