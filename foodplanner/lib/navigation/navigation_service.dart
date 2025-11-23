
import 'package:foodplanner/api/openapi/lib/api.dart';
import 'package:foodplanner/models/user_roles.dart';
import 'package:foodplanner/navigation/navbar_strategy_mapper.dart';
import 'package:foodplanner/navigation/navigation_strategy.dart';

class NavigationService {

  static int currentPageIndex = 0;
  static void setCurrentPage(int index) {
    currentPageIndex = index;
  }

  static int getCurrentPage() {
    return currentPageIndex;
  }
}