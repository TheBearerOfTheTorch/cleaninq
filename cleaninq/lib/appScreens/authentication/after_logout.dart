import 'dart:async';
import 'dart:io';
import 'package:cleaninq/services/authentication_services/auth_services.dart';
import 'package:flutter/material.dart';

class AfterLogout extends StatelessWidget {
  AfterLogout({Key? key}) : super(key: key);
  final AuthServices _auth = AuthServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "CLEANINQ",
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.close_outlined),
              onPressed: () async {
                exit(0);
              })
        ],
      ),
      body: Stack(
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
                          height: MediaQuery.of(context).size.height / 2,
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.95),
                          ),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: EdgeInsets.only(top: 20, right: 30),
                            ),
                          ),
                        )
                      ],
                    ),
                    SafeArea(
                      child: Padding(
                          padding: EdgeInsets.all(13),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "LOGGED OUT",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              Expanded(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: AssetImage(
                                        "assets/images/cleanLogo.jpg"),
                                    maxRadius: 60,
                                    backgroundColor: Colors.green,
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Thank you for using  cleaninq",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 23),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FittedBox(
                                        fit: BoxFit.contain,
                                        child: Text(
                                          "please do return for more services",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13),
                                        ),
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
                height: 280,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
