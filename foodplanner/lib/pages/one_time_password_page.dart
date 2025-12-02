import 'dart:developer' as developer;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/text_field.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/pages/forgot_password_page.dart';
import 'signup_page.dart';
import 'package:foodplanner/services/fetch_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:foodplanner/models/user_roles.dart';

//test push
class OneTimePasswordPage extends StatefulWidget {
  const OneTimePasswordPage({super.key});
  static final AuthService authService = AuthService(apiUrl: ApiConfig.baseUrl);

  @override
  OneTimePasswordPageState createState() => OneTimePasswordPageState();
}

class OneTimePasswordPageState extends State<OneTimePasswordPage> {
    List<String> oneTimePaswords = [
    "aG7K2p",
    "Q9mL4v",
    "tR8b1Z",
    "Xf2D6q",
    "wH3s9P",
    "J7uK0r",
    "nP6Q4x",
    "B2cV8m",
    "zT1yR5",
    "Kp9F3a",
  ];

  late String oneTimePasword = oneTimePaswords[Random().nextInt(oneTimePaswords.length - 1)];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Egebakkeskolen\nFoodplanner',
          style: AppTextStyles.title,
          textAlign: TextAlign.center,
        ),
      ),
       body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Row(
              children: [
                Text("Mads Vind Knudsen"),
                _buildExpanded()
              ]
            ),
            Divider(),

            Row(
              children: [
                Text("Elias Linde Jespersen"),
                _buildExpanded()
              ]
            ),
          ]
        ),
      ),
    );
  }
}


// I think I will use a dropwdown componenet from software instead!
Widget _buildExpanded() {
  return Expanded(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        // Expanded(
          DecoratedBox(
            decoration: BoxDecoration(border: BoxBorder.all()),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                  child: Text(
                    "vind",
                    // oneTimePasword,
                    style: AppTextStyles.bigText,
                  ),
                ),
                IconButton(
                  icon: SFIcon(
                    SFIcons.sf_doc_on_doc_fill,
                    color: AppColors.textPrimary,
                    fontSize: 20,
                  ),
                  onPressed: () {
                    return;
                    // setState(() {
                    //   Clipboard.setData(ClipboardData(text: oneTimePasword));
                    // });
                  },
                ),
                IconButton(
                  icon: SFIcon(
                    SFIcons.sf_arrow_2_squarepath,
                    color: AppColors.textPrimary,
                    fontSize: 24,
                  ),
                  onPressed: () {
                    return;
                    // setState(() {
                    //   oneTimePasword = oneTimePaswords[Random().nextInt(oneTimePaswords.length - 1)]; 
                    // });
                  },
                ),
              ],
            ),
          ),
        // ),
      ],
    ),
  );

}
// {
//   'title': 'Engangskode: ',
//   'showIcon': false,
//   'isEditable': isEditingFirstName,
//   'cta': Expanded(
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: <Widget>[
//         // Expanded(
//           DecoratedBox(
//             decoration: BoxDecoration(border: BoxBorder.all()),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Padding(
//                   padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
//                   child: Text(
//                     oneTimePasword,
//                     style: AppTextStyles.bigText,
//                   ),
//                 ),
//                 IconButton(
//                   icon: SFIcon(
//                     SFIcons.sf_doc_on_doc_fill,
//                     color: AppColors.textPrimary,
//                     fontSize: 20,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       Clipboard.setData(ClipboardData(text: oneTimePasword));
//                     });
//                   },
//                 ),
//                 IconButton(
//                   icon: SFIcon(
//                     SFIcons.sf_arrow_2_squarepath,
//                     color: AppColors.textPrimary,
//                     fontSize: 24,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       oneTimePasword = oneTimePaswords[Random().nextInt(oneTimePaswords.length - 1)]; 
//                     });
//                   },
//                 ),
//               ],
//             ),
//           ),
//         // ),
//       ],
//     ),
//   ),
//   'showSpacer': false,
// },