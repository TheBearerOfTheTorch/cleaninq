import 'dart:io';
import 'package:cleaninq/appScreens/home/homeComponents/admin_pages/admin.dart';
import 'package:cleaninq/services/storage/storage_upload.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminServices with ChangeNotifier{
  bool _isLoading = false;
  String _errorMessage ="";
  bool get isLoading =>_isLoading;
  String get errorMessage =>_errorMessage;
  CollectionReference services = FirebaseFirestore.instance.collection('services');
  FirebaseAuth auth = FirebaseAuth.instance;

  Future addService(String serviceName,String description,String other) async
  {
    User? user = auth.currentUser;

    services
        .add({
      'userEmail':user!.email,
      'createdAt':DateTime.now().microsecondsSinceEpoch,
      'serviceName': serviceName,
      'Description':description,
      'other':other,
      'adminId':user.uid,
    }).then((value) => print("cleaning service was added"))
        .catchError((error) => print("Failed to Add cleaning service: $error"));
  }

  void setLoading(val){
    _isLoading = val;
    notifyListeners();
  }

  void setMessage(message){
    _errorMessage = message;
    notifyListeners();
  }
}