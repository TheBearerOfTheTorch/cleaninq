import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminServices extends StatefulWidget {
  const AdminServices({Key? key}) : super(key: key);

  @override
  _AdminServicesState createState() => _AdminServicesState();
}

class _AdminServicesState extends State<AdminServices> {
  final Stream<QuerySnapshot> _cleaningServices = FirebaseFirestore.instance.
  collection('services').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cleaninq services"
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _cleaningServices,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if(snapshot.connectionState == ConnectionState.none){
              return Row(
                children: [
                  Icon(
                    Icons.info,
                    color: Colors.blue,
                    size: 60,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Select a lot'),
                  )
                ],
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(),);
            }

            if(snapshot.hasData){
              return Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.orangeAccent),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child:ListView(
                    physics: BouncingScrollPhysics(),
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data() as Map<String,
                          dynamic>;
                      return Card(
                          child: Column(
                            children: [
                              ListTile(
                                leading: Container(
                                  width: MediaQuery.of(context).size.width/3,
                                  height: MediaQuery.of(context).size.width/2,
                                  child: Image.network(data['other']),
                                ),
                                title: Text(data['serviceName']),
                                subtitle: Text(data['Description']),
                                trailing: Icon(
                                    Icons.workspaces_outline
                                ),
                              ),

                            ],
                          )
                      );
                    }
                    ).toList(),
                  ));
            }
            return Center(child: CircularProgressIndicator(),);
          }
      ),
    );
  }
}
