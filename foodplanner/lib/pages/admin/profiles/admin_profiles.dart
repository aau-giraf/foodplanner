import 'package:flutter/material.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/card_container.dart';
import 'package:foodplanner/components/custom_app_bar.dart';
import 'package:foodplanner/components/loading_animation.dart';
import 'package:foodplanner/components/nav_bar.dart';
import 'package:foodplanner/components/right_icon_button.dart';
import 'package:foodplanner/components/scroll_bar.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/pages/admin/profiles/admin_all_profiles.dart'; 
import 'package:foodplanner/models/user.dart';
import 'package:foodplanner/services/user_service.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/pages/admin/profiles/admin_one_profile.dart';

class AdminProfilesPage extends StatefulWidget {
  const AdminProfilesPage({super.key});
  static final UserService userService = UserService(apiUrl: ApiConfig.baseUrl);

  @override
  State<AdminProfilesPage> createState() => _AdminProfilesPageState();
}

class _AdminProfilesPageState extends State<AdminProfilesPage> {
  List<User> _users = [];
  bool _isLoading = true;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final users = await AdminProfilesPage.userService.fetchApproveUsers();
      if(!mounted) return;
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading users: $e');
      if(!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildRequestHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Aktive anmodninger',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        SizedBox(width: 10),
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Center (
            child: Text(
              '${_users.length}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserTile(User user) {
    return Padding( 
      padding: EdgeInsets.only(right: 30, left: 5), 
      child: RightIconButton(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        buttonText: '${user.firstName} ${user.lastName}',
        alignment: MainAxisAlignment.spaceBetween,
        trailingWidget: CircleAvatar(
          radius: 11,
          backgroundColor: AppColors.primary,
          child: const Text('!', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        onTab: () async {
          final changed = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AdminOneProfilePage(user: user, isApproved: false)), // hardcoded info, should be changed
          );
          if (changed == true) {
            _loadUsers(); // refresh list
          }
        },
      ),
    );
  }

  Widget _buildRequestList() {

    if (_users.isEmpty){
      return const Center(
                child: Text('Ingen anmodninger lige nu')
              );
    }

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
          itemCount: _users.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) => _buildUserTile(_users[index]),
        ),
      ),
    );
  }

  Widget _buildAllProfilesButton() {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
      child: CustomButton(
        onTab: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminAllProfilesPage()
            ),
          );
        },
        text: 'Alle Profiler',
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        mainAxisAlignment: MainAxisAlignment.start,
        size: ButtonSize.medium,
        textStyle: AppTextStyles.buttonTextMedium.copyWith(fontWeight: FontWeight.normal),
      )
    );
  }

  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;

    if (_isLoading){
      return const Center(
        child: LoadingAnimation(
          imagePath: 'assets/images/logo.png',
          size: 50.0, 
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Administrér \n profiler',
        materialIcon: Icon(
          Icons.manage_accounts_outlined,
          size: 30,
        ),
        screenHeight: screenHeight,
      ),
      body: Column (
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 15),
          _buildRequestHeader(),
          Expanded(
              child: CardContainer(
                color: AppColors.background,
                child: _buildRequestList(),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: _buildAllProfilesButton(),
          ),
        ],
      ),
      bottomNavigationBar: NavBar(),
    );
  }
}