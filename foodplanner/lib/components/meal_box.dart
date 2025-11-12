import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/date_time_picker.dart';
import 'package:foodplanner/components/meal_box_content.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/routes/user_roles.dart';
import 'package:foodplanner/services/meal_notifier.dart';
import 'package:provider/provider.dart';

class ReusableMealBox extends StatefulWidget {
  const ReusableMealBox({super.key});

  @override
  State<ReusableMealBox> createState() => _ReusableMealBoxState();
}

class _ReusableMealBoxState extends State<ReusableMealBox> {
  late MealNotifier mealNotifier;

  Future<ROLES?> _retrieveRole() async {
    return await AuthProvider().retrieveRole();
  }

  @override
  void initState() {
    super.initState();
    mealNotifier = Provider.of<MealNotifier>(context, listen: false);
    mealNotifier.fetchMealData();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.background,
      surfaceTintColor: AppColors.background,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FutureBuilder(
                  future: _retrieveRole(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data == ROLES.guardian) {
                      return InkWell(
                        onTap: () => mealNotifier.selectDate(context),
                        overlayColor: WidgetStatePropertyAll(AppColors.primary),
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DateTimePickerWidget(),
                              SFIcon(SFIcons.sf_calendar, fontSize: 36),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DateTimePickerWidget(),
                            SFIcon(SFIcons.sf_calendar, fontSize: 36),
                          ],
                        ),
                      );
                    }
                  }),
            ),
            Mealboxcontent()
          ],
        ),
      ),
    );
  }
}
