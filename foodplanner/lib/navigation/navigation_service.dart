class NavigationService {
  static int currentPageIndex = 0;

  static void setCurrentPage(int index) {
    currentPageIndex = index;
  }

  static int getCurrentPage() {
    return currentPageIndex;
  }
}