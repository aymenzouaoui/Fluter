
import '../gestion_user/list.dart';


import 'package:flutter/widgets.dart';

class HomeList {
  HomeList({
    this.navigateScreen,
    this.imagePath = '',
  });

  Widget? navigateScreen;
  String imagePath;

  static List<HomeList> homeList = [
  
    HomeList(
      imagePath: 'assets/images/admin.png',
      navigateScreen: UserListScreen(),
    ),

    
    HomeList(
      imagePath: 'assets/images/box.png',
      
    ),
    HomeList(
      imagePath: 'assets/images/quiz.png',
 
    ),
     HomeList(
      imagePath: 'assets/images/event.png',
 
    ),
     HomeList(
      imagePath: 'assets/introduction_animation/introduction_animation.png',
     
    ),
  ];
}
