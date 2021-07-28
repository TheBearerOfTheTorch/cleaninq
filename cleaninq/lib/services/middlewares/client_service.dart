import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ClientBook {
  bool _isLoading = false;
  CollectionReference book =
      FirebaseFirestore.instance.collection('customerBookRequests');
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore provider = FirebaseFirestore.instance;

  Future addCustomerBook(String date, String address, description, service,
      {time}) async {
    User? user = firebaseAuth.currentUser;

    book.add({
      'bookDate': date,
      'bookTime': time,
      'address': address,
      'description': description,
      'serviceName': service,
      'userId': user!.uid,
      'userEmail': user.email,
      'createdAt': DateTime.now()
    }).then((value) {
      print("customer book request was added");
      return _isLoading;
    }).catchError((error) => print("Failed to book: $error"));
    return _isLoading;
  }

  Future clientProfile(
      String name, String address, var contact, model, imageurl) async {
    //sending the details to firestore
    User? user = firebaseAuth.currentUser;
    provider
        .collection('users')
        .doc(user!.uid)
        .collection('serviceProviderProfile')
        .doc(user.uid)
        .set({
      'userId': user.uid,
      'userEmail': user.email,
      'userName': name,
      'userAddress': address,
      'contacts': contact,
      'provideModel': model,
      'dowloadedImageUrl': imageurl,
      'timestamp': DateTime.now().toUtc()
    }).then((value) {
      print("client of id: ${user.uid} has updated their profile");
      return _isLoading;
    }).catchError((error) {
      print("something went wrong while uploading!");
    });
    return _isLoading;
  }
}
