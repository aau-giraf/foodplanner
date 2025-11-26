import 'package:flutter/material.dart';
import 'package:foodplanner/components/collapsible_list.dart';
import 'package:foodplanner/components/scroll_bar.dart';
import 'package:foodplanner/models/pupil.dart';
import 'package:foodplanner/models/schoolClass.dart';

// Class for creating a scroll view for a single child, with a collapsible list
class CollapsibleListScrollable<T> extends StatelessWidget {
  final List<T> elements; // this is the list used for the collapsible list (children or schoolclasses)
  final int? currentlyExpandedIndex;
  final ScrollController controller;
  final Pupil? pupil;
  final SchoolClass? schoolClass;
  final ValueChanged<int?> onExpansionChanged;
  final VoidCallback onFeedback;
  final VoidCallback onLunch;
  final VoidCallback onSettings;

  const CollapsibleListScrollable({
    super.key,
    required this.elements,
    required this.controller,
    required this.currentlyExpandedIndex,
    this.pupil,
    this.schoolClass,
    required this.onExpansionChanged,
    required this.onFeedback,
    required this.onLunch,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
        // this ensure that the default scrollbar is not shown
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: CustomScrollbar(
          controller: controller,
          child: ListView.builder(
            controller: controller,
            itemCount: elements.length,
            itemBuilder: (context, i) {
              final element = elements[i];
              return CollapsibleList(
                // collapsible list is renderes based on type of element (Child or Classroom)
                pupil: element is Pupil ? element : null,
                schoolClass: element is SchoolClass ? element : null,
                headerText: element is Pupil ? "${element.firstName} ${element.lastName}" : element is SchoolClass ? element.className : "",
                isExpanded: currentlyExpandedIndex == i, 

                // redirection corresponding to the buttons; OBS: change this to the correct ones 
                onFeedback: onFeedback, 
                onLunch: onLunch,
                onSettings: onSettings,

                // ensures that only one element is expanded at the time 
                onHeaderTap: () => onExpansionChanged(
                  currentlyExpandedIndex == i ? null : i,
                ),
              );
            },
          ),
        ),
      );
  }
}