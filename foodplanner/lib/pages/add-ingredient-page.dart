
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddIngredientPage {

}

class IngredientList extends StatefulWidget {

  final ingredientList = <IngredientListElement>[];
  final addIngredientButton = IngredientListAddIngredientButton();
  
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }

}

class IngredientListElement extends StatefulWidget {
  final name = "default name";
  final confirmElementButton = IngredientElementConfirmButton();
  final addInfoButton = IngredientElementAddInformationButton();
  
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

class IngredientListAddIngredientButton extends State<IngredientList> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
  
}

class IngredientElementConfirmButton extends State<IngredientListElement> {
  Widget build(BuildContext context) {  
    return Column(  
      mainAxisSize: MainAxisSize.min,  
      children: <Widget>[  
        IconButton(  
          icon: Icon(Icons.check),  
          iconSize: 50,  
          color: const Color.fromARGB(255, 105, 212, 5),  
          tooltip: 'Bekræft den valgte ingredient',  
          onPressed: () {  
  
          },  
        ),
        Text('Bekræft')  
      ],  
    );
  }
}

class IngredientElementAddInformationButton extends State<IngredientListElement> {
  Widget build(BuildContext context) {  
    return Column(  
      mainAxisSize: MainAxisSize.min,  
      children: <Widget>[  
        IconButton(  
          icon: Icon(Icons.add),  
          iconSize: 50,  
          color: const Color.fromARGB(255, 243, 160, 5),  
          tooltip: 'Tilføj flere ingredientser',  
          onPressed: () {

          },  
        ),  
        Text('Tilføj mere')  
      ],  
    );
  }
}
