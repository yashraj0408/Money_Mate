import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:money_mate/models/models.dart';

class FirebaseServices {
  static Future<void> getUserData(UserData userData) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        userData.uid = user.uid;
        userData.userName = user.displayName ?? '';
        userData.email = user.email ?? '';
        // Fetch the user document from Firestore
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userData.uid)
            .get();

        // Extract the photoURL from the document
        userData.imageUrl = snapshot.get('photoURL') ?? 'initial value';
      }
    } catch (e) {
      print(e.toString());
      // Handle any errors that occur while fetching user data
    }
  }
}
