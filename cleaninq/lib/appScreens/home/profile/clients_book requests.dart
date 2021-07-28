import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyBookRequests extends StatefulWidget {
  const MyBookRequests({Key? key}) : super(key: key);

  @override
  _MyBookRequestsState createState() => _MyBookRequestsState();
}

class _MyBookRequestsState extends State<MyBookRequests> {
  final Stream<QuerySnapshot> _clientReqiests = FirebaseFirestore.instance
      .collection('customerBookRequests').orderBy('createdAt', descending: true).snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<QuerySnapshot>(
        stream: _clientReqiests,
        builder: (BuildContext context, snapshot ) {
          //var doc = snapshot.data!.docs;

          if(snapshot.hasError){
            return Center(child: Text(
              "An unknown error occured"
            ),);
          }
          if(snapshot.hasData){
            return ListView(
              physics: BouncingScrollPhysics(),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data() as Map<String,
                    dynamic>;
                return Card(
                  child: ListTile(
                    leading: Text("${data['bookDate']}"),
                    title: Text("${data['serviceName']}"),
                    trailing: Text("${data['userEmail']}"),
                  ),
                );
              }
              ).toList(),
            );
          }
          return Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: CircularProgressIndicator(),
            ),

          );
        },

      ),
    );
  }
}
