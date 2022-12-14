import 'package:flutter/material.dart';
import 'package:instaclone/pages/my_profile_page.dart';

import '../model/user_model.dart';
import '../servise/date_servise.dart';
class MySearchPage extends StatefulWidget {
  const MySearchPage({Key? key}) : super(key: key);

  @override
  State<MySearchPage> createState() => _MySearchPageState();
}

class _MySearchPageState extends State<MySearchPage> {
  List <Users> items = [];
  bool isLoading = false;


  void _apiSearchUsers(String keyword){
    DataServise.searchUsers(keyword).then((users) => {
      _respSearchUsers(users),
    });}

    _respSearchUsers(List<Users> users){
      setState(() {
        items = users;
      });
    }
  void _apiFollowUser(Users someone) async{
    setState(() {
      isLoading = true;
    });
    await DataServise.followUser(someone);
    setState(() {
      someone.followed = true;
      isLoading = false;
    });
    DataServise.storePostsToMyFeed(someone);
  }

  void _apiUnfollowUser(Users someone) async{
    setState(() {
      isLoading = true;
    });
    await DataServise.unfollowUser(someone);
    setState(() {
      someone.followed = false;
      isLoading = false;
    });
    DataServise.removePostsFromMyFeed(someone);
  }


  var searchController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiSearchUsers("");



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
backgroundColor: Colors.white,
      appBar: AppBar(
      backgroundColor: Colors.white,
      title: Text("Search", style: TextStyle(fontFamily: 'Billabong',color: Colors.black),),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20,right: 20),
        child: Column(
          children: [
            //qidirish
            Container(height: 40,
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.only(left: 10,right: 10),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(7),
            ),
            child: TextField(
              style: TextStyle(color: Colors.black87),
              controller: searchController,
              onChanged: (input){
                print(input);
              },
              decoration: InputDecoration(
                hintText: "Search",
                border: InputBorder.none,
                hintStyle: TextStyle(fontSize: 15.0,color: Colors.grey),
                icon: Icon(Icons.search,color: Colors.grey,)
              ),
            ),),

            Expanded(child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (ctx, index){
                  return _itemsofUser(items[index]);

            }))
          ],
        ),
      )
    );
  }
  Widget _itemsofUser(Users user){
    return Container(
      height: 90,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(70),
              border: Border.all(width: 1.5,color: Color.fromRGBO(193, 53, 132, 1),)
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22.5),
              child: user.img_url == null || user.img_url.isEmpty ?
              ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child:  Image(image: AssetImage("assets/images/1c_person.png"),width: 45,height: 45,fit: BoxFit.cover,),
              ):
              ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child:  Image.network(user.img_url,width: 45,height: 45,fit: BoxFit.cover,),
              ),
            ),
          ),
          SizedBox(width: 15,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.fullname.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 3,),
              Text(user.email!,style: TextStyle(color: Colors.black54),),
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                GestureDetector(
                  onTap: (){
                    if(user.followed){
                      _apiUnfollowUser(user);
                    }else{
                      _apiFollowUser(user);
                    }
                  },
                  child: Container(
                    width: 100,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: Center(
                      child: user.followed ? Text("Following") : Text("Follow"),
                    ),
                  ),
                ),

              ],
            ),
          ),

        ],
      ),
    );
  }
}