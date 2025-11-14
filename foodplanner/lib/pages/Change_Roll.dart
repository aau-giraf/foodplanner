import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/routes/user_roles.dart';
import 'package:foodplanner/routes/paths.dart'; // contains ADMIN_ROOT, TEACHER_ROOT, etc.

class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});

  @override
  State<RoleSelectionPage> createState() => _SelectionPageRoleState();
}

class _SelectionPageRoleState extends State<RoleSelectionPage> {
  String? _selectedRole;

  Future<void> _selectRole(String role) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    await auth.setRole(role as ROLES);
    await auth.loadFromStorage();
    setState(() => _selectedRole = role);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Rolle sat til: $role')),
    );

   
    String targetPath;
    if (role == ROLES.admin) {
      targetPath = ADMIN_ROOT;
    } else if (role == ROLES.teacher) {
      targetPath = TEACHER_ROOT;
    } else {
      targetPath = '/';
    }


    GoRouter.of(context).go(targetPath);
  }

  @override
  Widget build(BuildContext context) {
  
    final roles = <Map<String, dynamic>>[
      {'key': ROLES.teacher, 'label': 'Lærer'},
      {'key': ROLES.admin, 'label': 'Admin'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vælg rolle'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: roles.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final roleEntry = roles[i];
          final rawKey = roleEntry['key'];
          final key = rawKey is String ? rawKey : rawKey.toString();
          final label = roleEntry['label'] as String;
          final selected = _selectedRole == key;
          return ListTile(
            leading: Icon(
              selected ? Icons.check_circle : Icons.circle_outlined,
              color: selected ? Colors.green : Colors.grey,
            ),
            title: Text(label),
            onTap: () => _selectRole(key),
          );
        },
      ),
    );
  }
}