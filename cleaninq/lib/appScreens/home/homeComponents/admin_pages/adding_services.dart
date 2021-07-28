import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cleaninq/services/middlewares/admin_add.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddingServices extends StatefulWidget {
  const AddingServices({Key? key}) : super(key: key);

  @override
  _AddingServicesState createState() => _AddingServicesState();
}

class _AddingServicesState extends State<AddingServices> {
  TextEditingController _titleController = TextEditingController() ;
  TextEditingController _descriptionController = TextEditingController() ;
  TextEditingController _otherController = TextEditingController() ;
  AdminServices  add = AdminServices();
  final _formKey = GlobalKey<FormState>();

  File? _image;
  String? imageUrl;
  final picker = ImagePicker();

  //loading progress
  bool _isLoading = false;
  double _progress = 0.0;
  String _finishMessage = "";

//picking the image
  Future getImage(ImageSource source) async{
     PickedFile? pickedImage = await picker.getImage(source: source);

     setState(() {
       _image = File(pickedImage!.path);
     });
   }
  @override
  void initState()
  {
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _otherController = TextEditingController();
    super.initState();
  }

  @override
  void dispose()
  {
    _titleController.dispose();
    _descriptionController.dispose();
    _otherController.dispose();
    super.dispose();
  }
  final FirebaseStorage _storage = FirebaseStorage.instance;
  UploadTask? _uploadTask;
  String filePath = 'cleaningService/${DateTime.now()}';

//uploadling image to firebase storage and to firestore
 Future uploadImage(String servicename,String serviceDescript) async{

    setState(() {
      _isLoading = true;
      _uploadTask = _storage.ref().child(filePath).putFile(_image!);
    });
    var download = await (await _uploadTask!.whenComplete(() => null)).ref.getDownloadURL();
    imageUrl = await (await _uploadTask!.whenComplete(() => null)).ref.getDownloadURL();
    await add.addService(servicename, serviceDescript, download);
    return download;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: _isLoading == true ?
     StreamBuilder(
      stream: _uploadTask!.snapshotEvents,
        builder: (context,snapshot){
            if (snapshot.hasData) {
            _uploadTask!.snapshotEvents.lastWhere((TaskSnapshot event) {
              setState(() {
                _progress = (event.bytesTransferred.toDouble() /
                    event.totalBytes.toDouble()) * 100;
                  _isLoading = false;
                  _image = null;
                  _finishMessage = "Service";
              });
              return _isLoading;
            });
          }
          return  Scaffold(
            appBar: AppBar(

              bottom: PreferredSize(
                child: LinearProgressIndicator(
                  value: _progress,
                  color: Colors.amber,
                ),
                preferredSize: Size(MediaQuery.of(context).size.width, 5.0),
              )
            ),
            body: Center(
              child: Container(
                margin: EdgeInsets.only(),
                  child: CircularProgressIndicator(
                    color: Colors.orangeAccent,
                  )
              ),
            ),
          );
        }
    )
        :Scaffold(
      appBar: AppBar(
        bottom: _isLoading ? PreferredSize(
          child: LinearProgressIndicator(
            value: _progress,
          ),
          preferredSize: Size(MediaQuery.of(context).size.width, 5.0),
        ) : null,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: Icon(Icons.photo_camera,
              color: Colors.orangeAccent
            ),
                onPressed: ()=> getImage(ImageSource.camera)),
            IconButton(icon: Icon(Icons.photo_library,
                color: Colors.orangeAccent
            ),
                onPressed: ()=> getImage(ImageSource.gallery)),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child:Form(
          key:_formKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              margin:EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  if(_finishMessage != "")
                       Row(
                          mainAxisSize: MainAxisSize.min,
                          children:[
                          const SizedBox(width: 20.0, height: 100.0),
                          Text(
                            _finishMessage,
                            style: TextStyle(fontSize: 25.0,
                                color: Colors.orange),
                          ),
                          const SizedBox(width: 10.0, height: 100.0),
                          DefaultTextStyle(
                            style: const TextStyle(
                              fontSize: 23.0,
                              fontFamily: 'Horizon',
                              color: Colors.amber
                            ),
                            child: AnimatedTextKit(
                                animatedTexts: [
                                  RotateAnimatedText('WAS'),
                                  RotateAnimatedText('UPLOADED'),
                                  RotateAnimatedText('SUCCESSFULLY'),
                                ],
                          ),
                        ),
                        ],
                      ),
                  TextFormField(
                      controller:_titleController,
                      validator: (val)=>
                      val!.isNotEmpty ? null:"Please enter the name of the service",
                      decoration:InputDecoration(
                          hintText: "service",
                          prefixIcon:Icon(Icons.add_business_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )
                      )
                  ),
                  SizedBox(height:10),
                  TextFormField(
                      controller:_descriptionController,
                      validator: (val)=>
                      val!.isNotEmpty ? null:"Please enter the description",
                      decoration:InputDecoration(
                          hintText: "Description",
                          prefixIcon:Icon(Icons.zoom_out_map_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )
                      ),
                    maxLines: 5,
                  ),
                  SizedBox(height:10),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: _image != null?Image.file(_image!):
                        Text("No image was selected")
                  ),
                  SizedBox(height:30),
                  MaterialButton(
                      onPressed:() async{
                          if(_formKey.currentState!.validate()) {
                            uploadImage(_titleController.text.trim(), _descriptionController.text.trim());
                          }
                        },
                      height:60,
                      minWidth: double.infinity,
                      color: Theme.of(context).primaryColor,
                      textColor:Colors.white,
                      shape:RoundedRectangleBorder(
                        borderRadius:BorderRadius.circular(10),
                      ),
                      child:Center(
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.cloud_upload_outlined,
                                color:Colors.orangeAccent
                            ),
                            Text("Upload files" ,
                                style:TextStyle(fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color:Colors.orangeAccent,
                                )
                            )
                          ],
                        )

                  )),
                  SizedBox(height: 10,),
                ],
              ),
            ),
          )
        )
      ),
    )
    );
  }
}
