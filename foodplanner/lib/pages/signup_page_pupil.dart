import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart' show ButtonStyleData, DropdownButton2, IconStyleData, DropdownStyleData, MenuItemStyleData;
import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/signup_form.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/schoolClass.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/pupil_service.dart';
import 'package:foodplanner/services/school_class_service.dart';
import 'package:foodplanner/services/user_service.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;

class CreatePupilPage extends StatefulWidget {

  static final UserService userService = UserService(apiUrl: ApiConfig.baseUrl);
  static final SchoolClassService schoolClassService = SchoolClassService(apiUrl: ApiConfig.baseUrl);
  static final PupilService pupilService = PupilService(apiUrl: ApiConfig.baseUrl);

  const CreatePupilPage({super.key});

  @override
  State<CreatePupilPage> createState() => _CreatePupilPageState();
}

class _CreatePupilPageState extends State<CreatePupilPage> {

  late AuthProvider authProvider;

  Future<List<SchoolClass>> classesFuture = CreatePupilPage.schoolClassService.fetchAllClasses();

  List<SchoolClass> classes = [];

  List<int> parentIds = [];

  String? selectedValue;
  int parentId = 0;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    classesFuture.then((classes) {
      setState(() {
        this.classes = classes;
      });
    });
  }


  Future<int?> loadLoggedInParentId () async {
    try {

      var loggedInUser = await CreatePupilPage.userService.fetchLoggedInUser();
      
      print("HER ER PARENT ID: ${loggedInUser.id}");

      final int parentId = loggedInUser.id;
      print(parentId);
      return parentId;
    } catch (e) {
      developer.log('No logged in parentID found.');
    }
    return null;
  }

  Future<String> createPupilUser (String firstName, String lastName, String email, String password, List<int> parentIds, int classId) async {
    try {
      final userResponse = await SignupForm.userService.createUserPupil(firstName, lastName, email, password, parentIds, classId);

      if (userResponse.statusCode != 201) {
        var error = jsonDecode(userResponse.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fejl ved oprettelse af bruger: $error'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
      }
      print(userResponse.body);
      return userResponse.body;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fejl ved oprettelse af bruger: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
    }
    return '';
  }

  // Sign up logic for a Pupil 
  void signChildUp(
    BuildContext context, 
    String firstName, 
    String lastName, 
    String email, 
    String password, 
    int classId) async {

      try {

        final int? parentId = await loadLoggedInParentId();
        if (parentId == null) {
          throw Exception("Parent ID is null");
        }

        print(parentId);

        parentIds = [parentId];
        
        final userResponseBody = await createPupilUser(firstName, lastName, email, password, parentIds, classId);

        if (userResponseBody == "") {
          throw Exception("User creation failed.");
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Barn oprettet!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 5),
            ),
          );
        
        await Future.delayed(const Duration(seconds: 1)); // buffer
        Navigator.pop(context, true);

      } catch (e) {
        if (!context.mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fejl ved oprettelse af barn: $e'),
            backgroundColor: AppColors.errorText,
            duration: Duration(seconds: 5),
          )
        );

      }
  }

  Widget classSelection(){
    return Column(
      children: [
        SizedBox(height: 15),
        Text(
          'Klasse',
          style: AppTextStyles.bigText.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true,
              hint: Text(
                'Vælg klasse',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              items: classes.map((SchoolClass schoolClass) =>
                                  DropdownMenuItem<String>(
                                    value: schoolClass.classId.toString(),
                                    child: Text(
                                      schoolClass.className,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )).toList(),
              value: selectedValue,
              onChanged: (String? value) {
                setState(() {
                  selectedValue = value;
                });
              },
              selectedItemBuilder: (BuildContext context) {
                return classes.map((SchoolClass schoolClass) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      schoolClass.className,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList();
              },
              buttonStyleData: ButtonStyleData(
                height: 50,
                width: 200,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: AppColors.primary,
                ),
                elevation: 2,
              ),
              iconStyleData: const IconStyleData(
                icon: SFIcon(
                  SFIcons.sf_chevron_forward,
                ),
                openMenuIcon: SFIcon(
                  SFIcons.sf_chevron_down,
                ),
                iconSize: 16,
                iconEnabledColor: AppColors.textSecondary,
                iconDisabledColor: Colors.grey,
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 200,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: AppColors.background,
                ),
                scrollbarTheme: ScrollbarThemeData(
                  radius: const Radius.circular(40),
                  thickness: WidgetStatePropertyAll<double>(6),
                  thumbVisibility: WidgetStatePropertyAll<bool>(true),
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 40,
                padding: EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build (BuildContext context) {
    return SignupForm(
      title: 'Opret barn', 
      buttonText: 'Opret barn', 
      selection: classSelection(), 
      onSubmit: (fields) async {
        signChildUp(context, 
          fields["firstName"]!, 
          fields["lastName"]!,
          fields["email"]!,
          fields["password"]!,
          int.parse(selectedValue!),
        );
      }
    );
  }

}

