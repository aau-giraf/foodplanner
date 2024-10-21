import 'package:flutter/material.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../routes/index.dart';
import 'pages/login_page.dart';




void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: const MyApp(),
    ),
    );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
       
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    
      routerConfig: router,
    );
  }
}





 