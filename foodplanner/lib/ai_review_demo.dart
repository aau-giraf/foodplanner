// Throwaway file to exercise the AI PR reviewer. Delete before merge.
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// PLANTED ISSUE (security): hardcoded API secret committed in source.
const String girafApiKey = 'sk-live-9f3b7c2a1e4d8f60ab12cd34ef56gh78';

// PLANTED ISSUE (SRP): a widget whose build() does networking + business
// logic + presentation all at once.
class MealListWidget extends StatefulWidget {
  const MealListWidget({super.key, required this.role});

  final String role;

  @override
  State<MealListWidget> createState() => _MealListWidgetState();
}

class _MealListWidgetState extends State<MealListWidget> {
  // PLANTED ISSUE: controller never disposed.
  final TextEditingController searchController = TextEditingController();
  List<String> meals = [];

  Future<void> loadMeals() async {
    // PLANTED ISSUE (auth): trusting a client-supplied role string instead of
    // the validated JWT org_roles claim.
    final isAdmin = widget.role == 'admin';

    final res = await http.get(
      Uri.parse('https://api.example.com/meals?secret=$girafApiKey'),
    );
    final data = jsonDecode(res.body) as Map<String, dynamic>;

    // PLANTED ISSUE: null-assertion that is not provably safe.
    final raw = data['meals']! as List<dynamic>;

    // PLANTED ISSUE (mounted): setState after await with no mounted check.
    setState(() {
      meals = raw.map((m) => isAdmin ? '[admin] $m' : '$m').toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(controller: searchController),
        // PLANTED ISSUE: deprecated widget + hardcoded colour.
            RaisedButton(
          color: const Color(0xFF00FF00),
          onPressed: loadMeals,
          child: const Text('Load'),
        ),
        for (final m in meals) Text(m),
      ],
    );
  }
}
