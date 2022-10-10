import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaclone/model/post_model.dart';
import 'package:instaclone/servise/file_service.dart';
import '../servise/date_servise.dart';

class MyUploadPage extends StatefulWidget {
  PageController pageController;
  MyUploadPage({required this.pageController});

  @override
  State<MyUploadPage> createState() => _MyUploadPageState();
}

class _MyUploadPageState extends State<MyUploadPage> {
  var captionController = TextEditingController();

  File? _image;
  bool isLoading = false;
  final picker = ImagePicker();

  _uploadNewPost() {
    String caption = captionController.text.toString().trim();
    // if (caption.isEmpty) return;
    // if (_image == null) return;
    _apiPost();

  }
  void _apiPost(){
    FileService.uploadPostImage(_image!).then((dowmloadUrl) => {
      _resPostImage(dowmloadUrl!),
    });
  }
  void _resPostImage(String downloadUrl){
    setState(() {
      isLoading=true;
    });
    String caption = captionController.text.toString().trim();
    Post post = new Post (caption: caption,img_post: downloadUrl);
    _apiStorePost(post);
  }
  void _apiStorePost(Post post)async{
    Post posted = await DataServise.storePost(post);
    DataServise.storeFeed(posted).then((value) => {
      _moveFeed(),
    });

  }


  void _moveFeed(){
    setState(() {
      isLoading=false;
    });
    captionController.text="";
    _image=null;

    widget.pageController.animateToPage(0,
        duration: Duration(milliseconds: 200), curve: Curves.easeIn);
  }

  Future _imgFromCamera() async {
    //final pickedFile = await picker.getImage(source: ImageSource.gallery);
    final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  Future _imgFromGallery() async {
    //final pickedFile = await picker.getImage(source: ImageSource.gallery);
    final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Upload", style: TextStyle(
            color: Colors.black, fontFamily: 'BillaBong', fontSize: 25),
        ),
        actions: [
          IconButton(onPressed: () {
            _uploadNewPost();
          },
              icon: Icon(
                Icons.post_add, color: Color.fromRGBO(245, 96, 64, 1),)),
        ],

      ),
      body: Stack(
        children: [
          SingleChildScrollView(child:
          Container(height: MediaQuery
              .of(context)
              .size
              .height, child: Column(
            children: [
              GestureDetector(

                onTap: _imgFromGallery,
                //(){_showPicker(context);},
                child: Container(
                    width: double.infinity,
                    height: MediaQuery
                        .of(context)
                        .size
                        .width,
                    color: Colors.grey.withOpacity(0.4),
                    child: _image == null ?
                    Center(
                      child: Icon(Icons.add_a_photo, size: 60, color: Colors.grey,),
                    ) :
                    Stack(
                      children: [
                        Image.file(File(_image!.path), width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,),
                        Container(
                          width: double.infinity,
                          color: Colors.black12,
                          padding: EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(onPressed: () {
                                setState(() {
                                  _image = null!;
                                });
                              }, icon: Icon(Icons.highlight_remove),
                                color: Colors.white,)
                            ],
                          ),
                        ),
                      ],
                    )

                ),
              ),

              Container(
                margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                child: TextField(
                  controller: captionController,
                  style: TextStyle(color: Colors.black),
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Caption",
                    hintStyle: TextStyle(fontSize: 17.0, color: Colors.black38),
                  ),
                ),
              )
            ],
          ),)),
          isLoading ? Center(child:CircularProgressIndicator(),):SizedBox.shrink(),
        ],
      )




    );
  }
}
