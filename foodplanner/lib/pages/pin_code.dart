import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/pin_code.dart';
import 'package:provider/provider.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:go_router/go_router.dart';

class PinCode extends StatefulWidget {
  const PinCode({super.key});
  static final PinService pinService = PinService(apiUrl: ApiConfig.baseUrl);

  @override
  PinCodeState createState() => PinCodeState();
}

class PinCodeState extends State<PinCode> {
  List<int> pin = [];

  void handlePin(int number) async {
    setState(() {
      pin.add(number);
    });
    if (pin.length == 4) {
      print("Pin: ${pin.join()}");

      var error = await PinCode.pinService.postPin(25, pin);
      if (error == null) {
        context.go('/');
      } else {
        print("Error: $error");
        setState(() {
          pin = [];
        });
      }
    }
  }

  void deletePin() {
    setState(() {
      pin.removeLast();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/logo.png'),
                opacity: 0.3,
                fit: BoxFit.contain,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Skriv pinkode",
                  style: AppTextStyles.title,
                ),
                Text("Skriv din pinkode for at låse op"),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    return SFIcon(
                      pin.length > index
                          ? SFIcons.sf_dot_square
                          : SFIcons.sf_square,
                      fontSize: 54,
                      color: AppColors.textFieldBorderFocus,
                      fontWeight: FontWeight.w200,
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.background,
        height: 250,
        child: Card(
          color: Colors.white,
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: List.generate(
                3,
                (index) {
                  return Row(
                    children: List.generate(
                      3,
                      (index2) {
                        int number = index * 3 + index2 + 1;
                        return Expanded(
                          child: TextButton(
                            onPressed:
                                pin.length < 4 ? () => handlePin(number) : null,
                            child: Text(
                              "$number",
                              style: AppTextStyles.buttonTextMedium
                                  .copyWith(color: Colors.black),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              )..add(
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {},
                          child: SFIcon(
                            SFIcons.sf_faceid,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () => {
                            handlePin(0),
                          },
                          child: Text("0",
                              style: AppTextStyles.buttonTextMedium
                                  .copyWith(color: Colors.black)),
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: deletePin,
                          child: SFIcon(SFIcons.sf_delete_left,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
            ),
          ),
        ),
      ),
    );
  }
}
