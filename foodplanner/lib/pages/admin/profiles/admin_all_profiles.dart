import 'package:flutter/material.dart';
import 'package:foodplanner/components/card_container.dart';
import 'package:foodplanner/components/custom_app_bar.dart';
import 'package:foodplanner/components/loading_animation.dart';
import 'package:foodplanner/components/right_icon_button.dart';
import 'package:foodplanner/components/scroll_bar.dart';
import 'package:foodplanner/components/search_field.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/models/user.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/user_service.dart';
import 'package:foodplanner/components/nav_bar.dart';
import 'package:foodplanner/pages/admin/profiles/admin_one_profile.dart';

class AdminAllProfilesPage extends StatefulWidget {
  static final UserService userService = UserService(apiUrl: ApiConfig.baseUrl);
  const AdminAllProfilesPage({super.key});

  @override
  State<AdminAllProfilesPage> createState() => _AdminAllProfilesPageState();
}

class _AdminAllProfilesPageState extends State<AdminAllProfilesPage> {
  TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  List<User> users = [];
  List<User> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
    searchController.addListener(_filterUsers);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterUsers);
    searchController.dispose();
    super.dispose();
  }

  void _loadUsers() async {
    
    setState(() {
      _isLoading = true;
    });

    try {

      users = await AdminAllProfilesPage.userService.fetchAllUsers();

      setState(() {
        filteredUsers = users;
      });

      await Future.delayed(Duration(milliseconds: 400)); // buffer to ensure enough time to fetch all users

    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Tror ikke den her virker
  void _filterUsers() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredUsers = users.where((user) {
        final name = '${user.firstName} ${user.lastName}'.toLowerCase();
        return name.contains(query);
      }).toList();
    });
  }

  Widget _buildUserTile(User user) {
    return Padding( 
      padding: EdgeInsetsGeometry.only(right: 30, left: 5), 
      child: RightIconButton(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        buttonText: '${user.firstName} ${user.lastName}',
        alignment: MainAxisAlignment.end,
        onTab: () async {
          final changed = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AdminOneProfilePage(user: user, isApproved: true)), // hardcoded info, should be changed 
          );
          if (changed == true) {
            _loadUsers(); // refresh list
            searchController.clear(); // clear the controller
          }
        },
      ),
    );
  }

  Widget _buildUserList(){
    return ScrollConfiguration(
      // this ensure that the default scrollbar is not shown
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false), 
      child: CustomScrollbar ( 
        controller: _scrollController,
        padding: EdgeInsets.all(10),
        child: ListView.separated(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(vertical: 10),
          clipBehavior: Clip.antiAlias,
          itemCount: filteredUsers.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) => _buildUserTile(filteredUsers[index]),
        ),
      ),
    );
  }

  Widget _buildSearchField(){
    return SearchField(
      controller: searchController, 
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
    );
  }

  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;

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
        title: 'Administrér \n profiler',
        materialIcon: Icon(
          Icons.manage_accounts_outlined,
          size: 30,
        ),
        screenHeight: screenHeight,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(
              'Alle profiler',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
              child: _buildSearchField(),
            ),
            Expanded(
              child: CardContainer(
                color: AppColors.background,
                childWidget: _buildUserList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(),
    );
  }
}
