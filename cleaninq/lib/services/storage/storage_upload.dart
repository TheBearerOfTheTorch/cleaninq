import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Uploader extends StatefulWidget {
  final File file;
  const Uploader({Key? key, required this.file}) : super(key: key);

  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  bool _isLoading = false;
   double _progress = 0.0;
  UploadTask? _uploadTask;

  void uploadImage(){
    final FirebaseStorage _storage = FirebaseStorage.instance;
    String filePath = 'cleaningService/${DateTime.now()}.png';
    setState(() {
      _isLoading = true;
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
  }
  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Upload to the cloud',
      icon: Icon(Icons.cloud_upload),
      onPressed: uploadImage,
    );
  }
}
