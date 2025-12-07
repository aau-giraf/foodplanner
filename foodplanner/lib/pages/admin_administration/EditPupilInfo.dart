import 'package:flutter/material.dart';
import 'package:foodplanner/models/pupil.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/components/nav_bar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:foodplanner/services/child_service.dart';
import 'package:foodplanner/services/school_class_service.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/models/schoolClass.dart';
import 'package:foodplanner/components/custom_app_bar.dart';
import 'package:foodplanner/components/popup_box.dart';
import 'package:foodplanner/models/pupil_data.dart';

class EditPupilInfo extends StatefulWidget {
  final Pupil pupil;
  const EditPupilInfo({super.key, required this.pupil});
  static final SchoolClassService _schoolClassService =
      SchoolClassService(apiUrl: ApiConfig.baseUrl);
  static final ChildService _pupilService =
      ChildService(apiUrl: ApiConfig.baseUrl);

  @override
  State<EditPupilInfo> createState() => _EditPupilState();
}

class _EditPupilState extends State<EditPupilInfo>{
  String? selectedValue;
  Future<List<SchoolClass>> classesFuture =
    EditPupilInfo.schoolClassService.fetchAllClasses();
  List<SchoolClass> classes = [];
  bool loading = false;
  late Pupil _currentPupil;
  int _numberOfEdits = 0;

  int edits = 0;

  @override
  void initState() {
    super.initState();
    _currentPupil = Pupil(
      id: 0.
      firstName: 'Unknown',
      lastName: 'Unknown',
      email: 'Unknown',
      classId: '',
    );
    _editedData = PupilData.fromPupil(_currentPupil);

    selectedValue = widget.pupil.classId?.toString();
    fetchClasses();
    //_loadChildren();
  }

  bool get hasChanges => _numberOfEdits > 0;

  bool get isFirstNameEdited
    => _editedData.firstName.trim()
    != _currentPupil.firstName.trim();
  bool get isLastNameEdited
    => _editedData.lastName.trim()
    != _currentPupil.lastName.trim();
  bool get isEmailEdited
    => _editedData.email.trim()
    != _currentPupil.email.trim();
  /*bool get isParentsEdit
    => _editedData.parents.trim()
    != _currentPupil.parents.trim();*/
  bool get isClassIdEdited
    => _editedData.classId.trim()
    != _currentPupil.classId.trim();

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> _showSnackBar(String text, Color color){
    final messenger = ScaffoldMessenger.of(context);
    return messenger.showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: color,
        duration: Duration(seconds: 5),
      ),
    );
  }

  void deleteCurrentPupil() async {

  }

  Future<void> fetchClasses() async {
    setState(() => loading = true);
    try {
      // Tilpas kaldet til din service: sørg for fetchAllClasses() returnerer List<SchoolClass>
      final fetched = await EditPupilInfo.schoolClassService.fetchAllClasses();
      setState(() {
        classes = fetched;
        // Hvis selectedValue stadig ikke er sat, sæt ud fra pupil hvis muligt
        if (selectedValue == null && widget.pupil.classId != null) {
          selectedValue = widget.pupil.classId.toString();
        }
      });
    } catch (e) {
      // Håndter fejl (fx vis snackbar). Debug print kan hjælpe under udvikling.
      // debugPrint('fetchClasses error: $e');
    } finally {
      setState(() => loading = false);
    }
  }

  // Næste trin jeg skal igennem
  /*Future<void> _loadChildren() async {
    setState(() => loading = true); // ensures that a loading animation is shown as long as the children are being loaded
    try {
      await authProvider.loadFromStorage();

      try {
        _children = await pupilService.fetchPupilByParent();
      } catch (e) {
        developer.log('Could not fetch children: $e');
      }

      await Future.delayed(Duration(milliseconds: 400)); // buffer to ensure enough time to fetch all children

      if (mounted) { // checks whether the object is part of a tree
        setState(() {
          _filteredChildren = _children; // ensures that all children are shown
          loading = false;
        });
      }
    } catch (e) {
      developer.log('Error initializing children: $e'); 
    }
  }*/

  Future<void> saveChanges() async {
    try {
      await _pupilService.updatedPupil(
        _currentPupil.id,
        isFirstNameEdited ? _editedData.firstName : _currentPupil.firstName,
        isLastNameEdited ? _editedData.lastName : _currentPupil.lastName,
        isEmailEdited ? _editedData.email : _currentPupil.email,
        //isParentsEdit
        isClassIdEdited ? _editedData.classId : _currentPupil.classId,
      );
    }
  }

  void _calculateNumberOfEdits() {
    setState((){
      _numberOfEdits = 0;
      if(isFirstNameEdited) _numberOfEdits++;
      if(isLastNameEdited) _numberOfEdits++;
      if(isEmailEdited) _numberOfEdits++;
      // Parent
      if(isClassIdEdited) _numberOfEdits++;
    });
  }

  // Helper methods for updating data
  void updateFirstName(String value) {
    _editedData.firstName = value;
    _calculateNumberOfEdits();
  }

  void updateLastName(String value){
    _editedData.lastName = value;
    _calculateNumberOfEdits();
  }

  void updateEmail(String value){
    _editedData.email = value;
    _calculateNumberOfEdits();
  }

  /*void updateParents(String value){
    _editedData.parents = value;
    _calculateNumberOfEdits();
  }*/

  void updateClassId(String value){
    _editedData.classId(String value);
    _calculateNumberOfEdits();
  }

  Widget _buildEditableFields(Pupil pupil){
    return Column(
      children: [
        SizedBox(height:10),
        EditablePupilInfoTile(
          // fornavn
          title: 'Fornavn',
          initialValue: '',
          onChanged: updatedFirstName,
          hintText: _currentPupil.firstName,
          obsure: false,
        ),
        EditablePupilInfoTile(
          // efternavn
          title: 'Efternavn',
          initialValue: '',
          onChanged: updatedLastName,
          hintText: _currentPupil.lastName,
          obsure: false,
        ),
        EditablePupilInfoTile(
          // email
          title: 'Email',
          initialValue: '',
          onChanged: updatedEmail,
          hintText: _currentPupil.email,
          obsure: false,
        ),
        EditablePupilInfoTile(
          // klasse
          title: 'Klasse',
          initialValue: '',
          onChanged: updatedClassName,
          hintText: schoolClass.className,
          obsure: false,
        ),
        EditablePupilInfoTile(
          // forældre
          title: 'Forældre',
          initialValue: '',
          onChanged: updatedParent,
          //hintText: ${Widget.pupil.firstName},
          obsure: false,
        ),
      ]
    );
  }

  void showDeletetionPopUp(){
    showIPhonePopupBox(
      context: context,
      title: 'Slet bruger',
      message: 'Er du sikker på, at du vil slette din konto?',
      confirmText: 'Ja',
      cancelText: 'Nej',
      onConfirm: (){
        deleteCurrentPupil();
      },
      onCancel: (){
        Navigator.of(context).pop();
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Rediger information\n om elev',
      ),
      bottomNavigationBar: NavBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Card(
                  color: AppColors.background,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text('Elevens navn: ${widget.pupil.firstName} ${widget.pupil.lastName}'),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text('Vælg klasse:'),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              hint: Text(
                                'Klasse',
                              ),
                              items: classes.map((SchoolClass schoolClass) =>
                                DropdownMenuItem<String>(
                                  value: schoolClass.classId.toString(),
                                  child: Text(
                                    '${schoolClass.className}',
                                  )
                                )
                              ).toList(),
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
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.white,
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
                    iconEnabledColor: Colors.black,
                    iconDisabledColor: Colors.black,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.white,
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
                            )
                          ),
                        ),
                        const Divider(),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text('Vælg forældre ${widget.pupil.classId}'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Card(
                elevation: 2,
                color: AppColors.background,
                child: GestureDetector(
                  //onTap: deleteProfile(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Text(
                          'Slet elev',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: SFIcon(
                              SFIcons.sf_trash,
                              fontSize: 16,
                            ),
                          ),
                      ],
                    ),
                  )
                )
              ),

              const SizedBox(height: 8),
              
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Card(
                        color: AppColors.background,
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            'Annullér',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 10),

                  Expanded(
                    child: Card(
                      color: AppColors.background,
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          'Gem',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ]
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}