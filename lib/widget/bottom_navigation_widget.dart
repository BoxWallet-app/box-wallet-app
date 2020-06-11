import 'package:box/page/main_page.dart';
import 'package:box/page/profile_page.dart';
import 'package:box/page/wallet_page.dart';
import 'package:flutter/material.dart';




class BottomNavigationWidget extends StatefulWidget {
  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
//  final _BottomNavigationColor = Colors.blue;
  int _currentIndex = 0;
  List<Widget> list = List();
  @override
  void initState(){
    list
      ..add(MainPage())
      ..add(WalletPage())
      ..add(ProfilePage());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: list[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon:Image(height:25,width: 25,image: AssetImage('images/nav_home.png')),
                activeIcon: Image(height:25,width: 25,image: AssetImage('images/nav_home_active.png')),
                title: Container()),


            BottomNavigationBarItem(
                icon:Image(height:25,width: 25,image: AssetImage('images/nav_wallet.png')),
                activeIcon: Image(height:25,width: 25,image: AssetImage('images/nav_wallet_active.png')),
                title: Container()),


            BottomNavigationBarItem(
                icon:Image(height:25,width: 25,image: AssetImage('images/nav_profile.png')),
                activeIcon: Image(height:25,width: 25,image: AssetImage('images/nav_profile_active.png')),
                title: Container()),
          ],
          currentIndex:_currentIndex,
          onTap:(int index){
            setState((){
              _currentIndex= index;
            });
          },
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          type:BottomNavigationBarType.fixed
      ),
    );
  }
}