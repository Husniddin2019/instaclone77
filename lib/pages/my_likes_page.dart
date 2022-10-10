import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:instaclone/servise/date_servise.dart';

import '../model/post_model.dart';
import '../servise/utils_servise.dart';
class MyLikespage extends StatefulWidget {
  const MyLikespage({Key? key}) : super(key: key);

  @override
  State<MyLikespage> createState() => _MyLikespageState();
}

class _MyLikespageState extends State<MyLikespage> {
  List <Post> items = [];
  bool isLoading = false;

  void _apiLoadLikes(){
    setState(() {
      isLoading =true;
    });
    DataServise.loadLikes().then((value) => {_resLoadLikes(value),});
  }

  _removePost(Post post) async{

    var result = await Utils.dialogCommon(context, "Instagramm", "Ochirish?", false);
    if(result != null && result){
      DataServise.removePost(post);
    }
  }

  void _resLoadLikes(List<Post> posts){
    setState(() {
      items=posts;
      isLoading =false;
    });

  }
  void _apiPostUnLike(Post post) async {
    setState(() {
      isLoading = true;
    });
    await DataServise.likePost(post, false);
    setState(() {
      isLoading = false;
      post.liked = false;
    });
  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiLoadLikes();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white12,
        elevation: 0,
        title: Text("Likes",style: TextStyle(fontFamily: 'Billabong',fontSize: 30,color: Colors.black),),

      ),
      body: Stack(
        children: [
          items.length >0 ?
          ListView.builder(
            itemCount: items.length,
            itemBuilder: (ctx , index){
              return _itemsPost( items[index]);
            },
          ):Center(child: Text("no likes profil"),),
          isLoading ? Center(child: CircularProgressIndicator()):SizedBox.shrink(),
        ],
      )
    );
  }
  Widget _itemsPost(Post post){
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Divider(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image(
                        image: AssetImage("assets/images/1c_person.png"),
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 10,),
                    Column(
                      children: [
                        Text(post.fullname!, style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
                        Text(post.date!, style: TextStyle(fontWeight: FontWeight.normal),)
                      ],
                    ),

                  ],
                ),
                post.mine?
                IconButton(onPressed: (){
                  _removePost(post);

                }, icon:  Icon(Icons.more_horiz)): SizedBox.shrink(),
              ],
            ),
          ),
          CachedNetworkImage(
            imageUrl: post.img_post!,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context,url,error) => Icon(Icons.error),),
          //Image.network(post.postImage,fit: BoxFit.cover,),
          Row(
            children: <Widget>[
              IconButton(onPressed: (){if (post.liked){
                _apiPostUnLike(post);}},
                 icon: post.liked? Icon(FontAwesome.heart,color: Colors.red,):Icon(FontAwesome.heart_empty,) ),

                IconButton(onPressed: (){}, icon: Icon(FontAwesome.share),),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(left: 10,right: 10,bottom: 10),
            child: RichText(
              softWrap: true,
              overflow: TextOverflow.visible,
              text: TextSpan(
                  children: [
                    TextSpan(
                      text: "${post.caption}",
                      style: TextStyle(color: Colors.black),
                    )
                  ]

              ),
            ),
          )
        ],
      ),


    );






  }
}

