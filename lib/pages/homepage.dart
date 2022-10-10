import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/pages/my_feed_page.dart';
import 'package:instaclone/pages/my_likes_page.dart';
import 'package:instaclone/pages/my_profile_page.dart';
import 'package:instaclone/pages/my_search_page.dart';
import 'package:instaclone/pages/my_upload_page.dart';
class HomePage extends StatefulWidget {
  static final String id = "homepage";
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  int _curretTab = 0;
  @override
  void initState() {
    // TODO: implement initState

    _pageController = PageController();
  }
  @override


  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          MyFeedPage(pageController: _pageController,),
          MySearchPage(),
          MyUploadPage( pageController: _pageController,),
          MyLikespage(),
          MyProfilePage(),
        ],
        onPageChanged: (int index){
          setState(() {
            _curretTab = index;
          });
        },
      ),
      bottomNavigationBar: CupertinoTabBar(
        onTap: (int index){
          setState(() {
            _curretTab =index;
            _pageController.animateToPage(index,
                duration: Duration(milliseconds: 200), curve: Curves.easeIn);
          });
        },
        activeColor:  Color.fromRGBO(252, 175, 69, 1),
        currentIndex: _curretTab,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home,size: 32,)),
          BottomNavigationBarItem(icon: Icon(Icons.search,size: 32,)),
          BottomNavigationBarItem(icon: Icon(Icons.add_box,size: 32,)),
          BottomNavigationBarItem(icon: Icon(Icons.favorite,size: 32,)),
          BottomNavigationBarItem(icon: Icon(Icons.person,size: 32,)),
        ],
      ),
    );
  }
}
