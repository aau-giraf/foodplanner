import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/settings_widget.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/child.dart';
import 'package:foodplanner/models/schoolClass.dart';
import 'package:foodplanner/services/child_service.dart';
import 'package:foodplanner/services/school_class_service.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/components/settings_header.dart';
import 'package:foodplanner/pages/child_profile.dart';

class AdministrateChildren extends StatefulWidget {
  const AdministrateChildren({super.key});

  static final ChildService childService = ChildService(apiUrl: ApiConfig.baseUrl);
  static final SchoolClassService schoolClassService = SchoolClassService(apiUrl: ApiConfig.baseUrl);

  @override
  AdministrateChildrenState createState() => AdministrateChildrenState();
}

class AdministrateChildrenState extends State<AdministrateChildren> with SingleTickerProviderStateMixin{
  List<Child> children = [];
  List<SchoolClass> schoolClasses = [];


  @override
  void initState() {
    super.initState();

    AdministrateChildren.schoolClassService.fetchAllClasses().then((result) {
      setState(() {
        schoolClasses = result;
      });
    }).catchError((error) {
      throw(error);
    });

    AdministrateChildren.childService.fetchChild().then((result) {
      setState(() {
        children = result;
      });
    }).catchError((error) {
      throw(error);
    });
    
    

  }

  String getClassName(int classId){
      final schoolClass = schoolClasses.firstWhere((schoolClass) => schoolClass.classId == classId, orElse: () => SchoolClass(classId: 0, className: 'Unknown'));
      return schoolClass.className;
    }

  Widget ctaButtons(Child child) {
    return Row(
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          icon: SFIcon(
            SFIcons.sf_chevron_right,
            color: AppColors.textPrimary,
            fontSize: 28,
          ),
          onPressed: () {
            Navigator.push(context, 
              MaterialPageRoute(
                builder: (context) => ChildProfile(child: child),
                ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Indstillinger',
          style: AppTextStyles.headline4,
          textAlign: TextAlign.center,
          
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SettingsHeader(
            icon: SFIcons.sf_figure_and_child_holdinghands,
            title: 'Administrer Børn',
            subtitle: 'Her kan du se og redigere børnenes profiler, skifte deres klasser med mere. ',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  SFIcon(
                    SFIcons.sf_magnifyingglass,
                    color: AppColors.textPrimary,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Søg efter børn',
                        border: InputBorder.none,
                      ),
                      style: AppTextStyles.bigText,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: children.length,
              itemBuilder: (context, index) {
                final child = children[index];
                return SettingsWidget(
                  leftIcon: SFIcons.sf_figure_child,
                  title: '${child.firstName} ${child.lastName} - ${getClassName(child.classId)}',
                  cta: ctaButtons(child),
                  type: SettingsType.items,
                );
              },
            ),
          )

        ],
      ),
    );
  }
}
