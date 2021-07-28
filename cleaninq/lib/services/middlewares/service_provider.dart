import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProviderAddService{
  bool _isLoading = false;
  FirebaseFirestore provider = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future addServices(String organization,String service,String price,String description) async
  {
    User? user = firebaseAuth.currentUser;
    provider.collection('providerServices')
        .add({
      'organizationName': organization,
      'service': service,
      'serviceName':price,
      'description':description,
      'userId':user!.uid,
    }).then((value) {
      print("Service from provider success");
      return _isLoading;
    }).catchError((error) => print("Failed to add service: $error"));
    return _isLoading;
  }

  Future updateProfile(String name, String address , var contact, model,imageurl) async{
    //sending the details to firestore
    User? user = firebaseAuth.currentUser;
    provider.collection('users')
        .doc(user!.uid)
        .collection('serviceProviderProfile')
        .doc(user.uid)
        .set({
      'userId':user.uid,
    'userEmail':user.email,
    'userName':name,
    'userAddress': address,
    'contacts':contact,
      'provideModel':model,
      'dowloadedImageUrl':imageurl,
    'timestamp':DateTime.now().toUtc()})
        .then((value) {
          print("provider of id: ${user.uid} has updated his profile");
          return _isLoading;
    }).catchError((error){
      print("something went wrong while uploading!");
    });
    return _isLoading;
  }
}