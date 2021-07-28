import 'package:cleaninq/appScreens/authentication/after_logout.dart';
import 'package:cleaninq/appScreens/authentication/loginAuth.dart';
import 'package:cleaninq/appScreens/authentication/verifyEmaile.dart';
import 'package:cleaninq/appScreens/home/profile/profile.dart';
import 'package:cleaninq/appScreens/home/search/search.dart';
import 'package:cleaninq/services/authentication_services/auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../wrapper.dart';
import 'homeComponents/client_pages/homeDisplayData.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthServices _auth = AuthServices();
  bool loading = false;

  int _currentIndex = 0;

  final tabs = [
    HomeDisplay(),
    Search(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(),
      appBar: AppBar(
        actions: [
          // IconButton(
          //     onPressed: (){
          //       ServicesSearch();
          //     }, icon: Icon(Icons.search)
          // )
        ],
      ),
      body: SingleChildScrollView(child: tabs[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.payment,
              ),
              label: 'Payments',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              label: 'Profile',
            )
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          }),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  final AuthServices _auth = AuthServices();
  NavigationDrawer({Key? key}) : super(key: key);
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    User? currentUser = _firebaseAuth.currentUser;

    return Drawer(
        child: SingleChildScrollView(
            child: Stack(
      children: [
        Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
                child: Container(
              height: MediaQuery.of(context).size.height / 2.2,
              color: Colors.green,
            ))
          ],
        ),
        StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(currentUser!.uid)
                .collection('serviceProviderProfile')
                .snapshots(),
            builder: (context, snapshot) {
              var doc = snapshot.data?.docs;
              if (snapshot.hasError) {
                return Center(
                  child: Text("Error retrieving profile details"),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (doc == null) {
                return Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                      child: Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.all(
                            30,
                          ),
                          child: Text(
                            "My Profile",
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                            ),
                          )),
                      RadialProgress(
                        goalCompleted: 0.5,
                        width: 5,
                        child: CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/images/cleanLogo.jpg"),
                          maxRadius: 60,
                          backgroundColor: Colors.green,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 20,
                      ),
                      Text(
                        "Complete profile to see profile picture",
                        style: TextStyle(fontSize: 13, color: Colors.white),
                      ),
                    ],
                  )),
                );
              }
              if (snapshot.hasData) {
                return Padding(
                  padding: EdgeInsets.only(
                    top: 30,
                  ),
                  child: Center(
                      child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(
                              10,
                            ),
                            child: Text(
                              "My Profile",
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 25,
                      ),
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          doc.single.get("dowloadedImageUrl"),
                          //doc.single.get("dowloadedImageUrl")
                        ),
                        maxRadius: 60,
                        backgroundColor: Colors.green,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 22,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.phone_android,
                            color: Colors.white,
                          ),
                          Text(
                            "${doc.single.get("contacts")}",
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.dynamic_feed,
                            color: Colors.white,
                          ),
                          Text(
                            "${doc.single.get("userName")}",
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.email,
                            color: Colors.white,
                          ),
                          Text(
                            "${doc.single.get("userEmail")}",
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  )),
                );
              }
              return Center(
                child: Text("Loading!!!"),
              );
            }),
        Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
                child: Container(
              margin: EdgeInsets.only(top: 370),
              height: MediaQuery.of(context).size.height / 2,
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.width / 2),
                  Row(
                    children: [
                      OutlinedButton.icon(
                          icon: Icon(Icons.logout),
                          label: Text(
                            'Logout',
                          ),
                          onPressed: () async {
                            await _auth.logout();
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) {
                              return AfterLogout();
                            }));
                          })
                    ],
                  )
                ],
              ),
            ))
          ],
        ),
      ],
    )));
  }

  Widget buildMenuItem({text, IconData? icon}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        text,
      ),
    );
  }
}

//
class ServicesSearch extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Search term must be longer than two letters.",
            ),
          )
        ],
      );
    }

    //Add the search term to the searchBloc.
    //The Bloc will then handle the searching and add the results to the searchResults stream.
    //This is the equivalent of submitting the search term to whatever search service you are using
    InheritedBlocs.of(context).searchBloc.searchTerm.add(query);

    return Column(
      children: <Widget>[
        //Build the results based on the searchResults stream in the searchBloc
        StreamBuilder(
          stream: InheritedBlocs.of(context).searchBloc.searchResults,
          builder: (context, AsyncSnapshot<List> snapshot) {
            if (!snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(child: CircularProgressIndicator()),
                ],
              );
            } else if (snapshot.data!.length == 0) {
              return Column(
                children: <Widget>[
                  Text(
                    "No Results Found.",
                  ),
                ],
              );
            } else {
              var results = snapshot.data!;
              return ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  var result = results[index];
                  return ListTile(
                    title: Text(result.title),
                  );
                },
              );
            }
          },
        ),
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Column();
  }
}

class InheritedBlocs extends InheritedWidget {
  InheritedBlocs({Key? key, this.searchBloc, required this.child})
      : super(key: key, child: child);

  final Widget child;
  final searchBloc;

  static InheritedBlocs of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<InheritedBlocs>()
        as InheritedBlocs);
  }

  @override
  bool updateShouldNotify(InheritedBlocs oldWidget) {
    return true;
  }
}
