import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SharedProfileFirebase {
  bool _isLoading = false;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _profile = FirebaseFirestore.instance;

  Future profileUpdating(
      String name, String address, var contact, model, imageurl) async {
    //sending the details to firestore
    User? user = firebaseAuth.currentUser;
    _profile.collection('users').doc(user!.uid).set({
      'userId': user.uid,
      'displayName': name,
      'email': user.email,
      'phoneNumber': contact,
      'location': address,
      'provideModel': model,
      'photoURL': imageurl,
      'timestamp': DateTime.now().toUtc()
    }).then((value) {
      print("User: ${name} has updated their profile");
      return _isLoading;
    }).catchError((error) {
      print("something went wrong while uploading profile!");
    });
    return _isLoading;
  }
}
