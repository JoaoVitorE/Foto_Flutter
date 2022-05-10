import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foto App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final picker = ImagePicker();
  File? _selectedImage;
  bool _inProcess = false;

  getImage(ImageSource src) async {
    this.setState(() {
      _inProcess = true;
    });
    final pickedFile = await picker.pickImage(source: src);
    if (pickedFile != null) {
      final croppedFile = await ImageCropper()
          .cropImage(sourcePath: pickedFile.path, aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ]);
      setState(() {
        _selectedImage = croppedFile as File;
        _inProcess = false;
      });
    } else {
      setState(() {
        _inProcess = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera'),
      ),
      body: (_inProcess)
          ? Container(
              color: Colors.white,
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
              child: SizedBox(
                width: 70,
                height: 70,
                child: CircularProgressIndicator(
                  strokeWidth: 5.0,
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _selectedImage != null
                    ? Image.file(
                        _selectedImage!,
                        width: 250,
                        height: 250,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 250,
                        height: 250,
                        child: Icon(
                          Icons.camera_alt,
                          size: 200,
                          color: Colors.grey,
                        ),
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        getImage(ImageSource.camera);
                      },
                      child: Text('Camera'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        getImage(ImageSource.gallery);
                      },
                      child: Text('Galeria'),
                    ),
                  ],
                )
              ],
            ),
    );
  }
}
