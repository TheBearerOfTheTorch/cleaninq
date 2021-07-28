import 'package:cleaninq/appScreens/home/homeComponents/client_pages/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeDisplay extends StatefulWidget {
  @override
  _HomeDisplayState createState() => _HomeDisplayState();
}

class _HomeDisplayState extends State<HomeDisplay> {
  final Stream<QuerySnapshot> _cleaningServices =
      FirebaseFirestore.instance.collection('services').snapshots();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: FractionalOffset.center,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 1.19,
      child: StreamBuilder<QuerySnapshot>(
          stream: _cleaningServices,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.none) {
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
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasData) {
              return new ListView(
                physics: BouncingScrollPhysics(),
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  return Container(
                      decoration: BoxDecoration(
                        color: Colors.lightBlueAccent,
                        border: Border.all(
                          color: Colors.black,
                          width: 5,
                        ),
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.black26],
                        ),
                        image: DecorationImage(
                          image: NetworkImage(data['other']),
                          fit: BoxFit.cover,
                        ),
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width / 2,
                      child: Column(
                        children: [
                          ListTile(
                            //leading: Image.network(data['other']),
                            trailing: IconButton(
                              mouseCursor: MouseCursor.uncontrolled,
                              color: Colors.white,
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        BookServices()));
                              },
                              icon: Icon(Icons.info_outline),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width / 5.5,
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      BookServices(
                                        service: data['serviceName'],
                                      )));
                            },
                            icon: Icon(Icons.book),
                            label: Text("Book ${data['serviceName']}"),
                          ),
                        ],
                      ));
                }).toList(),
              );
            }
            if (!snapshot.hasData) {
              return Center(
                child: Text("No services found!"),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
