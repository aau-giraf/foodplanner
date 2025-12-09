import 'package:flutter_test/flutter_test.dart';
import 'package:foodplanner/navigation/navigation_service.dart';
void main() {
  group('NavigationService', () {

    /*
    //Denne kører før hver test og nulstiller den statiske tilstand.
    setUp(() {
      NavigationService.setCurrentPage(0);
    });
    */
    test('getCurrentPage should return the correct value', (){
      //arrange - ikke nødvendig

      //act - ikke nødvendig for at teste initial værdi.

      //assert
      expect(NavigationService.getCurrentPage(), 0);
      
    });
    test('setCurrentPage should update currentPageIndex', () {
      //arrange - ikke nødvendig

      //Act
      NavigationService.setCurrentPage(1);

      //Assert
      expect(NavigationService.getCurrentPage(), 1);

      NavigationService.setCurrentPage(5);
      expect(NavigationService.getCurrentPage(), 5);
    });
  });
}