import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/nav_bar.dart';
import 'package:foodplanner/components/text_field.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/schoolClass.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/pupil_service.dart';
import 'package:foodplanner/services/school_class_service.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart';
class AddPupil extends StatefulWidget {
  const AddPupil({super.key});
  static final SchoolClassService schoolClassService =
      SchoolClassService(apiUrl: ApiConfig.baseUrl);
  static final PupilService pupilService =
      PupilService(apiUrl: ApiConfig.baseUrl);

  @override
  State<AddPupil> createState() => _AddPupilState();
}

class _AddPupilState extends State<AddPupil>{
  Map<int, bool> isEditing = {};
  Map<int, TextEditingController> controllers = {};
  final controller = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  String firstNameError = '';
  String lastNameError = '';
  final RegExp nameRegExp = RegExp(r'^[a-z A-ZæøåÆØÅ]+$');

  Future<List<SchoolClass>> classesFuture =
    AddPupil.schoolClassService.fetchAllClasses();
  List<SchoolClass> classes = [];

  @override
  void initState() {
    super.initState();
    firstNameController.addListener(_updateButtonState);
    lastNameController.addListener(_updateButtonState);
    classesFuture.then((classes) {
      setState(() {
        this.classes = classes;
      });
    });
  }

  void _updateButtonState() {
    setState(() {});
  }

  @override
  void dispose() {
    firstNameController.removeListener(_updateButtonState);
    lastNameController.removeListener(_updateButtonState);
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  void updateErrorState(String field, String error) {
    setState(() {
      switch (field) {
        case 'First_name':
          firstNameError = error;
          break;
        case 'Last_name':
          lastNameError = error;
          break;
      }
    });
  }

  void handleErrors(Map<String, dynamic> error) {
    updateErrorState('First_name',
        error['FirstName'] != null ? error['FirstName'][0] : '');
    updateErrorState(
        'Last_name', error['LastName'] != null ? error['LastName'][0] : '');
  }

  //Function to validate form inputs
  void validateInputs(BuildContext context) {
    String firstName = firstNameController.text.trim();
    String lastName = lastNameController.text.trim();
    int selectedClassId =
        selectedValue!.isNotEmpty ? int.parse(selectedValue!) : 0;
    //Step 1: Check om alle felter er udfyldt
    if (firstName.isEmpty || lastName.isEmpty || selectedValue == null) {
      // Show an error message if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Alle felter skal være udfyldt.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 6),
        ),
      );
      return;
    }

    //Step 2: Full Name Validation
    if (!nameRegExp.hasMatch(firstName)) {
      setState(() {
        firstNameError = 'Dit navn må kun indholde bogstaver';
      });
      return;
    } else {
      setState(() {
        firstNameError = '';
      });
    }

    if (!nameRegExp.hasMatch(lastName)) {
      setState(() {
        lastNameError = 'Dit navn må kun indholde bogstaver';
      });
      return;
    } else {
      setState(() {
        lastNameError = '';
      });
    }

    //proceed with sign-up logic if everything is correct
    createChildHandler(context, firstName, lastName, selectedValue);
    Navigator.pop(context);
  }

  //Placeholder function for sign-up logic
  void createChildHandler(
    BuildContext context,
    String firstName,
    String lastName,
    String? selectedValue,
  ) async {
    try {

      final url = Uri.parse('${ApiConfig.baseUrl}/api/Users/CreateUserChildren');

      final generatedEmail = '${firstName.toLowerCase()}${lastName.toLowerCase()}@email.dk';
      const generatedPassword = 'Test1234';

      final body = {
        "firstName": firstName,
        "lastName": lastName,
        "email": generatedEmail,
        "password": generatedPassword,
        "parentIds": [],
        "classId": selectedValue,
      };

      final response = await http.post(
        url, headers: {"Content-Type": "application/json"}, body: jsonEncode(body)
      );

      if (!context.mounted) return;

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Barn oprettet!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 6),
          ),
        );
        context.go('/');
        return;
      }

      if (response.statusCode == 400 && response.body.isNotEmpty) {
        print("400 RESPONSE: ${response.body}");
        final Map<String, dynamic> error = jsonDecode(response.body);
        handleErrors(error);
        return;
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fejl ved oprettelse af barn: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 6),
        ),
      );
    }
  }

  String? selectedValue;

  bool showButton() {
    return firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        selectedValue != null;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 200,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 25),
          child: Text(
            'Tilføj ny elev',
            style: TextStyle(fontSize: 36),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(  
        child: Column(
          children: [
            Text(
              'Elevens fornavn'
            ),
            SizedBox(width: 10),
            SizedBox(
              width: 201,
              height: 50,
              child: TextField(
                controller: firstNameController,
                decoration: InputDecoration(
                  errorText: firstNameError,
                  hintText: "Fornavn",
                  contentPadding: EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.zero),
                    borderSide: BorderSide(width: 1, color: AppColors.background)
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Elevens efternavn'
            ),
            SizedBox(width: 10),
            SizedBox(
              width: 201,
              height: 50,
              child: TextField(
                controller: lastNameController,
                decoration: InputDecoration(
                  errorText: lastNameError,
                  hintText: "Efternavn",
                  contentPadding: EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.zero),
                    borderSide: BorderSide(width: 1, color: AppColors.background)
                  ),
                ),
              )
            ),
          
            SizedBox(height: 20),
            Text(
              "Vælg klasse"
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  hint: Text(
                    'Klasse',
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  items: classes
                      .map((SchoolClass schoolClass) =>
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
                          ))
                      .toList(),
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
                            color: Colors.black,
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
                      color: AppColors.background,
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
                      thumbVisibility:
                          WidgetStatePropertyAll<bool>(true),
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
            CustomButton(
              text: 'Gem',
              onTab: showButton() ? () => validateInputs(context) : null,
              backgroundColor: AppColors.background, 
            ),
            CustomButton(
              text: 'Anullere',
              onTab: () {
                Navigator.pop(context);
              },
              backgroundColor: AppColors.background, 
            ),  
          ],
        ),
      ),
      bottomNavigationBar: NavBar(),
    );
  }
}