import 'dart:io';
import 'package:cleaninq/appScreens/home/homeComponents/serviceprovider_pages/user_preferences.dart';
import 'package:cleaninq/services/middlewares/service_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
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
  ProviderAddService providerService = ProviderAddService();
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
    await providerService.updateProfile(
        name, address, contact, model, download);

    setState(() {
      _isLoading = false;
    });
    return _isLoading;
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = _firebaseAuth.currentUser;
    final user = UserPreferences.myUser;
    final Stream<QuerySnapshot> _providerPick =
        FirebaseFirestore.instance.collection('users').snapshots();

    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: ListView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 32),
              children: [
                SizedBox(height: MediaQuery.of(context).size.width / 20),
                Center(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(currentUser!.uid)
                        .collection('serviceProviderProfile')
                        .snapshots(),
                    builder: (context, profilesnapshot) {
                      var doc = profilesnapshot.data?.docs;
                      if (profilesnapshot.hasError) {
                        return CircularProgressIndicator(
                          color: Colors.white,
                        );
                      }
                      var d = doc == null;
                      if (doc == null) {
                        return Stack(
                          children: [
                            ClipOval(
                              child: Material(
                                color: Colors.transparent,
                                child: CircleAvatar(
                                  backgroundImage:
                                      AssetImage("assets/images/cleanLogo.jpg"),
                                  maxRadius: 60,
                                  backgroundColor: Colors.green,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 4,
                              child: buildEditIcon(Colors.green),
                            ),
                          ],
                        );
                      }
                      if (profilesnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      }
                      if (profilesnapshot.hasData) {
                        return Stack(
                          children: [
                            ClipOval(
                              child: Material(
                                color: Colors.transparent,
                                child: CircleAvatar(
                                  backgroundImage:
                                      AssetImage("assets/images/cleanLogo.jpg"),
                                  maxRadius: 60,
                                  backgroundColor: Colors.green,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 4,
                              child: buildEditIcon(Colors.green),
                            ),
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
                SizedBox(height: MediaQuery.of(context).size.width / 30),
                TextFormField(
                  validator: (val) => val!.isNotEmpty
                      ? null
                      : "Please fill in the full name field",
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: "Enter your Full name",
                    labelText: 'Full name',
                    prefixIcon: Icon(FontAwesomeIcons.userEdit),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusColor: Colors.white,
                  ),
                  maxLines: 1,
                ),
                SizedBox(height: MediaQuery.of(context).size.width / 30),
                TextFormField(
                  validator: (val) => val!.isNotEmpty
                      ? null
                      : "Please fill in your place of business",
                  controller: _addressController,
                  decoration: InputDecoration(
                    hintText: "Place of business",
                    labelText: 'Address',
                    prefixIcon: Icon(FontAwesomeIcons.building),
                    focusColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: 1,
                ),
                SizedBox(height: MediaQuery.of(context).size.width / 30),
                TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (val) => val!.isNotEmpty
                      ? null
                      : "Please fill in your contact details",
                  controller: _contactController,
                  decoration: InputDecoration(
                    hintText: "Contact details",
                    labelText: 'Contact',
                    prefixIcon: Icon(FontAwesomeIcons.phoneAlt),
                    focusColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: 1,
                ),
                SizedBox(height: MediaQuery.of(context).size.width / 20),
                TextFormField(
                  validator: (val) => val!.isNotEmpty
                      ? null
                      : "Please fill in the Organization model",
                  controller: _aboutController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(FontAwesomeIcons.modx),
                    hintText: "Organization Model",
                    labelText: 'Model',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: 5,
                ),
                SizedBox(height: MediaQuery.of(context).size.width / 2.8 - 110),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    onPrimary: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  label: Text("Update profile"),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      var loading = await uploadImage(
                          _nameController.text.trim(),
                          _addressController.text.trim(),
                          _contactController.text.trim(),
                          _aboutController.text.trim());
                      setState(() {
                        _nameController.text = "";
                        _addressController.text = "";
                        _contactController.text = "";
                        _aboutController.text = "";
                        _image = null;
                        _isLoading = loading;
                        _doneUploadng = true;
                      });
                    }
                  },
                  icon: Icon(FontAwesomeIcons.edit),
                ),
              ],
            ),
          ),
          Positioned(
            child: _isLoading
                ? Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                    color: Colors.white.withOpacity(0.7),
                  )
                : Container(),
          )
        ],
      ),
    );
  }

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: _image != null ? Colors.blue : color,
          all: 1,
          child: _image != null
              ? Icon(
                  Icons.thumb_up_alt_outlined,
                  color: Colors.white,
                  size: 20,
                )
              : IconButton(
                  iconSize: 25,
                  color: Colors.white,
                  onPressed: () async {
                    await getImage();
                  },
                  icon: Icon(Icons.add_a_photo),
                ),
        ),
      );
}

class MyThemes {
  static final primary = Colors.blue;
  static final primaryColor = Colors.blue.shade300;

  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    primaryColorDark: primaryColor,
    colorScheme: ColorScheme.dark(primary: primary),
    dividerColor: Colors.white,
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.light(primary: primary),
    dividerColor: Colors.black,
  );
}
