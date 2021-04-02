import 'dart:typed_data';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:temp1/api.dart';

import 'app_theme.dart';

class UploadImageDemo extends StatefulWidget {
  final String email;

  UploadImageDemo({Key key, @required this.email,}) : super(key: key);
  @override
  UploadImageDemoState createState() => UploadImageDemoState();
}

class UploadImageDemoState extends State<UploadImageDemo> {
  //
  CloudApi api;
  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';

  File _image;
  Uint8List _imageBytes;

  @override
  initState(){
    super.initState();
    api = CloudApi();
  }
  chooseImage() async {
    file  =  ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if(file != null){
        file.then((image) => {
          // print(image.path),
          // print(image.path.split('/').last),
          _image = File(image.path),
          _imageBytes = _image.readAsBytesSync(),
        });
      } else {
        print('No image selected');
      }
    });
    setStatus('');
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  startUpload() async {
    setStatus('Uploading Image...');
    if (null == tmpFile) {
      setStatus(errMessage);
      return;
    }
    String fileType = tmpFile.path.split('.').last;
    var uuid = Uuid();
    String fileName =  uuid.v1().toString() + '.' + fileType ;
    final response = await api.save(fileName, _imageBytes);
    updateImageToBackend(widget.email, response.downloadLink.toString());
    setStatus('Done...');
    Navigator.pop(context, );
  }


  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return Flexible(
            child: Image.file(
              snapshot.data,
              fit: BoxFit.fill,
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Set New Image",
          style: TextStyle(
            fontSize: 22,
            color: AppTheme.darkText,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppTheme.white,
      ),
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            OutlineButton(
              onPressed: chooseImage,
              child: Text('Choose Image'),
            ),
            SizedBox(
              height: 20.0,
            ),
            showImage(),
            SizedBox(
              height: 20.0,
            ),
            OutlineButton(
              onPressed: startUpload,
              child: Text('Upload Image'),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              status,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w500,
                fontSize: 20.0,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }

  Future <bool> updateImageToBackend(String email, String imageURL) async {
    Response response = await post("https://dont-wait.herokuapp.com/image",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'email': email, 'url': imageURL}));

    var jsonResponse = jsonDecode(response.body);
    if(jsonResponse['error'] != null){
      // print(jsonResponse['error']);
      return false;
    }
    else if (jsonResponse['message'] != null){
      // print (jsonResponse['message']);
      return true;
    }
    return false;
  }
  Widget appBar() {
    return SizedBox(
      height: AppBar().preferredSize.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Sign UP Page',
                  style: TextStyle(
                    fontSize: 22,
                    color: AppTheme.darkText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}