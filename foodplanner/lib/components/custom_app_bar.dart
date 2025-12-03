import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/config/text_styles.dart';

// New class for the header of a page to ensure conformity on all pages - design can be changed
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  final SFIcon? sfIcon;
  final Icon? materialIcon;

  const CustomAppBar({
    super.key,
    required this.title,
    this.sfIcon,
    this.materialIcon
  });

  @override
  Size get preferredSize => const Size.fromHeight(200);


  @override 
  Widget build(BuildContext context){
    return AppBar(
      backgroundColor: Colors.white,
      scrolledUnderElevation: 0, // ensures app bar continues being white
      toolbarHeight: 200, // should possible be changed?
      centerTitle: true,
      title: Padding(
        padding: const EdgeInsets.only(top: 100), // creating extra padding over the Title
        child: Text(
          title,
          style: TextStyle(fontSize: 36), // choice of text style already defined, not sure if this is the right one to use
          textAlign: TextAlign.center,
        ),
      ),
      // added icon under the title as part of the app bar
      bottom: sfIcon != null ? PreferredSize(
        preferredSize: Size(5, 5), 
        child: sfIcon!,   
      ) : materialIcon != null ? PreferredSize(
        preferredSize: Size(5, 5), 
        child: materialIcon!
      ) : null,
    );
  }
  
}