import 'package:cleaninq/appScreens/home/homeComponents/serviceprovider_pages/service_provider.dart';
import 'package:cleaninq/services/authentication_services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class VerifyEmail extends StatelessWidget {
  VerifyEmail({Key? key}) : super(key: key);
  final AuthServices _auth = AuthServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "CLEANINQ",
          style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w700
          ),

        ),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async{
                await _auth.logout();
              })
        ],
      ),
      body: VerifyDisplay(),
    );
  }
}

class VerifyDisplay extends StatelessWidget {
  const VerifyDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              flex:4,
              child: Stack(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height/2,
                        decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.95),
                            // borderRadius: BorderRadius.only(
                            //   bottomLeft: Radius.circular(40),
                            //   bottomRight: Radius.circular(40),
                            // )
                        ),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.only(top: 20,right: 30),

                          ),
                        ),
                      )
                    ],
                  ),
                  SafeArea(
                    child:Padding(
                      padding: EdgeInsets.all(13),
                      child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Verify Email",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700
                                  ),

                                ),
                              ),
                              Expanded(
                                  child:Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RadialProgress(
                                          goalCompleted: 0,
                                          width: 5,
                                          child:CircleAvatar(
                                            backgroundImage: AssetImage(
                                                "assets/images/cleanLogo.jpg"
                                            ),
                                            maxRadius: 60,
                                            backgroundColor: Colors.green,
                                          )
                                      ),
                                      SizedBox(height: 50,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("We can not redirect you",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 23
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          FittedBox(
                                            fit: BoxFit.contain,
                                            child: Text("Check your emails for the verification link",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13
                                              ),
                                            ),
                                          ),
                                        ],
                                      )

                                    ],
                                  )
                              ),
                            ],
                          )
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 280,),
          ],
        ),
      ],
    );
  }
}

