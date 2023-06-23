import 'package:flutter/material.dart';
import 'package:money_mate/components/reusable_card.dart';
import 'dart:io';

import 'package:money_mate/constants.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = 'John Doe';
  String email = 'abc@gmail.com';
  String profileImageUrl = 'https://example.com/profile_image.jpg';

  void editProfile() async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditProfileDialog();
      },
    );
    if (result != null) {
      setState(() {
        userName = result['userName'];
        email = result['email'];
        profileImageUrl = result['profileImageUrl'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
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
                        // backgroundImage: NetworkImage(profileImageUrl),
                        backgroundImage: AssetImage("images/dp.png"),
                      ),
                      SizedBox(height: 24.0),
                      Text(
                        userName,
                        style: TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        email,
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton.icon(
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  width: 150,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {},
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
    userNameController.text = 'John Doe';
    emailController.text = '1234567890';
  }

  void selectImage() async {
    // Code to select image from file system
    // Here, we assume it is stored in the selectedImage variable
    // Replace this code with your image selection logic
  }

  void saveProfile() {
    final Map<String, dynamic> editedProfile = {
      'userName': userNameController.text,
      'email': emailController.text,
      'profileImageUrl': selectedImage != null ? selectedImage!.path : '',
    };
    Navigator.pop(context, editedProfile);
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
                  child: Text('Browse profile Picture'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPurple,
                  ),
                ),
                SizedBox(width: 16.0),
                Text(selectedImage != null ? selectedImage!.path : ''),
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
                  child: Text('Save Profile'),
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
