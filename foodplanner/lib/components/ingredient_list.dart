import 'package:flutter/material.dart';
import 'package:foodplanner/components/icon_button.dart';
import 'package:foodplanner/pages/choose_ingredient_page.dart';

class IngredientList extends StatelessWidget {
  const IngredientList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 3,
      itemBuilder: (context, index) {
        return IngredientListElement();
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 10);
      },
    );
  }
}

class IngredientListElement extends StatelessWidget {
  const IngredientListElement({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container( 
      width: MediaQuery.sizeOf(context).width,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        //border: Border.all(color: Colors.grey),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 1,
          offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),

      child: Row(
        children: [
          SizedBox(width: 10),
          Text(
            'Knækbrød',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          const Spacer(),

          CustomIconButton(
            onTab: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChooseIngredientPage()),
              );
            },
            icon: const Icon(Icons.add),
            text: 'Tilføj mere',
          ),
          const SizedBox(width: 10),

          CustomIconButton(
            onTab: () {

            },
            icon: const Icon(Icons.check),
            text: 'Bekræft',
            mainColor: const Color.fromARGB(255, 27, 197, 5),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}