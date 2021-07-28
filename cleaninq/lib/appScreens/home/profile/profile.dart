import 'dart:io';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:cleaninq/appScreens/home/profile/clients_book%20requests.dart';
import 'package:cleaninq/appScreens/home/profile/twoline.dart';
import 'package:cleaninq/services/middlewares/client_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vector_math/vector_math_64.dart' as math;

import 'edit_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _aboutController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _contactController = TextEditingController();

  //variable
  final _formKey = GlobalKey<FormState>();
  File? _image;
  String? imageUrl;
  bool _isLoading = false;
  bool _doneUploadng = false;

  //image picker
  final picker = ImagePicker();

  //firebase storage
  final FirebaseStorage _storage = FirebaseStorage.instance;
  UploadTask? _uploadTask;
  String filePath =
      'serviceProviderProfiles/${DateTime.now().microsecondsSinceEpoch}';

  //objects
  ClientBook profile = ClientBook();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _aboutController = TextEditingController();
    _addressController = TextEditingController();
    _contactController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _aboutController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  //picking the profile image
  Future getImage() async {
    PickedFile? pickedImage =
        await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedImage!.path);
    });
  }

  Future uploadImage(
      String name, String address, var contact, String model) async {
    setState(() {
      _isLoading = true;
      _uploadTask = _storage.ref().child(filePath).putFile(_image!);
    });
    var download = await (await _uploadTask!.whenComplete(() => null))
        .ref
        .getDownloadURL();
    imageUrl = await (await _uploadTask!.whenComplete(() => null))
        .ref
        .getDownloadURL();
    await profile.clientProfile(name, address, contact, model, download);

    setState(() {
      _isLoading = false;
    });
    return _isLoading;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    User? currentUser = _firebaseAuth.currentUser;
    //var userId = currentUser!.uid;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
            .collection('serviceProviderProfile')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
          var doc = snapshot.data?.docs;
          if (snapshot.hasError) {
            return Center(
              child: Text("An error has occurred"),
            );
          }
          if (doc == null) {
            return Container(
              height: MediaQuery.of(context).size.height / 1.22,
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
                                  color: Colors.green.withOpacity(0.95),
                                )
                              ],
                            ),
                            SafeArea(
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "My Profile",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    //checking for document here
                                    Expanded(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        RadialProgress(
                                          goalCompleted: 0.5,
                                          width: 5,
                                          child: CircleAvatar(
                                            backgroundImage: AssetImage(
                                                "assets/images/cleanLogo.jpg"),
                                            maxRadius: 60,
                                            backgroundColor: Colors.green,
                                          ),
                                        ),
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
                                              "to make it easy for other users to find you",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                                    SizedBox(
                                      height: 10,
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 33,
                      ),
                      Expanded(
                          flex: 4,
                          child: Container(
                            child: Table(children: [
                              TableRow(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                        return ThemeProvider(
                                          child: ClientProfile(),
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
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                        return ThemeProvider(
                                          child: MyBookRequests(),
                                        );
                                      }));
                                    },
                                    child: ProfileInfoBigCard(
                                      firstText: "View",
                                      secondText: "Booking requests",
                                      icon: Image.asset(
                                        "assets/icons/sad_smiley.png",
                                        width: 32,
                                        color: Colors.greenAccent,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                          )),
                    ],
                  ),
                ],
              ),
            );
          }
          return Container(
            height: MediaQuery.of(context).size.height / 1.22,
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
                                color: Colors.green.withOpacity(0.95),
                              )
                            ],
                          ),
                          SafeArea(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "My Profile",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  //checking for document here
                                  Expanded(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RadialProgress(
                                        goalCompleted: 1,
                                        width: 5,
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            "${doc.single.get("dowloadedImageUrl")}",
                                            //doc.single.get("dowloadedImageUrl")
                                          ),
                                          maxRadius: 60,
                                          backgroundColor: Colors.green,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "${doc.single.get("userName")}",
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
                                            "${doc.single.get("userEmail")}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "${doc.single.get("contacts")}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                        ],
                                      )
                                    ],
                                  )),
                                  SizedBox(
                                    height: 10,
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 33,
                    ),
                    Expanded(
                        flex: 4,
                        child: Container(
                          child: Table(children: [
                            TableRow(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return ThemeProvider(
                                        child: ClientProfile(),
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
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return ThemeProvider(
                                        child: MyBookRequests(),
                                      );
                                    }));
                                  },
                                  child: ProfileInfoBigCard(
                                    firstText: "View",
                                    secondText: "Booking requests",
                                    icon: Image.asset(
                                      "assets/icons/sad_smiley.png",
                                      width: 32,
                                      color: Colors.greenAccent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ]),
                        )),
                  ],
                ),
              ],
            ),
          );
        });
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
                  width: 25,
                  height: 25,
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
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
