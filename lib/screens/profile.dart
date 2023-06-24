import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_mate/constants.dart';
import 'package:money_mate/components/reusable_card.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String uid;
  String userName = '';
  late String email;
  String? imageUrl;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        uid = user.uid;
        if (userName.isEmpty) {
          // Fetch the name only if it's not already stored
          userName = user.displayName ?? '';
        }
        email = user.email ?? '';
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e.toString());
      // Handle any errors that occur while fetching user data
    }
  }

  void editProfile() async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditProfileDialog(
          uid: uid,
          userName: userName,
          email: email,
          imageUrl: imageUrl,
          onUpdateProfile: updateProfile,
        );
      },
    );
    if (result != null) {
      setState(() {
        userName = result['userName'];
        email = result['email'];
        imageUrl = result['imageUrl'];
      });
    }
  }

  void updateProfile(String newName, String? newUrl) {
    setState(() {
      userName = newName;
      // email = newEmail;
      imageUrl = newUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                              backgroundImage: imageUrl != null
                                  ? NetworkImage(imageUrl!)
                                  : AssetImage("images/dp.png")
                                      as ImageProvider<Object>?,
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        width: 150,
                        height: 50,
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
  final String? imageUrl;
  final Function(String, String?) onUpdateProfile;

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

      // Upload the selected image to Firestore Storage
      if (selectedImage != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_images/${widget.uid}');
        await storageRef.putFile(selectedImage!);
        final imageUrl = await storageRef.getDownloadURL();

        // Update the user document in Firestore with the image URL
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
            .update({'photoUrl': imageUrl});

        setState(() {
          widget.onUpdateProfile(userNameController.text, imageUrl);
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

        widget.onUpdateProfile(userNameController.text, widget.imageUrl);
      }

      final editedProfile = {
        'userName': userNameController.text,
        'email': emailController.text,
        'imageUrl': widget.imageUrl,
      };
      Navigator.pop(context);
      Navigator.pop(context, editedProfile);
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
              decoration: InputDecoration(
                hintText: '',
                labelText: 'Name',
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
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
