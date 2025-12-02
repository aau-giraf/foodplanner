import 'dart:async';
import 'dart:math' as math;
import 'package:foodplanner/components/card_container.dart';
import 'package:foodplanner/components/collapsible_list_scrollable.dart';
import 'package:foodplanner/components/custom_app_bar.dart';
import 'package:foodplanner/components/loading_animation.dart';
import 'package:foodplanner/components/nav_bar.dart';
import 'package:foodplanner/components/right_icon_button.dart';
import 'package:foodplanner/components/search_field.dart';
import 'package:foodplanner/components/text_field_card.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/pupil.dart';
import 'package:foodplanner/pages/landing_page_guardian.dart';
import 'package:foodplanner/pages/signup_page_pupil.dart';
import 'package:foodplanner/pages/feedback_chat_page.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/pupil_service.dart';
import 'package:foodplanner/services/user_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'dart:developer' as developer;

class ChooseChildGuardian extends StatefulWidget {
  const ChooseChildGuardian({super.key});

  @override
  State<ChooseChildGuardian> createState() =>
      _ChooseChildGuardianState();
}

class _ChooseChildGuardianState extends State<ChooseChildGuardian> {

  AuthProvider get authProvider => Provider.of<AuthProvider>(context, listen: false);

  final UserService userService = UserService(apiUrl: ApiConfig.baseUrl);
  final PupilService pupilService = PupilService(apiUrl: ApiConfig.baseUrl);

  final _singleUseCodeController = TextEditingController();
  final _searchFieldController = TextEditingController();
  final _scrollController = ScrollController();

  List<Pupil> _children = [];
  List<Pupil> _filteredChildren = [];

  bool _isLoading = true;
  bool _isExpanded = false;
  int? _currentlyExpandedIndex;

  @override
  void initState() {
    super.initState();
    _loadChildren(); // loads all children to initialize collapsible list 
  }

  @override
  void dispose() {
    _singleUseCodeController.dispose();
    _searchFieldController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  
  // method for retrieving the children of the logged in parent
  Future<void> _loadChildren() async {
    setState(() => _isLoading = true); // ensures that a loading animation is shown as long as the children are being loaded
    try {
      await authProvider.loadFromStorage();

      try {
        _children = await pupilService.fetchPupilByParent();
      } catch (e) {
        developer.log('Could not fetch children: $e');
      }

      await Future.delayed(Duration(milliseconds: 400)); // buffer to ensure enough time to fetch all children

      if (mounted) { // checks whether the object is part of a tree
        setState(() {
          _filteredChildren = _children; // ensures that all children are shown
          _isLoading = false;
        });
      }
    } catch (e) {
      developer.log('Error initializing children: $e'); 
    }
  }

  // method for filtering the collapsible list based on input in search field
  void searchFunction(String input){
    setState(() {
      _filteredChildren = _children.where((child) {
        // pass both strings as lowercase to ensure case-insensitivity
        final fullName = "${child.firstName} ${child.lastName}".toLowerCase(); 
        final searchInput = input.toLowerCase();
        return fullName.contains(searchInput); // return all elements where the input is part of the full name
      }).toList();
    });
  }

  
  Future<void> findExistingChild(String email) async {
    // OBS: Placeholder method - should be used for finding a child based on single-use code
  }

  Widget _buildSingleUseComponent(){
    return CardContainer(
      color: AppColors.background,
        childWidget: Column(
          children: [
            SizedBox(height: 10),
            Text(
              'Tilføj barn via engangskode',
              style: AppTextStyles.title,
            ),
            TextFieldCard(
              hintText: "Engangskode...", 
              controller: _singleUseCodeController
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    // animation shown if the children are still being loaded
    if(_isLoading) {
      return const Center(
        child: LoadingAnimation(
          imagePath: 'assets/images/logo.png',
          size: 50.0, 
        )
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: "Vælg barn", materialIcon: 
        Icon(
          Icons.escalator_warning,
          size: 30,
        )
      ),
      backgroundColor: Colors.white, 

      body: Column (
        children: [
          Padding( padding: EdgeInsetsGeometry.only(top: 15)),
          // component for search field and collapsible list
          CardContainer(
              clipBehavior: Clip.antiAlias,
              color: AppColors.background,
              childWidget: Column(
                children: [
                  if(_children.length > 1)
                  SearchField(
                    controller: _searchFieldController, 
                    onChanged: searchFunction, 
                    borderRadius: 30, 
                    backgroundColor: Colors.white, 
                    horizontalPadding: 5, 
                    verticalPadding: 5, 
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.textFieldBorderFocus.withAlpha(100),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: _isExpanded ? math.min(_children.length * 65.0 + 130, 250) : math.min(_children.length * 65.0, 250),
                    child: 
                  CollapsibleListScrollable(
                    elements: _filteredChildren, 
                    controller: _scrollController, 
                    currentlyExpandedIndex: _currentlyExpandedIndex,
                    // redirection corresponding to the buttons; OBS: change this to the correct ones 
                    onFeedback: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FeedbackChatPage())), 
                    onLunch: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GuardianLandingPageMadpakke())), 
                    onSettings: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChooseChildGuardian())), 

                    // ensures that only one element is expanded at the time 
                    onExpansionChanged: (newIndex) => setState(() {
                      _currentlyExpandedIndex = newIndex;
                      _isExpanded == false ? _isExpanded = true : _isExpanded = false;
                    }),
                  ),
                  ),
                ],
              ),
            ),

          // "Opret barn" button
          RightIconButton(
            buttonText: "Tilføj barn",
            onTab: () async {
              bool? created = await Navigator.push(context, MaterialPageRoute(builder: (_) => CreatePupilPage()));
              if (created == true){ // ensures that the children are loaded again, if a new child has been registered
                _loadChildren();
              }
            },
            materialIcon: Icon(Icons.add_reaction_outlined),
          ),

          // element for single-time use code functionality
          _buildSingleUseComponent(),

        ],
      ),
      bottomNavigationBar: NavBar(currentPageIndex: 0), // OBS: the old navigation bar is used, must be updated
    );
  }
}