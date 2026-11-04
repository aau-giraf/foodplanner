import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';

// New class for the header of a page to ensure conformity on all pages - design can be changed
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  final SFIcon? sfIcon;
  final Icon? materialIcon;
  final double screenHeight;

  const CustomAppBar({
    super.key,
    required this.title,
    this.sfIcon,
    this.materialIcon,
    required this.screenHeight,
  });

  @override
  Size get preferredSize => Size.fromHeight(screenHeight * 0.25);


  @override 
  Widget build(BuildContext context){
    return AppBar(
      backgroundColor: Colors.white,
      scrolledUnderElevation: 0, // ensures app bar continues being white
      toolbarHeight: screenHeight * 0.25, // should possible be changed?
      centerTitle: true,
      title: Column (
        mainAxisSize: MainAxisSize.min,
        children: [
        SizedBox(height: screenHeight * 0.05), 
        Text(
          title,
          style: TextStyle(fontSize: screenHeight * 0.04), // choice of text style already defined, not sure if this is the right one to use
          textAlign: TextAlign.center,
        ),
        SizedBox(height: screenHeight * 0.02,),
        // added icon under the title as part of the app bar
        if (sfIcon != null) sfIcon!,
        if (materialIcon != null) materialIcon!,
        ],
      ),
    );
  }
  
}