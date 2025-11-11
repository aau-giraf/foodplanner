import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/settings_widget.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/pupil.dart';
import 'package:foodplanner/services/pupil_service.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/components/settings_header.dart';
import 'package:foodplanner/services/user_service.dart';
import 'package:foodplanner/models/user.dart';

class ChooseParent extends StatefulWidget {
  final Pupil child;
  final VoidCallback? onChildChanged;
  const ChooseParent({super.key, required this.child, this.onChildChanged});
  static final PupilService childService =
      PupilService(apiUrl: ApiConfig.baseUrl);
  static final UserService userService = UserService(apiUrl: ApiConfig.baseUrl);

  @override
  ChooseParentState createState() => ChooseParentState();
}

class ChooseParentState extends State<ChooseParent>
    with SingleTickerProviderStateMixin {
  List<User> parents = [];

  @override
  void initState() {
    super.initState();
    fetchParents();
  }

  void fetchParents() {
    ChooseParent.userService.fetchAllParents().then((result) {
      setState(() {
        parents = result;
      });
    }).catchError((error) {
      throw (error);
    });
  }

  Widget ctaButtons(User parent) {
    return Row(
      children: [
        TextButton(
            onPressed: () {
              Navigator.pop(context, parent.id);
            },
            child: Text(
              'Vælg',
              style: TextStyle(
                color: Color(0xFF007AFF),
                fontSize: 16,
              ),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Vælg Forældre',
          style: AppTextStyles.headline4,
          textAlign: TextAlign.center,
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SettingsHeader(
            icon: SFIcons.sf_figure_and_child_holdinghands,
            title: 'Vælg Forældre',
            subtitle:
                'Her kan du vælge den forældre som er tilknyttet til ${widget.child.firstName}. ',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
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
              itemCount: parents.length,
              itemBuilder: (context, index) {
                final parent = parents[index];
                return SettingsWidget(
                  leftIcon: SFIcons.sf_figure_child,
                  title: '${parent.firstName} ${parent.lastName}',
                  cta: ctaButtons(parent),
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
