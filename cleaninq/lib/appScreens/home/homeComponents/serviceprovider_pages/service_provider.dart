import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:cleaninq/appScreens/authentication/after_logout.dart';
import 'package:cleaninq/appScreens/home/homeComponents/serviceprovider_pages/provider_profile.dart';
import 'package:cleaninq/appScreens/home/homeComponents/serviceprovider_pages/services_by_provider.dart';
import 'package:cleaninq/appScreens/home/homeComponents/serviceprovider_pages/twoline.dart';
import 'package:cleaninq/appScreens/home/homeComponents/serviceprovider_pages/user_preferences.dart';
import 'package:cleaninq/appScreens/home/homeComponents/serviceprovider_pages/view_client_request.dart';
import 'package:cleaninq/services/authentication_services/auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vector_math/vector_math_64.dart' as math;
import 'add_service.dart';

class ServicesProvider extends StatefulWidget {
  const ServicesProvider({Key? key}) : super(key: key);

  @override
  _ServicesProviderState createState() => _ServicesProviderState();
}

class _ServicesProviderState extends State<ServicesProvider> {
  var selectedType;
  final user = UserPreferences.myUser;

  //objects
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  AuthServices _authServices = AuthServices();

  @override
  Widget build(BuildContext context) {
    User? currentUser = _firebaseAuth.currentUser;
    List _iconType = [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            Icons.logout,
            color: Colors.red,
          ),
          Text(
            "Logout",
            style: TextStyle(
              color: Colors.red,
            ),
          )
        ],
      ),
    ];
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
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
                          decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.95),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(50),
                                bottomRight: Radius.circular(50),
                              )),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: EdgeInsets.only(top: 30, right: 30),
                              child: DropdownButton(
                                icon: SvgPicture.asset("assets/icons/menu.svg"),
                                items: _iconType
                                    .map((value) => DropdownMenuItem(
                                          child: GestureDetector(
                                            onTap: () async {
                                              _authServices.logout();
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                return AfterLogout();
                                              }));
                                            },
                                            child: value,
                                          ),
                                          value: value,
                                        ))
                                    .toList(),
                                onChanged: (selectedAccountType) {},
                                //value: selectedType,
                                isExpanded: false,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SafeArea(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(currentUser!.uid)
                              .collection('serviceProviderProfile')
                              .snapshots(),
                          builder: (context, snapshot) {
                            var doc = snapshot.data?.docs;
                            if (snapshot.hasError) {
                              return AlertDialog(
                                title: Text(
                                    "Theres an error retrieving profile informations"),
                              );
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (doc == null) {
                              return Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Provider",
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
                                          goalCompleted: 0.5,
                                          width: 5,
                                          child: CircleAvatar(
                                            backgroundImage: AssetImage(
                                                "assets/images/cleanLogo.jpg"),
                                            maxRadius: 60,
                                            backgroundColor: Colors.green,
                                          )),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Please complete your profile",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 25),
                                          )
                                        ],
                                      ),
                                      //SizedBox(height: 10,),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "to make it easy for clients to find you",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                        ],
                                      )
                                    ],
                                  )),
                                  SizedBox(
                                    height: 20,
                                  )
                                ],
                              );
                            }
                            if (snapshot.hasData) {
                              return Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Provider",
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
                                            backgroundColor: Colors.green,
                                          )),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "${currentUser.email}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 23),
                                          )
                                        ],
                                      ),
                                      //SizedBox(height: 10,),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                        ],
                                      )
                                    ],
                                  )),
                                  SizedBox(
                                    height: 20,
                                  )
                                ],
                              );
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 60,
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
                                return ThemeProvider(
                                  initTheme: user.isDarkMode
                                      ? MyThemes.darkTheme
                                      : MyThemes.lightTheme,
                                  child: ProfilePage(),
                                );
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
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return ThemeProvider(
                                  initTheme: user.isDarkMode
                                      ? MyThemes.darkTheme
                                      : MyThemes.lightTheme,
                                  child: AddServices(),
                                );
                              }));
                            },
                            child: ProfileInfoBigCard(
                              firstText: "Add",
                              secondText: "cleaning services",
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
                                  builder: (context) => ServiceByProvider()));
                            },
                            child: ProfileInfoBigCard(
                              firstText: "View",
                              secondText: "Services you provide",
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
            top: screenHeight * (4 / 9) - 30,
            left: 16,
            right: 16,
            child: Container(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  ProfileInfoCard(firstText: "54%", secondText: "Progress"),
                  SizedBox(
                    width: 10,
                  ),
                  ProfileInfoCard(
                    hasImage: true,
                    imagePath: "assets/icons/pulse.png",
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ProfileInfoCard(firstText: "152", secondText: "Requests"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ImageWidget extends StatelessWidget {
  final imager;
  const ImageWidget({Key? key, this.imager}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          imager,
          width: double.maxFinite,
          height: double.maxFinite,
          fit: BoxFit.fill,
        ),
        Container(
          color: Colors.green.withOpacity(0.85),
        )
      ],
    );
  }
}

class ImageProfile extends StatefulWidget {
  const ImageProfile({Key? key}) : super(key: key);

  @override
  _ImageProfileState createState() => _ImageProfileState();
}

//will come to you later
class _ImageProfileState extends State<ImageProfile> {
  final Stream<QuerySnapshot> _users =
      FirebaseFirestore.instance.collection('users').snapshots();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StreamBuilder<QuerySnapshot>(
            stream: _users,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    return Image.asset("assets/OIP.jpg");
                  }).toList(),
                );
              }
              return Center(child: CircularProgressIndicator());
            }),
      ],
    );
  }
}

class RadialProgress extends StatefulWidget {
  final double goalCompleted;
  final Widget child;
  final Color progressColor;
  final Color progressBackgroundColor;
  final double width;

  const RadialProgress(
      {Key? key,
      required this.child,
      this.goalCompleted = 0.7,
      this.progressColor = Colors.white,
      this.progressBackgroundColor = Colors.white,
      this.width = 8})
      : super(key: key);

  @override
  _RadialProgressState createState() => _RadialProgressState();
}

class _RadialProgressState extends State<RadialProgress>
    with SingleTickerProviderStateMixin {
  AnimationController? _radialProgressAnimationController;
  Animation<double>? _progressAnimation;
  final Duration fadeInDuration = Duration(milliseconds: 500);
  final Duration fillDuration = Duration(seconds: 2);

  double progressDegrees = 0;
  var count = 0;

  @override
  void initState() {
    super.initState();
    _radialProgressAnimationController =
        AnimationController(vsync: this, duration: fillDuration);
    _progressAnimation = Tween(begin: 0.0, end: 360.0).animate(CurvedAnimation(
        parent: _radialProgressAnimationController!, curve: Curves.easeIn))
      ..addListener(() {
        setState(() {
          progressDegrees = widget.goalCompleted * _progressAnimation!.value;
        });
      });

    _radialProgressAnimationController!.forward();
  }

  @override
  void dispose() {
    _radialProgressAnimationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: widget.child,
      ),
      painter: RadialPainter(
        progressDegrees,
        widget.progressColor,
        widget.progressBackgroundColor,
        widget.width,
      ),
    );
  }
}

class RadialPainter extends CustomPainter {
  double progressInDegrees, width;
  final Color progressColor, progressBackgroundColor;

  RadialPainter(this.progressInDegrees, this.progressColor,
      this.progressBackgroundColor, this.width);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = progressBackgroundColor.withOpacity(0.5)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    Offset center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, size.width / 2, paint);

    Paint progressPaint = Paint()
      ..color = progressColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    canvas.drawArc(
        Rect.fromCircle(center: center, radius: size.width / 2),
        math.radians(-90),
        math.radians(progressInDegrees),
        false,
        progressPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

//profile table
class ProfileInfoCard extends StatelessWidget {
  final firstText, secondText, hasImage, imagePath;

  const ProfileInfoCard(
      {Key? key,
      this.firstText,
      this.secondText,
      this.hasImage = false,
      this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: hasImage
            ? Center(
                child: Image.asset(
                  imagePath,
                  color: Colors.green,
                  width: MediaQuery.of(context).size.width / 13,
                  height: MediaQuery.of(context).size.width / 13,
                ),
              )
            : TwoLineItem(
                firstText: firstText,
                secondText: secondText,
              ),
      ),
    );
  }
}

class ProfileInfoBigCard extends StatelessWidget {
  final String firstText, secondText;
  final Widget icon;

  const ProfileInfoBigCard(
      {Key? key,
      required this.firstText,
      required this.secondText,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          top: 16,
          bottom: 24,
          right: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: icon,
            ),
            Text(firstText, style: TextStyle(fontSize: 20)),
            Text(
              secondText,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
