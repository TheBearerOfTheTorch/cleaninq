import 'package:cleaninq/appScreens/authentication/after_logout.dart';
import 'package:cleaninq/appScreens/home/homeComponents/admin_pages/view_admin_services.dart';
import 'package:cleaninq/appScreens/home/homeComponents/serviceprovider_pages/service_provider.dart';
import 'package:cleaninq/appScreens/home/homeComponents/serviceprovider_pages/view_client_request.dart';
import 'package:cleaninq/appScreens/home/profile/edit_profile.dart';
import 'package:cleaninq/services/authentication_services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'adding_services.dart';

class AdminPage extends StatelessWidget {
  AdminPage({Key? key}) : super(key: key);
  final AuthServices _auth = AuthServices();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "cleaninq admin panel",
      theme: ThemeData.dark().copyWith(),
      home: SafeArea(
        child: Scaffold(body: GridViewObjects()),
      ),
    );
  }
}

class GridViewObjects extends StatefulWidget {
  const GridViewObjects({Key? key}) : super(key: key);

  @override
  _GridViewObjectsState createState() => _GridViewObjectsState();
}

class _GridViewObjectsState extends State<GridViewObjects> {
  AuthServices _authServices = AuthServices();
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    User? currentAdmin = _auth.currentUser;

    return SafeArea(
        child: Stack(
      children: [
        Column(
          children: [
            Expanded(
              flex: 4,
              child: Stack(
                children: [
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.95),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(50),
                              bottomRight: Radius.circular(50),
                            )),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.only(top: 10, right: 20),
                            child: IconButton(
                              splashColor: Colors.white,
                              onPressed: () async {
                                await _authServices.logout();
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (context) {
                                  return AfterLogout();
                                }));
                              },
                              icon: Icon(Icons.logout),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SafeArea(
                    child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Admin Panel",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            Expanded(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RadialProgress(
                                    goalCompleted: 1,
                                    width: 5,
                                    child: CircleAvatar(
                                      backgroundImage: AssetImage(
                                          "assets/images/cleanLogo.jpg"),
                                      maxRadius: 60,
                                      //backgroundColor: Colors.green,
                                    )),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width / 15,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Welcome to Clean Inq",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 23),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width / 35 -
                                          5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Admin Page",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                  ],
                                )
                              ],
                            )),
                          ],
                        )),
                  )
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width / 9,
            ),
            Expanded(
                flex: 4,
                child: Container(
                  child: Table(children: [
                    TableRow(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return ClientProfile();
                            }));
                          },
                          child: ProfileInfoBigCard(
                            firstText: "Edit",
                            secondText: "profile",
                            icon: Icon(
                              Icons.edit,
                              size: 32,
                              color: Colors.greenAccent,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddingServices(),
                              ),
                            );
                          },
                          child: ProfileInfoBigCard(
                            firstText: "Add",
                            secondText: "Services",
                            icon: Icon(
                              Icons.star,
                              size: 32,
                              color: Colors.greenAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ViewRequests()));
                          },
                          child: ProfileInfoBigCard(
                            firstText: "View",
                            secondText: "Clients requests",
                            icon: Image.asset(
                              "assets/icons/checklist.png",
                              width: 32,
                              color: Colors.greenAccent,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AdminServices()));
                          },
                          child: ProfileInfoBigCard(
                            firstText: "View",
                            secondText: "Cleaninq services",
                            icon: Icon(
                              Icons.refresh,
                              size: 32,
                              color: Colors.greenAccent,
                            ),
                          ),
                        )
                      ],
                    ),
                  ]),
                )),
          ],
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * (4 / 9) - 30,
          left: 16,
          right: 16,
          child: Container(
            height: MediaQuery.of(context).size.width / 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                ProfileInfoCard(firstText: "Approve", secondText: "Requests"),
                ProfileInfoCard(
                  hasImage: true,
                  imagePath: "assets/icons/pulse.png",
                ),
                ProfileInfoCard(firstText: "Paid", secondText: "Requests"),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
