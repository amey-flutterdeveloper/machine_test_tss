import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({super.key});

  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  File? _imageFile ;
  String? _fileName;
   String? _fileSize;
  final ImagePicker _picker = ImagePicker();
  
  Future<void> _pickImage(ImageSource source) async{
    final pickedFile = await _picker.pickImage(source: source);
    if(pickedFile !=null) {
      final file = File(pickedFile.path);
      final sizeInKB = (await file.length()) /1024;
      setState(() {
        _imageFile = file;
        _fileName = pickedFile.name;
        _fileSize = "${sizeInKB.toStringAsFixed(2)} KB";
      });
    }
  }

  void _resetImage(){
    setState(() {
      _imageFile = null;
      _fileName = null;
      _fileSize = null;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.deepPurple,
          title: Text('Image Picker with Animation',style: TextStyle(color: Colors.white),),
        ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: ()async{
                final source = await showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Pick Image'),
                      actions: [
                        TextButton(onPressed:()=>
                            Navigator.pop(ctx,ImageSource.camera), 
                            child: Text('Camera')), 
                        
                        TextButton(onPressed:()=>
                            Navigator.pop(ctx,ImageSource.gallery), 
                            child: Text('Gallery')),
                      ],
                    ));
                if(source != null) _pickImage(source);
              },
            child: AnimatedSwitcher(
                duration:Duration(milliseconds: 500),
            transitionBuilder: (child,animation){
                  return ScaleTransition(
                      scale: animation,
                  child: child,);
            },
            child: _imageFile == null ?
              Container(
                key: ValueKey("placeholder"),
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
              child: Icon(Icons.add_a_photo,size: 50,
              color: Colors.white,),):
                ClipOval(
                  key: ValueKey("image"),
                  child: Image.file(_imageFile!,width: 150,
                  height: 150,
                  fit: BoxFit.cover,),
                )
            )
            ),
            const SizedBox(
              height: 20,
            ),
            if(_fileName !=null && _fileSize != null)...[
              Text("File: $_fileName"),
              Text("File: $_fileSize"),
              const SizedBox(
                height: 20,
              ),
              if(_imageFile != null) 
                ElevatedButton(onPressed: _resetImage, 
                    child:Text('Reset'))
            ],
            
          ],
        ),
      ),
    );
  }
}
