import 'dart:ffi';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaclone/model/user_model.dart';
import 'package:instaclone/servise/date_servise.dart';

import '../model/post_model.dart';
import '../servise/auth_servise.dart';
import '../servise/file_service.dart';
import '../servise/utils_servise.dart';
class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  List <Post> items = [];
  String? fullname;
  bool isLoading = false;
  String? email;  String img_url="";
  int count_posts = 0;
  int i = 1;
  int followers_count= 0;
  int following_count= 0;
 void _apiLoadPoss(){
   DataServise.loadPosts().then((value) => {
     _resLoadPost(value),
   });
 }
 void _resLoadPost(List<Post> posts){
setState(() {
  items = posts;
  count_posts = items.length;
});
 }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiLoadPoss();

    _apiLoadUser();
  }

  late File _image;
  final picker = ImagePicker();
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
      _apichangephoto();
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
      _apichangephoto();
    });
  }
   void _apichangephoto(){

     if (_image == null) return;
     setState(() {
       isLoading = true;
     });

     FileService.uploadUserImage(_image).then((downloadUrl) => {
       _apiUpdateUser(downloadUrl!),
     });
   }
  void _apiUpdateUser(String downloadUrl) async {
    Users user = await DataServise.loadUser();
    user.img_url = downloadUrl;
    await DataServise.updateUser(user);
    _apiLoadUser();
  }


  void _apiLoadUser() {
    setState(() {
      isLoading = true;
    });
    DataServise.loadUser().then((value) => {
      _showUserInfo(value),
    });
  }


  void _showUserInfo(Users user){
    setState(() {
      isLoading = false;
        fullname = user.fullname;
        img_url = user.img_url;
        print("$fullname fulname" );
        email = user.email;
        print("$email email" );
        print("${user.device_token} token" );
        followers_count=user.followers_count;
        following_count=user.followers_count;
        });



  }

  _actionLogout() async{

    var result = await Utils.dialogCommon(context, "Instagramm", "Chiqasizmi?", false);
    if(result != null && result){
     AuthService.signOutUser(context);
    }
  }
  _removePost(Post post) async{

    var result = await Utils.dialogCommon(context, "Instagramm", "Ochirish?", false);
    if(result != null && result){
      DataServise.removePost(post);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.white12,
      elevation: 0,
      title: Text("Profile",style: TextStyle(fontFamily: 'Billabong',fontSize: 30,color: Colors.black),),
      actions: [IconButton(
        onPressed: () {
          _actionLogout();
        },
        icon: Icon(Icons.exit_to_app),
        color: Color.fromRGBO(193, 53, 132, 1),
      ),],),

        body: Stack(
          children: [
             Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),

            child: Column(

              children: [
                //rasm
                Stack (
                  alignment: Alignment.bottomRight,
                  children: [

                    Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(70),
                          border: Border.all(width: 1.5,color: Color.fromRGBO(195, 53, 132, 1),)
                      ),
                      child: img_url == null || img_url.isEmpty ?
                      ClipRRect(
                        borderRadius: BorderRadius.circular(35),
                        child:  Image(image: AssetImage("assets/images/1c_person.png"),width: 70,height: 70,fit: BoxFit.cover,),
                      ):
                      ClipRRect(
                        borderRadius: BorderRadius.circular(35),
                        child:  Image.network(img_url,width: 70,height: 70,fit: BoxFit.cover,),
                      ),
                    ),
                    IconButton(onPressed: (){_showPicker(context);},
                        icon: Icon(Icons.add_circle,color: Colors.white,)),



                  ],
                ),





                //malumot
                SizedBox(height: 10,),
                Text(fullname==null?"null":fullname!,style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.normal),),
                SizedBox(height: 3,),
                Text(email==null?"null":email!,style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.normal),),
                Container(
                  height: 80,
                  child: Row(
                    children: [
                      Expanded(child: Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(count_posts.toString(),style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),
                          Text("POSTS",style: TextStyle(color: Colors.grey,fontSize: 14,fontWeight: FontWeight.normal),),

                        ],
                      ),)),
                      Container(width: 1,height: 20,color: Colors.grey.withOpacity(0.5),),
                      Expanded(child: Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Followers",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),
                          Text(followers_count.toString(),style: TextStyle(color: Colors.grey,fontSize: 14,fontWeight: FontWeight.normal),),

                        ],
                      ),)),
                      Container(width: 1,height: 20,color: Colors.grey.withOpacity(0.5),),
                      Expanded(child: Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Following",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),
                          Text(following_count.toString(),style: TextStyle(color: Colors.grey,fontSize: 14,fontWeight: FontWeight.normal),),

                        ],
                      ),)),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Center(
                        child:  IconButton(onPressed: (){
                          i=1;
                          setState(() {
                            i;
                          });
                        }, icon: Icon(Icons.list_alt)),
                      ),
                      SizedBox(width: 10,),
                      Center(
                        child:  IconButton(onPressed: (){
                          i=2;
                          setState(() {
                            i;
                          });
                        }, icon: Icon(Icons.grid_view_outlined)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.builder( itemCount :items.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: i),
                      itemBuilder: (ctx,index){
                        return _itemOfPost(items[index]);
                      }),
                ),


              ],

            ),
          ),

            isLoading?
                Center(
                  child: CircularProgressIndicator(),
                ):SizedBox.shrink(),
          ],
        )
    );
  }
  Widget _itemOfPost(Post post) {
    return GestureDetector(
        onLongPress: (){
          _removePost(post);
        },
        child: Container(
          margin: EdgeInsets.all(5),
          child: Column(
            children: [
              Expanded(
                child: CachedNetworkImage(
                  width: double.infinity,
                  imageUrl: post.img_post!,
                  placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                post.caption!,
                style: TextStyle(color: Colors.black87.withOpacity(0.7)),
                maxLines: 2,
              ),
            ],
          ),
        )
    );
  }
}

