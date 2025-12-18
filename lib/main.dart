import 'package:ambuone_moblie/core/theme/index.dart';
import 'package:ambuone_moblie/core/utils/routes/index.dart';
import 'package:ambuone_moblie/core/utils/storage/index.dart';
import 'package:ambuone_moblie/index.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedStorages().init();
  initializeDependencies();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AmbuOne',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: lightTheme,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: child,
        );
      },
    );
  }
}
