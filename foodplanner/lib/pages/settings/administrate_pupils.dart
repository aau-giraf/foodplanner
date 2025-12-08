import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/settings_widget.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/pupil.dart';
import 'package:foodplanner/models/schoolClass.dart';
import 'package:foodplanner/services/pupil_service.dart';
import 'package:foodplanner/services/school_class_service.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/pages/pupil_profile.dart';
import 'package:foodplanner/components/search_field.dart';

class AdministratePupils extends StatefulWidget {
  const AdministratePupils({super.key});

  static final PupilService pupilService =
      PupilService(apiUrl: ApiConfig.baseUrl);
  static final SchoolClassService schoolClassService =
      SchoolClassService(apiUrl: ApiConfig.baseUrl);

  @override
  AdministratePupilsState createState() => AdministratePupilsState();
}

class AdministratePupilsState extends State<AdministratePupils>
    with SingleTickerProviderStateMixin {
  List<Pupil> pupils = [];
  List<SchoolClass> schoolClasses = [];
  List<Pupil> filteredPupils = [];
  TextEditingController searchController = TextEditingController();
  

  @override
  void initState() {
    super.initState();
    fetchPupils();

    AdministratePupils.schoolClassService.fetchAllClasses().then((result) {
      setState(() {
        schoolClasses = result;
      });
    }).catchError((error) {
      throw (error);
    });

    searchController.addListener(_filterChildren);
  }

  void fetchPupils() {
    AdministratePupils.pupilService.fetchPupil().then((result) {
      setState(() {
        pupils = result;
        filteredPupils = result;
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
      filteredPupils = pupils.where((pupil) {
        final name = '${pupil.firstName} ${pupil.lastName}'.toLowerCase();
        final className = getClassName(pupil.classId).toLowerCase();
        return name.contains(query) || className.contains(query);
      }).toList();
    });
  }

  Widget ctaButtons(Pupil pupil) {
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
                  pupil: pupil,
                  onPupilChanged: fetchPupils,
                ),
              ),
            ).then((_) {
              fetchPupils();
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
            ...filteredPupils.map(
              (pupil) {
                return SettingsWidget(
                  leftIcon: SFIcons.sf_figure_child,
                  title:
                      '${pupil.firstName} ${pupil.lastName} - ${getClassName(pupil.classId)}',
                  cta: ctaButtons(pupil),
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
