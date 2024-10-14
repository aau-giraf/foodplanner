import 'package:flutter/material.dart';
import 'package:foodplanner/components/icon_button.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/pages/choose_ingredient_page.dart';

class IngredientList extends StatelessWidget {
  final bool interactive;
  final TextStyle textStyle;

  const IngredientList({
    super.key,
    this.interactive = false,
    this.textStyle = AppTextStyles.standard,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 3,
      itemBuilder: (context, index) {
        return interactive ? InteractiveIngredientListElement(textStyle: textStyle) : NonInteractiveIngredientListElement(textStyle: textStyle);
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 10);
      },
    );
  }
}

class NonInteractiveIngredientListElement extends StatelessWidget {
  final TextStyle textStyle;
  
  const NonInteractiveIngredientListElement({
    super.key,
    this.textStyle = AppTextStyles.standard,
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
          offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),

      child: Row(
        children: [
          const SizedBox(width: 10),
          Text(
            'Knækbrød',
            style: textStyle,
          ),
        ]
      ),
    );
  }
}

class InteractiveIngredientListElement extends StatefulWidget {
  final TextStyle textStyle;
  final bool isActive;
  
  const InteractiveIngredientListElement({
    super.key,
    this.textStyle = AppTextStyles.standard,
    this.isActive = false,
  });

  @override
  State<StatefulWidget> createState() => _InteractiveIngredientListElementInactive(textStyle: textStyle);
}

class _InteractiveIngredientListElementInactive extends State<InteractiveIngredientListElement> {
  final TextStyle textStyle;
  bool isActive = false;
  _InteractiveIngredientListElementInactive({this.textStyle = AppTextStyles.standard});

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
        onTap: () {
        setState(() {
          isActive = true;
        });
      },
      child: Container( 
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
            offset: const Offset(0, 2), // changes position of shadow
            ),
          ],
        ),

        child: Row(
          children: [
            const SizedBox(width: 10),
            Text(
              'Knækbrød',
              style: textStyle,
            ),
            const Spacer(),

            Visibility( 
              visible: isActive, 
              child: CustomIconButton(
                onTab: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChooseIngredientPage()),
                  );
                },
                icon: const Icon(Icons.add),
                text: 'Tilføj mere',
              ),
            ),
            const SizedBox(width: 10),

            Visibility(
              visible: isActive,
              child: CustomIconButton(
                onTab: () {
                  setState(() {
                    isActive = false;
                  });
                },
                icon: const Icon(Icons.check),
                text: 'Bekræft',
                mainColor: const Color.fromARGB(255, 27, 197, 5),
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}