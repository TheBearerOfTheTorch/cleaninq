import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ServiceByProvider extends StatefulWidget {
  const ServiceByProvider({Key? key}) : super(key: key);

  @override
  _ServiceByProviderState createState() => _ServiceByProviderState();
}

class _ServiceByProviderState extends State<ServiceByProvider> {
  //firebase
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Stream<QuerySnapshot> _request = FirebaseFirestore.instance.collection('providerServices').snapshots();


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _request,
      builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
        if(snapshot.hasError) {
          return AlertDialog(
            content: Text("An unkown error occured while retrieving requests"),
          );
        }
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        }
        return Scaffold(
            appBar: AppBar(),
            body: ListView(
              physics: BouncingScrollPhysics(),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data() as Map<String,
                    dynamic>;
                return Card(
                  child: ListTile(
                    leading: Text("${data['serviceName']}"),
                    title: Text("${data['service']}"),
                    subtitle: Text("${data['description']}"),
                    trailing: IconButton(
                      mouseCursor: MouseCursor.uncontrolled,
                      onPressed: (){
                        // Navigator.of(context).push(
                        //     MaterialPageRoute(builder: (
                        //         BuildContext context) =>BookServices()
                        //     )
                        // );
                      },
                      icon: Icon(
                          Icons.info_outline
                      ),
                    ),
                  ),
                );
              }
              ).toList(),
            )
        );
      },
    );
  }
}
