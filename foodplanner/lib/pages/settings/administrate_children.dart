import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/settings_widget.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/pupil.dart';
import 'package:foodplanner/models/schoolClass.dart';
import 'package:foodplanner/services/child_service.dart';
import 'package:foodplanner/services/school_class_service.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/pages/pupil_profile.dart';
import 'package:foodplanner/components/search_field.dart';

class AdministrateChildren extends StatefulWidget {
  const AdministrateChildren({super.key});

  static final PupilService childService =
      PupilService(apiUrl: ApiConfig.baseUrl);
  static final SchoolClassService schoolClassService =
      SchoolClassService(apiUrl: ApiConfig.baseUrl);

  @override
  AdministrateChildrenState createState() => AdministrateChildrenState();
}

class AdministrateChildrenState extends State<AdministrateChildren>
    with SingleTickerProviderStateMixin {
  List<Pupil> children = [];
  List<SchoolClass> schoolClasses = [];
  List<Pupil> filteredChildren = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchChildren();

    AdministrateChildren.schoolClassService.fetchAllClasses().then((result) {
      setState(() {
        schoolClasses = result;
      });
    }).catchError((error) {
      throw (error);
    });

    searchController.addListener(_filterChildren);
  }

  void fetchChildren() {
    AdministrateChildren.childService.fetchChild().then((result) {
      setState(() {
        children = result;
        filteredChildren = result;
      });
    }).catchError((error) {
      throw (error);
    });
  }

  String getClassName(int classId) {
    final schoolClass = schoolClasses.firstWhere(
        (schoolClass) => schoolClass.classId == classId,
        orElse: () => SchoolClass(classId: 0, className: 'Unknown'));
    return schoolClass.className;
  }

  void _filterChildren() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredChildren = children.where((child) {
        final name = '${child.firstName} ${child.lastName}'.toLowerCase();
        final className = getClassName(child.classId).toLowerCase();
        return name.contains(query) || className.contains(query);
      }).toList();
    });
  }

  Widget ctaButtons(Pupil child) {
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PupilProfile(
                  child: child,
                  onChildChanged: fetchChildren,
                ),
              ),
            ).then((_) {
              fetchChildren();
            });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Row(
              children: [
                SFIcon(SFIcons.sf_chevron_backward),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Indstillinger',
                  style: AppTextStyles.headline4,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ),
        leadingWidth: 200,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SettingsWidget(
              leftIcon: SFIcons.sf_person_crop_circle_fill_badge_minus,
              title: 'Administrer Børn',
              subTitle:
                  'Her kan du se og redigere børnenes profiler, skifte deres klasser med mere. ',
              type: SettingsType.header,
            ),
            SizedBox(
              height: 20,
            ),
            SearchField(
              controller: searchController,
              hintText: 'Søg efter bruger',
            ),
            ...filteredChildren.map(
              (child) {
                return SettingsWidget(
                  leftIcon: SFIcons.sf_figure_child,
                  title:
                      '${child.firstName} ${child.lastName} - ${getClassName(child.classId)}',
                  cta: ctaButtons(child),
                  type: SettingsType.items,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
