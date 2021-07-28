import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseServices{
  FirebaseAuth authorisedUser = FirebaseAuth.instance.currentUser as FirebaseAuth;
  final CollectionReference dbUsers = FirebaseFirestore.instance.collection('users');
}