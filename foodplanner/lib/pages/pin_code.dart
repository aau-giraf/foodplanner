import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/text_field.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:foodplanner/routes/user_roles.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/pin_code.dart';
import 'package:go_router/go_router.dart';


class PinCode extends StatefulWidget {
  const PinCode({
    super.key,
  });
  static final PinService pinService = PinService(apiUrl: ApiConfig.baseUrl);

  @override
  PinCodeState createState() => PinCodeState();
}

class PinCodeState extends State<PinCode> with SingleTickerProviderStateMixin {
  List<int> pin = [];
  List<int> createPinCode = [];
  List<int> confirmPinCode = [];
  String error = "";
  late AnimationController _controller;
  late Animation<double> _animation;

  bool hasPinCode = false;

  @override
  void initState() {
    super.initState();

    PinCode.pinService.hasPin().then((hasPin) {
      if (hasPin == true || hasPin == false) {
        setState(() {
          hasPinCode = hasPin;
        });
      } else {
        print("Error: $hasPin");
      }
    });

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: -10.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticIn,
      ),
    );

    _controller.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        }
      },
    );
  }

  void triggerWiggle() {
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void updateErrorState(String field, String error) {
    setState(() {
      if (field == "Message") {
        this.error = error;
        triggerWiggle();
      }
    });
  }

  void handleErrors(Map<String, dynamic> error) {
    updateErrorState(
        'Message', error['Message'] != null ? error['Message'][0] : '');
  }

  void handlePin(int number) async {
    setState(() {
      pin.add(number);
      error = "";
    });
    if (pin.length == 4) {
      var error = await PinCode.pinService.checkPin(pin);
      await Future.delayed(Duration(milliseconds: 300));
      if (error == null) {
        navigateToRole(role);
      } else {
        setState(() {
          pin = [];
          handleErrors(error);
        });
      }
    }
  }

    void navigateToRole(ROLES role) {
      switch(role) {
        case ROLES.guardian: 
          GoRouter.of(context).go(PARENT_ROOT);
          break;
        case ROLES.teacher: 
          GoRouter.of(context).go(TEACHER_ROOT);
          break;
        case ROLES.student:
          GoRouter.of(context).go(STUDENT_UNLOCKED);
        default:
          break;
      }
    }

  void handleCreatePin(String type, int number) async {
    setState(() {
      if (type == "create") {
        createPinCode.add(number);
      } else {
        confirmPinCode.add(number);
      }
      error = "";
    });
    if (confirmPinCode.length == 4) {
      if (createPinCode.join() == confirmPinCode.join()) {
        var error = await PinCode.pinService.updatePin(confirmPinCode);
        if (error == null) {
          Navigator.of(context).pop();
        } else {
          setState(() {
            createPinCode = [];
            confirmPinCode = [];
            handleErrors(error);
          });
        }
      } else {
        setState(() {
          createPinCode = [];
          confirmPinCode = [];
          handleErrors({
            "Message": ["Pinkoderne matcher ikke"],
          });
        });
      }
    }
  }

  void deletePin() {
    setState(() {
      if (pin.isNotEmpty) {
        pin.removeLast();
      }
    });
  }

  void deleteCreatePin(String type) {
    setState(() {
      if (type == "create") {
        if (createPinCode.isNotEmpty) {
          createPinCode.removeLast();
        }
      } else {
        if (confirmPinCode.isNotEmpty) {
          confirmPinCode.removeLast();
        } else {
          createPinCode.removeLast();
        }
      }
    });
  }

  Widget typePin() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Skriv pinkode",
          style: AppTextStyles.title,
        ),
        Text("Skriv din pinkode for at låse op"),
        SizedBox(height: 20),
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_animation.value, 0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  4,
                  (index) {
                    return SFIcon(
                      pin.length > index
                          ? SFIcons.sf_dot_square
                          : SFIcons.sf_square,
                      fontSize: 54,
                      color: error.isEmpty
                          ? AppColors.textFieldBorderFocus
                          : AppColors.errorText,
                      fontWeight: FontWeight.w200,
                    );
                  },
                ),
              ),
            );
          },
        ),
        SizedBox(height: 10),
        Text(
          error,
          style: AppTextStyles.errorText,
        ),
      ],
    );
  }

  Widget createPin() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          createPinCode.length < 4 ? "Opret pinkode" : "Bekræft pinkode",
          style: AppTextStyles.title,
        ),
        Text("Skriv en ny pinkode for at låse op"),
        SizedBox(height: 20),
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_animation.value, 0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: createPinCode.length < 4
                    ? List.generate(
                        4,
                        (index) {
                          return SFIcon(
                            createPinCode.length > index
                                ? SFIcons.sf_dot_square
                                : SFIcons.sf_square,
                            fontSize: 54,
                            color: error.isEmpty
                                ? AppColors.textFieldBorderFocus
                                : AppColors.errorText,
                            fontWeight: FontWeight.w200,
                          );
                        },
                      )
                    : List.generate(
                        4,
                        (index) {
                          return SFIcon(
                            confirmPinCode.length > index
                                ? SFIcons.sf_dot_square
                                : SFIcons.sf_square,
                            fontSize: 54,
                            color: error.isEmpty
                                ? AppColors.textFieldBorderFocus
                                : AppColors.errorText,
                            fontWeight: FontWeight.w200,
                          );
                        },
                      ),
              ),
            );
          },
        ),
        SizedBox(height: 10),
        Text(
          error,
          style: AppTextStyles.errorText,
        ),
      ],
    );
  }
  
  ROLES role = ROLES.student;
  //final usernameController = TextEditingController();
  //String emailError = '';
  
  Widget chooseRole() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /*Text(
          'Email',
          style: AppTextStyles.headline4.copyWith(fontSize: 18),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomTextField(
              hintText: "Email",
              controller: usernameController,
              errorText: emailError),
        ),
*/      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          'Egebakkeskolen\nFoodplanner',
          style: AppTextStyles.title,
          textAlign: TextAlign.center,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
          children: [
            chooseRole(),
            Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/logo.png'),
                opacity: 0.3,
                fit: BoxFit.contain,
              ),
            ),
            child: hasPinCode ? typePin() : createPin(),
          ),
          ]
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
                            onPressed: hasPinCode
                                ? (pin.length < 4
                                    ? () => handlePin(number)
                                    : null)
                                : (createPinCode.length < 4
                                    ? () => handleCreatePin("create", number)
                                    : () => handleCreatePin("confirm", number)),
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
                          onPressed: hasPinCode
                              ? () => handlePin(0)
                              : () => (createPinCode.length < 4
                                  ? handleCreatePin("create", 0)
                                  : handleCreatePin("confirm", 0)),
                          child: Text("0",
                              style: AppTextStyles.buttonTextMedium
                                  .copyWith(color: Colors.black)),
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: hasPinCode
                              ? () => deletePin
                              : () => (createPinCode.length < 4
                                  ? deleteCreatePin("create")
                                  : deleteCreatePin("confirm")),
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
